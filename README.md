# README

Requirements: Vivado 2019.1, Vivado SDK 2019.1

## Build Zynq US+ MPSoC FPGA

### Create project

```vivado -mode batch -source ./scripts/create_project.tcl```

### Implementation + synthesis

```vivado -mode batch -source ./scripts/implementation.tcl```

### Export hardware

```vivado -mode batch -source ./scripts/export_hadware.tcl```

## Build FSBL

```xsct ./scripts/fsbl_build.tcl```
    
Get ```zynqmp_fsbl.elf```

## Build PMU Firmware

```xsct ./scripts/pmufw_build.tcl```

## Build ARM trusted firmware

You should create enviromental variable `VIVADO_SDK_PATH` that looks like:
```VIVADO_SDK_PATH="path/to/Xilinx/folder/SDK/{version}"```

Clone [arm-trusted-firmware](https://github.com/Xilinx/arm-trusted-firmware.git) to any folder you like, checkout to your Vivado version (mine was 2019.1, so I did `git checkout -b xilinx-v2019.1`).

From folder with this git repo call:
```./scripts/build_arm_tfw.sh /path/to/arm-trusted-firmware```

## Build device tree

Clone [device-tree-xlnx](https://github.com/Xilinx/device-tree-xlnx.git) to any folder you like, checkout to your Vivado version (mine was 2019.1, so I did `git checkout -b xilinx-v2019.1`).

For old Vivado versions:
```./scripts/dts_gen.sh ./path/to/project.hwdef /path/to/device-tree-xlnx/```

```./scripts/dts_gen.sh ./path/to/project.xsa /path/to/device-tree-xlnx/```
    
Get ```pmufw.elf```

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

Get ```zynqmp.dtb```

## Verify U-boot

Connect your board to Xilinx Programmer via JTAG (and make sure your board is running in JTAG mode), UART port to PC, connect to Serial Monitor and run:

```xsct ./scripts/jtag_load.tcl```

In Serial Monitor you should see PMUFW, FSBL and board information.

## Generate BOOT.bin

```bash
    cd output
    bootgen -image boot.bif -o BOOT.bin -arch zynqmp -w
```
    
<details><summary>boot.bif</summary>

   the_ROM_image:
{
  [pmufw_image]                                      /home/user/ZynqMP-U-Boot_AXU3EG/output/pmufw/pmufw.elf
  [bootloader, destination_cpu=a53-0]                /home/user/ZynqMP-U-Boot_AXU3EG/output/fsbl/zynqmp_fsbl.elf
  [destination_cpu=a53-0, exception_level=el-3, trustzone] /home/user/ZynqMP-U-Boot_AXU3EG/output/atf/bl31.elf
  [destination_cpu=a53-0, exception_level=el-2]      /home/user/ZynqMP-U-Boot_AXU3EG/output/uboot/u-boot.elf
}

</details>
    
    
## Linux Kernel
    
```git ls-remote -h https://github.com/Xilinx/linux-xlnx git clone --depth 1 --branch "xlnx_rebase_v6.6_LTS" https://github.com/Xilinx/linux-xlnx```
       
```git checkout xilinx-v2025.1  export ARCH=arm64 export CROSS_COMPILE=aarch64-linux-gnu-```
        
```make xilinx_zynqmp_defconfig```
    
```make menuconfig```
    
    Target options  ---> Target Architecture (AArch64 (little endian))
    Toolchain ---> Toolchain type (Buildroot toolchain),  C library (glibc) 
    System configuration  ---> (root) System hostname, [*] Enable root login with password (root) Root password 
    Filesystem images  ---> 
    [*] ext2/3/4 root filesystem ext2/3/4 variant (ext4)
    
```make -j$(nproc) Image dtbs```

```dtc -@ -I dts -O dtb \ -i <path_to_includes> \ -o system.dtb system-top.dts```
    
<details><summary>system-top.dts</summary>

/dts-v1/;  
/include/ "zynqmp.dtsi"
/include/ "zynqmp-clk-ccf.dtsi"

/ {
	model = "Alynx AXU3EGB";
	compatible = "alinx,axu3egb", "xlnx,zynqmp";

	aliases {
		ethernet0 = &gem3;
		serial0   = &uart0;
		spi0      = &qspi;
		mmc0      = &sdhci1;
	};

	chosen {
		bootargs    = "earlycon";
		stdout-path = "serial0:115200n8";
	};

	memory@0 {
		device_type = "memory";
		reg = <0x0 0x0 0x0 0x80000000>;
	};
};

&gem3  { phy-mode = "rgmii-id"; status = "okay"; };
&uart0 { status = "okay"; u-boot,dm-pre-reloc;  };
&sdhci1 {
 		xlnx,mio_bank = <1>;
	status       = "okay";
	bus-width    = <4>;
	clock-names  = "clk_xin", "clk_ahb";
	clocks       = <&zynqmp_clk 55>, <&zynqmp_clk 47>;
	no-1-8-v; disable-wp;
	u-boot,dm-pre-reloc;
};
&qspi   { status = "okay"; is-dual = <1>; num-cs = <2>; };
&usb0 {
    status  = "okay";
    dr_mode = "host";
};
&dwc3_0 {
    status = "okay";
};

&usb1 {
    status  = "okay";
    dr_mode = "host";
};
&dwc3_1 {
    status = "okay";
};

</details>
    
    
##SD
     
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
    
    
    
    