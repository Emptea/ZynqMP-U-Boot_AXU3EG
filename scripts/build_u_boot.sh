#!/bin/sh
UBOOT_DIR=$1
DTB_PATH=$2
DTB_FILENAME="$(basename "$DTB_PATH")" 
DTB_NAME="${DTB_FILENAME%.*}" 

BUILD_DIR=$(pwd)/output/uboot
BL31_DIR=$(pwd)/output

DTB_DIR="$(pwd)/output/uboot/arch/arm/dts/"
mkdir -p $DTB_DIR

echo $DTB_PATH $DTB_DIR
cp $DTB_PATH $DTB_DIR

make -j3 -C $UBOOT_DIR \
O=$BUILD_DIR \
CROSS_COMPILE=aarch64-none-linux-gnu- \
DEVICE_TREE="zynqmp" \
BL31=$BL31_DIR/bl31.elf

cp  $BUILD_DIR/u-boot.elf ../u-boot.elf
