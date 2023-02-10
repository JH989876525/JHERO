#!/bin/bash
# Copyright (c) 2022 Innodisk crop.
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT


######## color ANIS ########
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'
### echo -e "I am ${RED}dangerous${NC}."
######## color ANIS ########

SURE="${1}"
SSTATE_CACHE="sstate_aarch64_2020.2.2-k26"
PATH_TO_SSTATE_CACHE_TAR="./$SSTATE_CACHE.tar.gz"
PATH_TO_LOCAL_MIRROR_SERVER="./"

if [ "$SURE" == "sure" ] ; then
    if [ ! -f "$PATH_TO_SSTATE_CACHE_TAR" ] ; then
        echo -e "${RED}[ERROR]${NC} MISSING $PATH_TO_SSTATE_CACHE_TAR"
        echo -e "  Download from: ${YELLOW}https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/archive.html${NC}"
    fi
    echo -e "[INFO] Removing $PATH_TO_LOCAL_MIRROR_SERVER/$SSTATE_CACHE"  
    sudo rm -rf $PATH_TO_LOCAL_MIRROR_SERVER/$SSTATE_CACHE
    echo -e "[INFO] Syncing"  
    sync
    echo -e "[INFO] Decompress $PATH_TO_SSTATE_CACHE_TAR"  
    tar -zxvf $PATH_TO_SSTATE_CACHE_TAR -C $PATH_TO_LOCAL_MIRROR_SERVER
    echo -e "[INFO] Syncing"  
    sync

    if [ -f "$PATH_TO_SSTATE_CACHE_TAR" ] ; then
        echo -e "${BLUE}[INFO] DONE${NC}"
    fi
    
else
    for i in {1..3}
    do
    echo -e "${YELLOW}[WARNING] MAKE SURE YOU ARE GOING TO REFRESH \"sstate-cache\"${NC}"
    done
    echo -e "[INFO] Excute blow cmd to refresh \"sstate-cache\""
    echo -e "  $0 sure"
    exit
fi
