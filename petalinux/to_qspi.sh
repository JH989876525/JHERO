#!/bin/bash
# Copyright (c) 2025 Innodisk crop.
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

DIR="$( cd "$( dirname "$0" )" && pwd )"
BOOT_FILE="${DIR}/BOOT.BIN"
FSBL_FILE="${DIR}/zynqmp_fsbl.elf"

# program_flash -f "${BOOT_FILE}" -offset 0x0 -flash_type qspi-x4-single -fsbl "${FSBL_FILE}" -erase_only

program_flash -f "${BOOT_FILE}" -offset 0x0 -flash_type qspi-x4-single -fsbl "${FSBL_FILE}"
