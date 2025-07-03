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

make -C $UBOOT_DIR distclean

make -C $UBOOT_DIR \
O=$BUILD_DIR \
xilinx_zynqmp_virt_defconfig

cd $BUILD_DIR
sed -i 's/\(CONFIG_DEFAULT_DEVICE_TREE="\)[^"]*/\1'$DTB_NAME'/' .config
sed -i 's/\(CONFIG_OF_LIST="\)\([^"]*\)/\1'$DTB_NAME\ '\2/' .config
sed -i 's/\(CONFIG_SPL_OF_LIST="\)\([^"]*\)/\1'$DTB_NAME\ '\2/' .config

make -j3 -C $UBOOT_DIR \
O=$BUILD_DIR \
CROSS_COMPILE=aarch64-none-linux-gnu- \
DEVICE_TREE="zynqmp" \
BL31=$BL31_DIR/bl31.elf

cp  $BUILD_DIR/u-boot.elf ../u-boot.elf
