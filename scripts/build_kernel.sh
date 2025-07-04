#!/bin/sh

# Usage: ./kernel_build.sh <linux-xlnx-path> [output_dir]

LINUX_XLNX_PATH=$1
OUTPUT_DIR=${2:-$(pwd)/output/kernel}  # Default output dir

make -C $LINUX_XLNX_PATH \
O=$OUTPUT_DIR \
ARCH=arm64 \
xilinx_zynqmp_defconfig

make -C $LINUX_XLNX_PATH \
O=$OUTPUT_DIR \
ARCH=arm64 \
LOCALVERSION= \
CROSS_COMPILE=aarch64-none-linux-gnu- \
nconfig

make -C $LINUX_XLNX_PATH -j4 \
O=$OUTPUT_DIR \
ARCH=arm64 \
LOCALVERSION= \
CROSS_COMPILE=aarch64-none-linux-gnu- 

cp $OUTPUT_DIR/arch/arm64/boot/Image $(pwd)/output/Image 
cp $OUTPUT_DIR/arch/arm64/boot/Image.gz $(pwd)/output/Image.gz