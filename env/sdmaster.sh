#!/bin/bash
# Copyright (c) 2023 innodisk Crop.
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

DEVICE=${1:-/dev/sdeeee}

sudo umount ${DEVICE}1
sudo umount ${DEVICE}2

echo -e "d\n\nd\n\nd\n\nn\n\n\n\n+1G\ny\na\nn\n\n\n\n\ny\nw\n" | sudo fdisk ${DEVICE}
sleep 3

sudo mkfs.vfat -F 32 -n boot ${DEVICE}1
sudo mkfs.ext4 -L root ${DEVICE}2
sleep 3

sync