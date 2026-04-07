#!/bin/sh
UBOOT_DIR=$1

BUILD_DIR=$(pwd)/output/uboot
BL31_DIR=$(pwd)/output

make -j3 -C $UBOOT_DIR \
O=$BUILD_DIR \
CROSS_COMPILE=aarch64-linux-gnu- \
DEVICE_TREE="zynqmp" \
BL31=$BL31_DIR/bl31.elf

cp $BUILD_DIR/u-boot.elf $BL31_DIR/u-boot.elf

cd $BL31_DIR
bootgen -image boot.bif -w -o i BOOT.bin -arch zynqmp -log info -w on
