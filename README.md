
# README

Requirements: Vivado 2019.1, Vivado SDK 2019.1

## Build Zynq US+ MPSoC FPGA

### Create project:

```vivado -mode batch -source ./scripts/create_project.tcl```

### Implementation + synthesis

```vivado -mode batch -source ./scripts/implementation.tcl```

### Export hardware

```vivado -mode batch -source ./scripts/export_hadware.tcl```

## Build FSBL

```xsct ./scripts/build_zynqmp_fsbl.tcl```

## Build PMU Firmware

```xsct ./scripts/build_zynqmp_pmufw.tcl```

## Build ARM trusted firmware

You should create enviromental variable `VIVADO_SDK_PATH` that looks like:
```VIVADO_SDK_PATH="path/to/Xilinx/folder/SDK/{version}"```

Clone [arm-trusted-firmware](https://github.com/Xilinx/arm-trusted-firmware.git) to any folder you like, checkout to your Vivado version (mine was 2019.1, so I did `git checkout -b xilinx-v2019.1`).

From folder with this git repo call:
```./scripts/build_arm_tfw.sh /path/to/arm-trusted-firmware```

## Build device tree

Clone [device-tree-xlnx](https://github.com/Xilinx/device-tree-xlnx.git) to any folder you like, checkout to your Vivado version (mine was 2019.1, so I did `git checkout -b xilinx-v2019.1`).

For old Vivado versions:
```./scripts/generate_dtc.sh ./path/to/project.hwdef /path/to/device-tree-xlnx/```

For new Vivado versions:
```./scripts/generate_dtc.sh ./path/to/project.xsa /path/to/device-tree-xlnx/```

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

```./scripts/build_u_boot.sh path/to/u-boot-xlnx/ ./output/zynqmp.dtb```

## Verify U-boot

Connect your board to Xilinx Programmer via JTAG and run:

```xsct ./scripts/jtagload.tcl```

## Generate BOOT.bin

```bash
cd output
bootgen -image boot.bif -o BOOT.bin -arch zynqmp
```

## Linux kernel

Clone [linux-xlnx.git](https://github.com/Xilinx/linux-xlnx.git) to any folder you like, checkout to your Vivado version (mine was 2019.1, so I did `git checkout -b xilinx-v4.19`).

Install dependencies:
```sudo apt install libncurses-dev```

Run script:

```./scripts/build_kernel.sh /path/to/linux-xlnx```

In Kernel Configuration menu turn on overlay filesystem support (File systems -> Overlay filesystem support) like on screen and save your configuration:
![kernel linux configuration](image.png)

If you have problem with multiple yylloc definition than add `extern` type to `YYLTYPE yylloc` in `dtc-lexer.l`.