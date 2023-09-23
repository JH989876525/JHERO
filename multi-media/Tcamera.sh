#!/bin/bash
# Copyright (c) 2023 innodisk Crop.
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT


##### fuinctions
function gstmjpg() {
    ### input parameters
    DEVICE=${1}
    WIDTH=${2}
    HEIGHT=${3}
    FPS=${4:-30}

    gst-launch-1.0 \
    v4l2src device="${DEVICE}" \
    ! image/jpeg,width="${WIDTH}", height="${HEIGHT}", framerate="${FPS}"/1 \
    ! jpegparse ! jpegdec ! fakesink >> /dev/null &
}

function gstraw() {
    ### input parameters
    DEVICE=${1}
    WIDTH=${2}
    HEIGHT=${3}
    FPS=${4:-30}

    gst-launch-1.0 \
    v4l2src device="${DEVICE}" \
    ! video/x-raw, width="${WIDTH}", height="${HEIGHT}", framerate="${FPS}"/1 \
    ! videoconvert ! fakesink >> /dev/null &
}

function bwrqst() {
    dmesg | grep uvcvideo | grep "Device requested" | tail -1 | awk -F: {'print $2'} | awk {'print $3" "$4'}
}

function getresult() {
    killall gst-launch-1.0
    bwrqst
}

##### ckecking and setting env.
### check user
if [ ! $UID -eq 0 ] ; then
        echo "[ERROR] \"root\" is required, do it again with sudo."
        exit
fi
### enable uvcvideo kernel log
echo 0xffff > /sys/module/uvcvideo/parameters/trace


##### getinput parameters
##### test bycase now
FORMAT=${1}
DEVICE=${2}
WIDTH=${3}
HEIGHT=${4}
FPS=${5}
DELAY=${6:-0.4}

###
killall gst-launch-1.0
if [ "$FORMAT" = raw ]; then 
    gstraw ${DEVICE} ${WIDTH} ${HEIGHT} ${FPS}
    sleep ${DELAY}
    getresult
    gstraw ${DEVICE} ${WIDTH} ${HEIGHT} ${FPS}
elif [ "$FORMAT" = mjpg ]; then 
    gstmjpg ${DEVICE} ${WIDTH} ${HEIGHT} ${FPS}
    sleep ${DELAY}
    getresult
    gstmjpg ${DEVICE} ${WIDTH} ${HEIGHT} ${FPS}
else
    echo "[ERROR] unsupport format."
    echo "  ${0} <FORMAT> <DEVICE> <WIDTH> <HEIGHT> <FPS> <DELAY>"
    echo "[INFO] for example:"
    echo "  ${0} raw /dev/video0 1920 1080 5 0.3"
    echo "  ${0} mjpg /dev/video0 1920 1080 30 0.3"
fi

##### ending sctipt
### disable uvcvideo kernel log
echo 0x0 > /sys/module/uvcvideo/parameters/trace