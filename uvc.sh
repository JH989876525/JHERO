#!/bin/bash

SCRIPT=""
GST_LAUNCH="/usr/bin/gst-launch-1.0 "

function SHOW_CAM (){
    v4l2-ctl -D -d "${1}" --list-formats-ext
}

function MJPG (){
    if [ -z "$5" ]; then
        local GST="v4l2src device=${1} ! image/jpeg,width=${2},height=${3},framerate=${4}/1 ! jpegparse ! jpegdec ! videoconvert ! fakesink "
    else
        local GST="v4l2src device=${1} ! image/jpeg,width=${2},height=${3},framerate=${4}/1 ! jpegparse ! jpegdec ! videoconvert ! autovideosink "
    fi 
    SCRIPT=${SCRIPT}${GST}
}

function RAW (){
    if [ -z "$5" ]; then
        local GST="v4l2src device=${1} ! video/x-raw,width=${2},height=${3},framerate=${4}/1 ! videoconvert ! fakesink "
    else
        local GST="v4l2src device=${1} ! video/x-raw,width=${2},height=${3},framerate=${4}/1 ! videoconvert ! autovideosink "
    fi 
    SCRIPT=${SCRIPT}${GST}
}

SCRIPT=${SCRIPT}${GST_LAUNCH}

MJPG /dev/video0 640 480 30 1
MJPG /dev/video2 640 480 30 1
MJPG /dev/video4 640 480 30 1
MJPG /dev/video6 640 480 30 1

echo "${SCRIPT}"

${SCRIPT}