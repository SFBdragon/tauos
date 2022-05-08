//! OS loader UEFI application.
//! 
//! THIS CODE IS RETIRED, BOOTBOOT REPLACED IT

#![no_std]
#![no_main]
#![feature(abi_efiapi)]

extern crate alloc;

use amd64::{
    registers::{self, CR0, EFER, CR3},
    paging::{self, PTE},
};

use core::{mem, slice};
use elf_rs::{Elf, ProgramType};
use log::*;
use uefi::{
    prelude::*,
    proto::console::gop, 
    table::{boot::{AllocateType, MemoryDescriptor, MemoryType}, Runtime}
};


#[no_mangle]
pub extern "efiapi" fn efi_main(image: Handle, mut st: SystemTable<Boot>) -> Status {
    
    // Initialize UEFI services
    uefi_services::init(&mut st).expect_success("Failed to initialize UEFI services");
    st.stdout().reset(false).expect_success("Failed to reset stdout");
    
    
    // Get and configure frame buffer early to avoid the wipe of previous output.
    let (frame_buffer_ptr, frame_buffer_info) = get_and_configure_framebuffer(&mut st);
    info!("Framebuffer configured...");

    // Check revision number
    let rev = st.uefi_revision();
    if rev.major() < 2 || rev.minor() < 7 {
        warn!("WARNING: Untested on revisions < 2.7");
    }


    info!("Reading kernel from disk...");
    let bin = read_kernel(&image, &mut st);
    

    // page allocator uses NXE feature
    let efer = unsafe { EFER::from_bits_unchecked(registers::rdmsr(registers::EFER_MSR)) };
    registers::wrmsr(registers::EFER_MSR, (efer | EFER::NXE).bits());

    // disable write-protect required to modify UEFI setup page tables
    unsafe { CR0::write(&(CR0::read() & !CR0::WP)); }

    info!("Loading and mapping kernel...");
    let entry_point = load_elf_kernel(&mut st, &bin) as *const ();
    let kn_start: extern "sysv64" fn(libkernel::BootPayload) -> ! = unsafe { mem::transmute(entry_point) };

    info!("Allocating and mapping kernel stack...");
    stack_setup(&mut st);

    // enable write-protect to ensure kernel doesn't accidentally read protected memory on initialization
    unsafe { CR0::write(&(CR0::read() | CR0::WP)); }

    
    // exit boot services as late as possible to avoid silent panics or allocator issues
    info!("Exiting boot services...");
    let (st, mmap) = exit_boot_services(image, st);

    // prepare handoff data & jump to kernel space
    let payload = libkernel::BootPayload {
        st,
        bin,
        mmap,
        frame_buffer_ptr,
        frame_buffer_info,
    };
    
    kn_start(payload);
}


fn get_and_configure_framebuffer(st: &mut SystemTable<Boot>) -> (*mut u8, gop::ModeInfo) {
    let gop = unsafe {
        st.boot_services().locate_protocol::<gop::GraphicsOutput>().expect_success("failed to get gop proto").get().as_mut().unwrap()
    };
    
    let model = (1920, 1080);

    let mode = gop
        .modes()
        .map(|c| c.log())
        .filter(|m| m.info().pixel_format() != gop::PixelFormat::BltOnly)
        .min_by_key(|m| {
            use core::cmp::Ordering;
            let res = m.info().resolution();
            // prioritise the resolution equal, or minimally smaller than the model resolution
            match model.0.cmp(&res.0) {
                Ordering::Equal => match model.1.cmp(&res.1) {
                    Ordering::Equal => usize::MIN,
                    Ordering::Greater => model.1 - res.1,
                    Ordering::Less => usize::MAX,
                },
                Ordering::Greater => match model.1.cmp(&res.1) {
                    Ordering::Equal => model.0 - res.0,
                    Ordering::Greater => model.0 - res.0 + model.1 - res.1,
                    Ordering::Less => usize::MAX,
                },
                Ordering::Less => usize::MAX,
            }
        });

    if let Some(mode) = mode {
        gop.set_mode(&mode).expect_success("GOP mode set failed!");
    }

    (gop.frame_buffer().as_mut_ptr(), gop.current_mode_info().clone())
}


