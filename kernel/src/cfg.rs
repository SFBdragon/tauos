
macro_rules! krnl_boot_cfg {
    ($($name:ident: $type:ty = $default:expr);*) => {
        
        use core::sync::atomic::{Ordering, AtomicU8};

        static CFG_SYNC_STATE: AtomicU8 = AtomicU8::new(0);

        $(
            mod $name {
                pub static mut STATIC_DATA: $type = $default;
            }
            pub fn $name() -> $type {
                if CFG_SYNC_STATE.load(Ordering::Acquire) == 2 {
                    unsafe { $name::STATIC_DATA }
                } else {
                    panic!("cfg not initialised!");
                }
            }
        )*

        pub fn init_boot_cfg(cfg: &str) {
            match CFG_SYNC_STATE.compare_exchange(0, 1, Ordering::Acquire, Ordering::Relaxed) {
                Ok(_) => {
                    $(
                        unsafe {
                            $name::STATIC_DATA = cfg
                                .split('\n')
                                .find(|&txt| txt.trim().starts_with(stringify!($name)))
                                .map(|kvp| kvp.split_once('=').unwrap().1.trim())
                                .map_or($default, |str| <$type>::from_str_radix(str, 16)
                                .expect(concat!("invalid cfg value for ", stringify!($name), "!")));
                        }
                    )*
                    CFG_SYNC_STATE.store(2, Ordering::Release);
                },
                Err(state) => match state {
                    1 => while CFG_SYNC_STATE.load(Ordering::Acquire) == 1 {},
                    2 => (),
                    _ => panic!("unknown cfg sync state"),
                },
            }
        }
    };
}

krnl_boot_cfg!(
    stack_size: usize = 0x800000 - 0x1000;
    heap_init_size: usize = 0x1000000;
    heap_smlst_block: usize = 0x20
);
