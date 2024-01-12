#!/bin/bash
# Copyright (c) 2024 innodisk Crop.
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

NUM=${1:-0}
JSON=${2:-"usbport.json"}

printf "{\n" > "$JSON"

for ((i=0; i<="$NUM"; i+=2))
do
    PORT=$(udevadm info --query=path --name=/dev/video$i | sed 's/\/video4linux.*//' | sed 's/.*\(usb\)/\1/')

    if [ "$i" -eq "$NUM" ]; then
        printf "\t\"video%s\":\"%s\"\n" "$i" "$PORT" >> "$JSON"
        printf "}\n" >> "$JSON"
    else
        printf "\t\"video%s\":\"%s\",\n" "$i" "$PORT" >> "$JSON"
    fi
done
