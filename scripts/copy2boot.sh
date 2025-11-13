#!/bin/sh
PATH_TO_OUTPUT_FILES=$1
mkdir -p /mnt/boot
mount /dev/sdb1 /mnt/boot/

cd $PATH_TO_OUTPUT_FILES
cp -r BOOT.bin /mnt/boot/BOOT.bin 
cp -r zynqmp.dtb /mnt/boot/zynqmp.dtb 
umount /mnt/boot