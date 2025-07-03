
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

Clone arm-trusted-firmware to any folder you like. From folder with this git repo call:
```./scripts/build_arm_tfw.sh /path/to/arm-trusted-firmware```