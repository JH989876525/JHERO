#!/bin/bash
# Copyright (c) 2023 innodisk Crop.
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

ROOTPATH="/media/jhh/root"

echo "removing files which in ${ROOTPATH}"
sudo rm -rf ${ROOTPATH}/*

sync

echo "decompress files into ${ROOTPATH}"
sudo tar -zxvf rootfs.tar.gz -C ${ROOTPATH}

echo "syncing"
sync
echo "done"
