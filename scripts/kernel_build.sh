#!/bin/sh
OUTPUT_KERNEL_DIR=$(pwd)/output/kernel
OUTPUT_ALL_DIR=$(pwd)/output
OUTPUT_ROOTFS_DIR=$OUTPUT_ALL_DIR/buildroot/target

LINUX_XLNX_PATH=$1

if [ ! -f "$OUTPUT_KERNEL_DIR/.config" ]; then
    echo ".config not found in $OUTPUT_KERNEL_DIR, running defconfig..."
    make -C $LINUX_XLNX_PATH \
    O=$OUTPUT_KERNEL_DIR \
    ARCH=arm64 \
    xilinx_zynqmp_defconfig
else
    echo ".config already exists in $OUTPUT_KERNEL_DIR, skipping defconfig"
fi

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

make -C $LINUX_XLNX_PATH -j4 \
O=$OUTPUT_KERNEL_DIR \
ARCH=arm64 \
LOCALVERSION= \
CROSS_COMPILE=aarch64-none-linux-gnu- \
modules

make -C $LINUX_XLNX_PATH -j4 \
O=$OUTPUT_KERNEL_DIR \
ARCH=arm64 \
LOCALVERSION= \
CROSS_COMPILE=aarch64-none-linux-gnu- \
INSTALL_MOD_PATH=$OUTPUT_ROOTFS_DIR \
modules_install

cp $OUTPUT_KERNEL_DIR/arch/arm64/boot/Image $OUTPUT_ALL_DIR/Image 
cp $OUTPUT_KERNEL_DIR/arch/arm64/boot/Image.gz $OUTPUT_ALL_DIR/Image.gz
