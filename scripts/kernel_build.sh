#!/bin/sh
OUTPUT_KERNEL_DIR=$(pwd)/output/kernel
OUTPUT_ALL_DIR=$(pwd)/output

LINUX_XLNX_PATH=$1

make -C $LINUX_XLNX_PATH \
O=$OUTPUT_KERNEL_DIR \
ARCH=arm64 \
xilinx_zynqmp_defconfig

make -C $LINUX_XLNX_PATH \
O=$OUTPUT_KERNEL_DIR \
ARCH=arm64 \
LOCALVERSION= \
CROSS_COMPILE=aarch64-none-linux-gnu- \
nconfig

make -C $LINUX_XLNX_PATH -j4 \
O=$OUTPUT_KERNEL_DIR \
ARCH=arm64 \
LOCALVERSION= \
CROSS_COMPILE=aarch64-none-linux-gnu- 

cp $OUTPUT_KERNEL_DIR/arch/arm64/boot/Image $OUTPUT_ALL_DIR/Image 
cp $OUTPUT_KERNEL_DIR/arch/arm64/boot/Image.gz $OUTPUT_ALL_DIR/Image.gz
