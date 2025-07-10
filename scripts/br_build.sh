#!/bin/sh

OUTPUT_BUILDROOT_DIR=$(pwd)/output/buildroot
OUTPUT_ALL_DIR=$(pwd)/output


BR_PATH=$1

make -C $BR_PATH \
O=$OUTPUT_BUILDROOT_DIR \
BR2_JLEVEL="$(($(nproc)))"

cp $OUTPUT_BUILDROOT_DIR/images/rootfs.cpio.uboot  $OUTPUT_ALL_DIR/rootfs.cpio.uboot
cp $OUTPUT_BUILDROOT_DIR/images/rootfs.ext2  $OUTPUT_ALL_DIR/rootfs.ext2
cp $OUTPUT_BUILDROOT_DIR/images/rootfs.ext4  $OUTPUT_ALL_DIR/rootfs.ext4