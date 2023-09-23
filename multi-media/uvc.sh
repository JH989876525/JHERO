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

MJPG /dev/video0 1920 1080 5
MJPG /dev/video2 1920 1080 5
MJPG /dev/video4 1920 1080 5
MJPG /dev/video6 1920 1080 5

echo "${SCRIPT}"

# ${SCRIPT}


/usr/bin/gst-launch-1.0 \
videomixer name=mix \
sink_0::xpos=0 sink_0::ypos=0 \
sink_1::xpos=1920 sink_1::ypos=0 \
sink_2::xpos=0 sink_2::ypos=1080 \
sink_3::xpos=1920 sink_2::ypos=1080 \
! omxh264enc target-bitrate=2000 control-rate=2 \
! h264parse ! rtph264pay name=pay0 pt=96 ! fakesink \
v4l2src device=/dev/video0 ! image/jpeg,width=1920,height=1080,framerate=5/1 ! jpegparse ! jpegdec ! videoconvert ! mix.sink_0 \
v4l2src device=/dev/video2 ! image/jpeg,width=1920,height=1080,framerate=5/1 ! jpegparse ! jpegdec ! videoconvert ! mix.sink_1 \
v4l2src device=/dev/video4 ! image/jpeg,width=1920,height=1080,framerate=5/1 ! jpegparse ! jpegdec ! videoconvert ! mix.sink_2 \
v4l2src device=/dev/video6 ! image/jpeg,width=1920,height=1080,framerate=5/1 ! jpegparse ! jpegdec ! videoconvert ! mix.sink_3


/usr/bin/gst-launch-1.0 \
videomixer name=mix \
sink_0::xpos=0 sink_0::ypos=0 \
sink_1::xpos=1920 sink_1::ypos=0 \
sink_2::xpos=0 sink_2::ypos=1080 \
sink_3::xpos=1920 sink_2::ypos=1080 \
! omxh264enc target-bitrate=2000 control-rate=2 \
! h264parse ! rtph264pay name=pay0 pt=96 ! fakesink \
v4l2src device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! mix.sink_0 \
v4l2src device=/dev/video2 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! mix.sink_1 \
v4l2src device=/dev/video4 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! mix.sink_2 \
v4l2src device=/dev/video6 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! mix.sink_3


xmutil loadapp VC84KC300G2X4

modetest -M xlnx -D a0000000.v_mix -s 55@43:3840x2160@NV16

gst-launch-1.0 \
v4l2src device=/dev/video0 ! image/jpeg,width=1920,height=1080,framerate=5/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=a0000000.v_mix plane-id=34 render-rectangle="<0,0,1920,1080>" sync=false \
v4l2src device=/dev/video2 ! image/jpeg,width=1920,height=1080,framerate=5/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=a0000000.v_mix plane-id=35 render-rectangle="<0,1080,1920,1080>" sync=false \
v4l2src device=/dev/video4 ! image/jpeg,width=1920,height=1080,framerate=5/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=a0000000.v_mix plane-id=36 render-rectangle="<1920,0,1920,1080>" sync=false \
v4l2src device=/dev/video6 ! image/jpeg,width=1920,height=1080,framerate=5/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=a0000000.v_mix plane-id=37 render-rectangle="<1920,1080,1920,1080>" sync=false 



gst-launch-1.0 \
v4l2src device=/dev/video6 ! image/jpeg,width=1920,height=1080,framerate=5/1 ! jpegparse ! jpegdec ! videoconvert ! fakesink


gst-launch-1.0 \
v4l2src device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=a0000000.v_mix plane-id=34 render-rectangle="<0,0,640,480>" sync=false \
v4l2src device=/dev/video2 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=a0000000.v_mix plane-id=35 render-rectangle="<0,480,640,480>" sync=false \
v4l2src device=/dev/video4 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=a0000000.v_mix plane-id=36 render-rectangle="<640,0,640,480>" sync=false \
v4l2src device=/dev/video6 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=a0000000.v_mix plane-id=37 render-rectangle="<640,480,640,480>" sync=false 
