#!/bin/bash
# Copyright (c) 2024 innodisk Crop.
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

TIMEZONE=$(curl http://worldtimeapi.org/api/ip | jq | grep timezone | awk -F\" '{print $4}')

if [ -z "$TIMEZONE" ]
then
    echo "Can not reach http://worldtimeapi.org/api/ip, using default time zone."
    exit
else
    echo "$TIMEZONE"
    timedatectl set-timezone "$TIMEZONE"
fi