fn alloc_payload_data(st: &mut SystemTable<Boot>, size_at_least: usize) -> u64 {
    // my firmware, and that of many others, has a bug where custom MemoryTypes cannot be used
    // https://wiki.osdev.org/UEFI#My_bootloader_hangs_if_I_use_user_defined_EFI_MEMORY_TYPE_values
    // this means that the best that can be done is allocate seperate regions of type LOADER_DATA,
    // and leave it to the kernel to figure out which LOADER_DATA regions to preseve and which not to
    // using the addresses to the payload data

    let page_count = (size_at_least + paging::PTE_MAPPED_SIZE as usize - 1) / paging::PTE_MAPPED_SIZE as usize; // round up
    st.boot_services().allocate_pages(AllocateType::AnyPages, MemoryType::LOADER_DATA, page_count)
        .expect_success("failed to allocate payload data")
}

fn exit_boot_services(image: Handle, mut st: SystemTable<Boot>) -> (SystemTable<Runtime>, &'static mut [MemoryDescriptor]) {
    // allocating the memory map may create new memory regions, thus padding is required
    let est_mmap_size = st.boot_services().memory_map_size().map_size + 4 * mem::size_of::<MemoryDescriptor>();
    let mmap_base = alloc_payload_data(&mut st, est_mmap_size);
    let mut mmap_buf = unsafe { slice::from_raw_parts_mut(mmap_base as *mut u8, est_mmap_size) };
    
    st.boot_services().memory_map(&mut mmap_buf).expect_success("failed to retrieve UEFI memory map");
    let (st_runtime, mut mmap_iter) =
        st.exit_boot_services(image, mmap_buf).expect_success("exit boot services failed!");

    // Safety: mmap_iter describes the contiguous array of MemoryDescriptors.
    // These are returned as a ExactSizeIterator as they may be expanded in future UEFI versions.
    // However, they will always be at least as large as they currently are, thus they
    // can be moved back into the buffer with the expected alignment and size, and thus
    // can be returned as a slice instead of an iterator, which simplifies ownership.
    // Remapping UEFI runtime services is version independant.
    let mmap_slice = unsafe { slice::from_raw_parts_mut(mmap_base as *mut MemoryDescriptor, mmap_iter.len()) };
    mmap_slice.fill_with(|| mmap_iter.next().unwrap().clone());

    (st_runtime, mmap_slice)
}

fn read_kernel(image: &Handle, st: &mut SystemTable<Boot>) -> &'static mut [u8] {
    use uefi::proto::media::file::{File, FileType, FileInfo, FileMode, FileAttribute};

    // todo: partition seeking

    // get EFI_SIMPLE_FILE_SYSTEM_PROTOCOL, then root directory of the volume, then the EFI_FILE_PROTOCOL handle
    let sfs = st.boot_services().get_image_file_system(*image).expect_success("failed to retrieve EFI filesystem");
    let mut fs = unsafe { sfs.interface.get().as_mut().unwrap() }.open_volume().expect_success("failed to get root of EFI filesystem.");
    let fh = fs.open("tauos\\kernel\\kernel", FileMode::Read, 
    FileAttribute::READ_ONLY | FileAttribute::HIDDEN | FileAttribute::SYSTEM).expect_success("failed to get FileHandle");
    drop(sfs);
    
    if let FileType::Regular(mut file) = fh.into_type().expect_success("failed to confirm type of FileHandle") {
        // get file size
        let file_info_size = file.get_info::<FileInfo>(&mut alloc::vec![0u8]).expect_error("get info failed").data().unwrap();
        let mut file_info_buffer = alloc::vec![0u8; file_info_size];
        let file_info = file.get_info::<FileInfo>(&mut file_info_buffer[..]).expect_success("get info failed");

        // read file
        let kn_data_len = file_info.file_size() as usize;
        let kn_data_base = alloc_payload_data(st, kn_data_len);
        let kn_data_buf = unsafe { slice::from_raw_parts_mut(kn_data_base as *mut u8, kn_data_len) };
        file.read(kn_data_buf).expect_success("kernel read failed");
        kn_data_buf
    } else {
        panic!("unexpected directory at kernel path")
    }
}

