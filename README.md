# README

Requirements: Vivado 2019.1, Vivado SDK 2019.1

## Build Zynq US+ MPSoC FPGA

### Create project

```
vivado -mode batch -source ./scripts/create_project.tcl
```

### Implementation + synthesis

```
vivado -mode batch -source ./scripts/implementation.tcl
```

### Export hardware

```
vivado -mode batch -source ./scripts/export_hardware.tcl
```

## Build FSBL

On Linux:

```
xsct ./scripts/fsbl_build.tcl
```

On Windows open Xilinx SDK and open xsct console in it (Xilinx -> XSCT Console), than:

```
cd path/to/your/folder
source ./scripts/fsbl_build.tcl
```

Get ```zynqmp_fsbl.elf```

## Build PMU Firmware

On Linux:

```
xsct ./scripts/pmufw_build.tcl
```

On Windows open Xilinx SDK and open xsct console in it (Xilinx -> XSCT Console), than:

```
cd path/to/your/folder
source ./scripts/pmufw_build.tcl
```

Hint: if you used fsbl scripts before you should do `cd ..` because your pwd will be changed to `path/to/your/folder/zynq`.

## Build ARM trusted firmware

You should create enviromental variable `VIVADO_SDK_PATH` that looks like
```VIVADO_SDK_PATH="path/to/Xilinx/folder/SDK/{version}"```

Clone [arm-trusted-firmware](https://github.com/Xilinx/arm-trusted-firmware.git) to any folder you like, checkout to your Vivado version (mine was 2019.1, so I did `git checkout -b xilinx-v2019.1`).

From folder with this git repo call:
```
./scripts/arm_tfw_build.sh /path/to/arm-trusted-firmware
```

## Build device tree

Clone [device-tree-xlnx](https://github.com/Xilinx/device-tree-xlnx.git) to any folder you like, checkout to your Vivado version (mine was 2019.1, so I did `git checkout -b xilinx-v2019.1`).

For old Vivado versions:
```
./scripts/dts_gen.sh ./path/to/project.hwdef /path/to/device-tree-xlnx/
```

```
./scripts/dts_gen.sh ./path/to/project.xsa /path/to/device-tree-xlnx/
```
    
Get `zynqmp.dts`.

Generated device tree is not comprehensive one so I recommend you to create `user.dts` file in output folder with your additions for generated dts. You can see example of `user,.dts` in output folder of this repository and how it is added to `zynqmp.dts` after running `dtb_gen.sh`.

## Build device tree blob

```
./scripts/dtb_gen.sh /path/to/device-tree-xlnx/ path/to/dts/files
```

Get `zynqmp.dtb`

## U-boot

First, install dependencies for u-boot:

```bash
sudo apt update && sudo apt install -y \
  git build-essential gcc g++ gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
  make binutils python3 python3-setuptools python3-dev python3-pip \
  bison flex swig tar cpio zip unzip patch device-tree-compiler \
  u-boot-tools libssl-dev bc \
  libgnutls28-dev uuid-dev libuuid1
  ```

If you get an error:

```/usr/bin/ld: scripts/dtc/dtc-parser.tab.o:(.bss+0x10): multiple definition of `yylloc'; scripts/dtc/dtc-lexer.lex.o:(.bss+0x0): first defined here
collect2: error: ld returned 1 exit status```

Then add `extern` to `YYLTYPE yylloc` in file `dtc-lexer.lex.c`.

Clone [u-boot-xlnx](https://github.com/Xilinx/u-boot-xlnx.git) to any folder you like, checkout to your Vivado version (mine was 2019.1, but I did `git checkout -b xilinx-v2020.1`).

Run:

```./scripts/uboot_build.sh path/to/u-boot-xlnx/ ./output/zynqmp.dtb```

Get `u-boot.elf`

## Verify U-boot

Connect your board to Xilinx Programmer via JTAG (and make sure your board is running in JTAG mode), UART port to PC, connect to Serial Monitor and run:

```xsct ./scripts/jtag_load.tcl```

In Serial Monitor you should see PMUFW, FSBL and board information.

## Generate BOOT.bin

```bash
    cd output
    bootgen -image boot.bif -o BOOT.bin -arch zynqmp -w
```
    
<details><summary>boot.bif (example)</summary>

    //arch = zynqmp; split = false; format = BIN
    the_ROM_image:
    {
        [bootloader, destination_cpu = a53-0]zynqmp_fsbl.elf
        [pmufw_image]zynqmp_pmufw.elf
        [destination_device = pl] zynq_wrapper.bit
        [destination_cpu = a53-0, exception_level = el-3, trustzone]bl31.elf
        [destination_cpu = a53-0, exception_level = el-2]u-boot.elf
    }
</details>
    
    
## Linux Kernel
    
```git ls-remote -h https://github.com/Xilinx/linux-xlnx git clone --depth 1 --branch "xlnx_rebase_v6.6_LTS" https://github.com/Xilinx/linux-xlnx```
       
```git checkout xilinx-v2025.1  export ARCH=arm64 export CROSS_COMPILE=aarch64-linux-gnu-```

    
    
## SD
     
```lsblk``` ex. dev/sda
     
```sudo fdisk /dev/sda```
     
```
sudo parted /dev/sda --script \
    mklabel msdos \
    mkpart primary fat32 1MiB 100MiB \
    mkpart primary ext4 100MiB 100%
```
    
```
sudo mkfs.vfat -F32 -n boot /dev/sda1
sudo mkfs.ext4 -L rootfs /dev/sda2
```

```
sudo mkfs.ext4 -O ^64bit,^metadata_csum /dev/sda2
```
    
```
mkdir -p mnt/boot mnt/rootfs
sudo mount /dev/sda1 mnt/boot
sudo mount /dev/sda2 mnt/rootfs
```

Copy to boot folder : BOOT.bin Image system.dtb, create folder /boot/extlinux put file extlinux.conf there
    
<details><summary>extlinux.conf</summary>

label linux
  kernel /Image
  devicetree /system.dtb
  append console=ttyPS0,115200 root=/dev/mmcblk0p2 rw rootwait rootfstype=ext4 rootdelay=5 earlycon ignore_loglevel loglevel=8

</details>
    
```
sudo dd if=output/images/rootfs.ext4 of=/dev/sda2 bs=4M status=progress conv=fsync
sync
```

#Run

```
picocom -b 115200 /dev/ttyUSB0
``` 
    
    
    
    