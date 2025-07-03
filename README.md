
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

