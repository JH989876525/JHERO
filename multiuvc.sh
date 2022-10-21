#!/bin/bash

v4l2-ctl -D -d /dev/video0 --list-formats-ext

v4l2-ctl -D -d /dev/video2 --list-formats-ext

gst-launch-1.0 \
v4l2src device=/dev/video0 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink \
v4l2src device=/dev/video2 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink

gst-launch-1.0 \
v4l2src device=/dev/video0 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink

gst-launch-1.0 -v \
v4l2src device=/dev/video2 \
! image/jpeg,width=1920,height=1080,framerate=30/1 \
! jpegparse ! jpegdec ! fpsdisplaysink video-sink="fakesink"

gst-launch-1.0 \
v4l2src device=/dev/video0 \
! image/jpeg,width=640,height=480,framerate=60/1 \
! jpegparse ! jpegdec ! videoconvert\
! omxh264enc prefetch-buffer=true gop-length=60 control-rate=2 target-bitrate=2000 filler-data=false \
! h264parse ! rtph264pay name=pay0 pt=96 ! fakesink

./rtsp_server_app \
"v4l2src device=/dev/video0 \
! image/jpeg,width=640,height=480,framerate=60/1 \
! jpegparse ! jpegdec \
! omxh264enc target-bitrate=2000 control-rate=2 \
! h264parse ! rtph264pay name=pay0 pt=96"

./rtsp_server_app \
"videomixer name=mix sink_0::xpos=0 sink_0::ypos=0 ! omxh264enc target-bitrate=500 control-rate=2 ! rtph264pay name=pay0 pt=96 \
-v v4l2src device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=60/1 ! jpegparse ! jpegdec ! mix.sink_0"

./rtsp_server_app \
"videomixer name=mix sink_0::xpos=0 sink_0::ypos=0 ! omxh264enc target-bitrate=3000 control-rate=2 ! rtph264pay name=pay0 pt=96 \
-v v4l2src device=/dev/video2 ! image/jpeg,width=1920,height=1080,framerate=30/1 ! jpegparse ! jpegdec ! mix.sink_0"

gst-launch-1.0 rtspsrc location=rtsp://192.168.3.112:8554/test latency=100 \
! queue ! rtph264depay ! h264parse ! avdec_h264 \
! fpsdisplaysink video-sink="autovideosink"

gst-launch-1.0 rtspsrc location=rtsp://127.0.0.1:8554/test latency=100 \
! queue ! rtph264depay ! h264parse ! omxh264dec \
! fakesink


gst-launch-1.0 \
v4l2src device=/dev/video0 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink \
v4l2src device=/dev/video2 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink \
v4l2src device=/dev/video4 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink \
v4l2src device=/dev/video6 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink

gst-launch-1.0
v4l2src device=/dev/video0 ! video/x-h264, width=640, height=480, framerate=30/1
! h264parse ! omxh264dec internal-entropy-buffers=3 \
! tee name=t0 \
t0.src_0 ! queue ! fpsdisplaysink video-sink="kmssink bus-id=a0000000.v_mix plane-id=34 render-rectangle=\"<0,0,640,480>\"" \
t0.src_1 ! queue ! fpsdisplaysink video-sink="kmssink bus-id=a0000000.v_mix plane-id=35 render-rectangle=\"<640,0,640,480>\"" \
t0.src_2 ! queue ! fpsdisplaysink video-sink="kmssink bus-id=a0000000.v_mix plane-id=36 render-rectangle=\"<1280,0,640,480>\"" \
t0.src_3 ! queue ! fpsdisplaysink video-sink="kmssink bus-id=a0000000.v_mix plane-id=37 render-rectangle=\"<0,480,640,480>\"" \
t0.src_4 ! queue ! fpsdisplaysink video-sink="kmssink bus-id=a0000000.v_mix plane-id=38 render-rectangle=\"<640,480,640,480>\"" \
t0.src_5 ! queue ! fpsdisplaysink video-sink="kmssink bus-id=a0000000.v_mix plane-id=39 render-rectangle=\"<1280,480,640,480>\"" \
t0.src_6 ! queue ! fpsdisplaysink video-sink="kmssink bus-id=a0000000.v_mix plane-id=40 render-rectangle=\"<0,960,640,480>\"" \
t0.src_7 ! queue ! fpsdisplaysink video-sink="kmssink bus-id=a0000000.v_mix plane-id=41 render-rectangle=\"<640,960,640,480>\""


gst-launch-1.0 \
multifilesrc location=output.avi loop=true \
! decodebin ! fpsdisplaysink video-sink="autovideosink"