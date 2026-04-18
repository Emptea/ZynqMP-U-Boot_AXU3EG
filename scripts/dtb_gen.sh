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

cpp -nostdinc -I${INCDIR} -I${DTSHDIR} -I${DTSDIR} -undef -x assembler-with-cpp -o pre-zynqmp.dts axu3eg.dts

cp pre-zynqmp.dts $OUTPUT_DIR/pre-zynqmp.dts
cd $OUTPUT_DIR
echo $(pwd)
dtc -I dts -O dtb --symbols -i${DTSHDIR} -i${DTSDIR} -o zynqmp.dtb pre-zynqmp.dts

echo "Successfully built dts. Output written to $(pwd)"
exit 0