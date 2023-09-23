#!/bin/bash
# Copyright (c) 2023 innodisk Crop.
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

BOOTPATH="/media/jhh/boot"

echo "cp boot"

cp ./ramdisk.cpio.gz.u-boot $BOOTPATH
cp ./boot.scr $BOOTPATH
cp ./Image $BOOTPATH
cp ./system.dtb $BOOTPATH

echo "done"