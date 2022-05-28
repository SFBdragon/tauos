# just & sh build script
# written to run on wsl, with qemu installed on windows
# if you're on linux change qemu-system-x86_64.exe -> qemu-system-x86_64

arch            := 'x86_64'
config          := 'debug'

wrk_dir         := justfile_directory()


tgt_dir         := join(wrk_dir, 'target')
# EFI System Partition
esp_dir         := join(tgt_dir, 'esp')
esp_boot_dir    := join(esp_dir, 'EFI', 'BOOT')
# TauOS System Partition
tsp_dir         := join(tgt_dir, 'tsp')
tsp_sys_dir     := join(tsp_dir, 'sys')
tsp_knl_dst     := join(tsp_sys_dir, 'kernel')
# INITRD
ird_dir         := join(tgt_dir, 'initrd')
ird_sys_dir     := join(ird_dir, 'sys')
ird_knl_dst     := join(ird_sys_dir, 'kernel')


# kernel build
knl_dir         := join(wrk_dir, 'kernel')
knl_tgt         := arch + '-unknown-none-gnu'
knl_tgt_file    := join(knl_dir, knl_tgt + '.json')
knl_build_dir   := join(tgt_dir, 'kernel')
knl_out_exe     := join(knl_build_dir, knl_tgt, config, 'kernel')


dev_dir         := join(wrk_dir, 'dev')
mkbootimg       := join(dev_dir, 'mkbootimg.exe')

ovmf_code       := join(dev_dir, 'OVMF_CODE-pure-efi.fd')
ovmf_vars       := join(dev_dir, 'OVMF_VARS-pure-efi.fd')


cargo_bld_std   := '-Z build-std-features=compiler-builtins-mem -Z build-std=core,compiler_builtins,alloc'
cargo_idn_knl   := '--package kernel --target ' + knl_tgt_file + ' --target-dir ' + knl_build_dir
cargo_knl_bld   := cargo_idn_knl + ' ' + cargo_bld_std

check profile='dev':
    cargo +nightly check --profile {{profile}} {{cargo_knl_bld}}

build profile='dev':
    cargo +nightly build --profile {{profile}} {{cargo_knl_bld}}
    
    #strip --strip-all -K mmio -K fb -K bootboot -K environment -K initstack {{knl_out_exe}}

    @# tsp setup
    rm -r -f {{tsp_dir}}
    mkdir -p {{tsp_sys_dir}}
    cp {{knl_out_exe}} {{tsp_knl_dst}}

    @# initrd setup
    rm -r -f {{ird_dir}}
    mkdir -p {{ird_sys_dir}}
    cp {{knl_out_exe}} {{ird_knl_dst}}

    @# create the disk image
    ./dev/mkbootimg diskcfg.json {{join(tgt_dir, 'disk.img')}}

    @echo ''

run profile='dev': (build profile)
    qemu-system-x86_64.exe -nodefaults -vga std -serial stdio -no-reboot \
        -drive if=pflash,format=raw,file=./dev/OVMF_CODE-pure-efi.fd,readonly=on \
        -drive if=pflash,format=raw,file=./dev/OVMF_VARS-pure-efi.fd,readonly=on \
        -machine q35 -cpu max -smp 4 -m 2G \
        -drive file=./target/disk.img,format=raw

    @echo ''

