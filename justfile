# just + python build scripts

arch          := 'x86_64'
config        := 'debug'

workspace_dir := justfile_directory()
target_dir    := join(workspace_dir, 'target')

# qemu fat drive paths
esp_dir       := join(target_dir, 'esp')
esp_boot_dir  := join(esp_dir, 'EFI', 'Boot')
# todo: change to seperate when partition seek is fixed
#kpart_dir     := join(target_dir, 'kpart')
#kpart_kn_dir  := join(kpart_dir, 'kernel')
kpart_kn_dir  := join(esp_dir, 'tauos', 'kernel')


# bl
bl_dir        := join(workspace_dir, 'bl')
bl_target     := arch + '-unknown-uefi'
bl_build_dir  := join(target_dir, 'bl')
bl_out_dir    := join(bl_build_dir, bl_target, config)
bl_out_exe    := join(bl_out_dir, 'bl.efi')

# kernel
kn_dir        := join(workspace_dir, 'kernel')
kn_target     := arch + '-unknown-none-gnu'
kn_tgt_file   := join(kn_dir, kn_target + '.json')
kn_build_dir  := join(target_dir, 'kn')
kn_out_dir    := join(kn_build_dir, kn_target, config)
kn_out_exe    := join(kn_out_dir, 'kernel')



build: && (_build-check "build")

check: && (_build-check "check")

clean:
    #! python
    import subprocess
    subprocess.run("cargo clean", check=True, shell=True)

# ensure likely changed variables are valid
validate:
    #! python
    if not ("{{config}}" == "debug" or "{{config}}" == "release"):
        raise ValueError("Unknown config '{{config}}'")
    if not ("{{arch}}" == "x86_64"):
        raise ValueError("Unknown arch '{{arch}}'")

_build-check mode: validate
    #! python

    # setup:
    import os
    import pathlib
    import subprocess
    import shutil

    os.environ['RUSTFLAGS'] = ''

    # bl:
    bl_build_command = r"cargo +nightly {{mode}} --package bl --target {{bl_target}} " \
        r"-Z build-std-features=compiler-builtins-mem -Z build-std=core,compiler_builtins,alloc " \
        r"--target-dir {{bl_build_dir}} "

    if "{{config}}" == "release":
        bl_build_command = bl_build_command + "--release "
    #else:
    #    subprocess.run(r"cargo +nightly {{mode}} --package bl --target bl\{{bl_target}}-debug.json " \
    #        r"-Z build-std-features=compiler-builtins-mem -Z build-std=core,compiler_builtins,alloc ", 
    #        check=True, shell=True)

    subprocess.run(bl_build_command, check=True, shell=True)
    
    # kernel:
    kn_build_command = r"cargo +nightly {{mode}} --package kernel --target {{kn_tgt_file}} " \
        r"-Z build-std-features=compiler-builtins-mem -Z build-std=core,compiler_builtins,alloc " \
        r"--target-dir {{kn_build_dir}} "

    if "{{config}}" == "release":
        kn_build_command = kn_build_command + "--release "

    subprocess.run(kn_build_command, check=True, shell=True)

    if "{{mode}}" == "build":
        # bin reloc

        # esp
        pathlib.Path(r"{{esp_boot_dir}}").mkdir(parents=True, exist_ok=True)
        shutil.copy2(r"{{bl_out_exe}}", r"{{esp_boot_dir}}\\" + \
            ("BootX64.efi" if "{{arch}}" == "x86_64" else "BootAA64.efi"))

        # kpart
        # todo: fix when partition seek works
        pathlib.Path(r"{{kpart_kn_dir}}").mkdir(parents=True, exist_ok=True)
        shutil.copy2(r"{{kn_out_exe}}", r"{{kpart_kn_dir}}\\kernel")



img-prep:
    # create image if image does not already exist and partition it
    # mount image 


ovmf_dir  := join(workspace_dir, 'ovmf')
ovmf_code := join(ovmf_dir, 'OVMF_CODE-pure-efi.fd')
ovmf_vars := join(ovmf_dir, 'OVMF_VARS-pure-efi.fd')

# run tauos in qemu
run: build
    #! python

    import subprocess
    import time

    # qemu
    qemu_flags = "-nodefaults -vga std -serial stdio -no-reboot " \
        r"-drive if=pflash,format=raw,file={{ovmf_code}},readonly=on " \
        rf"-drive if=pflash,format=raw,file={{ovmf_vars}},readonly=" + \
        ("off " if "{{arch}}" == "aarch64" else "on ") + \
        r"-drive format=raw,file=fat:rw:{{esp_dir}} " # + \
        # r"-kernel {{kpart_kn_dir}}\kernel "
    # todo: partition support, fix 'kpart_dir' -> kpart_dir
    #    r"-drive format=raw,file=fat:rw:{{'kpart_dir'}} "

    if "{{arch}}" == "x86_64":
        qemu_flags = qemu_flags + "-machine q35 -cpu max -smp 4 -m 2G "# + \
            #"-device isa-debug-exit,iobase=0xf4,iosize=0x04 " #+ \
            #"-S -s "
            # "-enable-kvm "


    subprocess.Popen("qemu-system-{{arch}} " + qemu_flags, shell=True)

    time.sleep(2)

    #subprocess.Popen(r"start x86_64-amd-linux-gnu-gdb.exe --command=bl\debug.gdb", shell=True)
    # uefi-run -b /path/to/OVMF.fd -q /path/to/qemu app.efi -- <extra_qemu_args>
    # todo: gdb ?


# load onto partition
load letter: build
    #! python 

    from distutils.dir_util import copy_tree

    # copy esp
    copy_tree(r"{{esp_dir}}", r"{{letter}}:\\")

    # todo: copy other