/// Returns address of kernel entrypoint
fn load_elf_kernel(st: &mut SystemTable<Boot>, elf_data: &[u8]) -> u64 {
    
    // parse ELF data
    let elf = match Elf::from_bytes(&elf_data).unwrap() {
        Elf::Elf64(e) => e,
        Elf::Elf32(_) => panic!(),
    };

    // load all program segments with p_type->PT_LOAD
    for phdr in elf.program_headers() {
        if phdr.ph_type() == ProgramType::LOAD {
            // allocate a contiguous memory region for each segment

            let page_count = (phdr.memsz() + paging::PTE_MAPPED_SIZE - 1) / paging::PTE_MAPPED_SIZE; // round up
            let segment_phys_base = alloc_payload_data(st, (page_count * paging::PTE_MAPPED_SIZE) as usize);

            // map the segment into virtual address space

            let mut leaf_entry = PTE::PRESENT;
            if phdr.flags() & 0b01 == 0 {
                leaf_entry |= PTE::NO_EXECUTE;
            }
            if phdr.flags() & 0b10 != 0 {
                leaf_entry |= PTE::WRITE;
            } 

            let pml4t = unsafe { slice::from_raw_parts_mut(CR3::read().get_paddr() as *mut PTE, 512) };

            let mut get_page = || st.boot_services().allocate_pages(
                AllocateType::AnyPages, MemoryType::LOADER_DATA, 1)
                .expect_success("failed to allocate pages for kernel map");

            unsafe {
                libkernel::memm::map_pages_when_ident(
                    &mut phdr.vaddr().clone(),
                    &mut segment_phys_base.clone(),
                    &mut page_count.clone(), 
                    PTE::PRESENT | PTE::WRITE, 
                    leaf_entry, 
                    4,
                    pml4t,
                    &mut get_page
                );
            }

            // copy data into virtual memory region

            let (p_offset, p_filesz) = (phdr.offset() as usize, phdr.filesz() as usize);
            // Safety: allocate_kernel_pages() should guarantee that this doesn't cause page fault/UB
            let dest = unsafe { slice::from_raw_parts_mut(phdr.vaddr() as *mut u8, phdr.memsz() as usize) };
            let program = &elf.as_bytes()[p_offset..p_offset + p_filesz];

            // load the program data into memory
            dest[..p_filesz].copy_from_slice(program);
            // clear the rest of memory as required
            dest[p_filesz..].fill(0);
        }
    }

    elf.header().entry_point()
}

fn stack_setup(st: &mut SystemTable<Boot>) {
    use libkernel::memm::{KERNEL_STACK_BOTTOM, KERNEL_STACK_PAGE_COUNT};

    let phys_base = alloc_payload_data(st, (KERNEL_STACK_PAGE_COUNT * paging::PTE_MAPPED_SIZE) as usize);

    let mut get_page = || st.boot_services().allocate_pages(
        AllocateType::AnyPages, MemoryType::LOADER_DATA, 1)
        .expect_success("failed to allocate pages for kernel map");
    
    unsafe {
        let pml4t = slice::from_raw_parts_mut(CR3::read().get_paddr() as *mut PTE, 512);

        let stack_virt_base = KERNEL_STACK_BOTTOM - KERNEL_STACK_PAGE_COUNT * paging::PTE_MAPPED_SIZE;
        libkernel::memm::map_pages_when_ident(
            &mut stack_virt_base.clone(),
            &mut phys_base.clone(),
            &mut KERNEL_STACK_PAGE_COUNT.clone(), 
            PTE::PRESENT | PTE::WRITE, 
            PTE::PRESENT | PTE::WRITE | PTE::NO_EXECUTE, 
            4,
            pml4t,
            &mut get_page
        );
    }
}
