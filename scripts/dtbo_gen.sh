#!/bin/bash

# Usage: ./dtb_gen.sh <linux-xlnx-path> <dts_dir> [output_dir]

LINUX_XLNX_PATH=$1
DTS_PATH=$2
OUTPUT_DIR=${3:-$(pwd)/output}  # Default output dir

# Check inputs
if [ -z "$LINUX_XLNX_PATH" ] || [ -z "$DTS_PATH" ]; then
    echo "Usage: $0  <linux-xlnx-path> <dts_dir> [output_dir]"
    exit 1
fi
cd $DTS_PATH

INCDIR=$LINUX_XLNX_PATH/include
DTSHDIR=$LINUX_XLNX_PATH/arch/arm64/boot/dts/
DTSDIR=$LINUX_XLNX_PATH/arch/arm64/boot/dts/xilinx/

cp -f ../overlay.dts overlay.dts

cd $OUTPUT_DIR
echo $(pwd)
dtc -I dts -O dtb -o overlay.dtbo -b 0 -@ overlay.dts

echo "Successfully built device tree overlay. Output written to $(pwd)"
exit 0