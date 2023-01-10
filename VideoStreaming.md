<!--
 Copyright (c) 2022 Innodisk crop.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

- [v4l2](#v4l2)
- [modetest](#modetest)
  - [2020.2.2](#202022)
  - [2022.1](#20221)
- [gstreamer basic](#gstreamer-basic)
  - [基礎](#基礎)
  - [位移](#位移)
  - [縮放](#縮放)
  - [mpeg](#mpeg)
  - [mpeg multi](#mpeg-multi)
  - [mpeg move](#mpeg-move)
    - [mpeg multi](#mpeg-multi-1)
    - [mp4 decode](#mp4-decode)
    - [rtsp rx](#rtsp-rx)
  - [Multiple UVC camera](#multiple-uvc-camera)
- [vvas pipeline](#vvas-pipeline)
  - [gstremaer launch](#gstremaer-launch)
  - [input source](#input-source)
    - [模板](#模板)
    - [example](#example)
  - [inference \& bbox process](#inference--bbox-process)
    - [模板](#模板-1)
    - [example](#example-1)
  - [output sink](#output-sink)
    - [模板](#模板-2)
    - [example](#example-2)

# v4l2
show all formats of camera
```bash
v4l2-ctl -D --list-formats-ext -d /dev/video0 
```
```bash
v4l2-ctl -d /dev/video0 --all
v4l2-ctl --get-fmt-video -d /dev/video0
v4l2-ctl --set-fmt-video=width=640,height=480,pixelformat=1
```

# modetest
## 2020.2.2
```bash
modetest -M xlnx

modetest -D fd4a0000.zynqmp-display

modetest -M xlnx -D 80000000.v_mix

modetest -M xlnx -D fd4a0000.zynqmp-display

modetest -M xlnx-config -D fd4a0000.zynqmp-display

modetest -M xlnx -s 43:1920x1080@NV12

modetest -M xlnx -D 80000000.v_mix -s 52@40:1920x1080@NV16

modetest -M xlnx -D 80000000.v_mix -s 52@40:3840x2160@NV16

modetest -M xlnx -D fd4a0000.zynqmp-display -s 43@41:1920x1080@AR24

modetest -M xlnx -D fd4a0000.zynqmp-display -s 43@41:3840x2160@AR24

modetest -M xlnx -s 43@41:1920x1080@AR24 -P 39@41:1920x1080@NV12 -w 40:alpha:0

modetest -M xlnx -D 80000000.v_mix -s 52@40:1920x1080-74.97@NV16
```
## 2022.1
```bash
modetest -M xlnx -D a0000000.v_mix -s 55@43:1920x1080@NV16

modetest -M xlnx -D a0000000.v_mix -s 55@43:3840x2160@NV16

modetest -M xlnx -D a0000000.v_mix -s 43@41:3840x2160@NV16
```

# gstreamer basic
## 基礎
```bash
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! kmssink bus-id=fd4a0000.zynqmp-display fullscreen-overlay=1 sync=false

gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! kmssink bus-id=80000000.v_mix plane-id=34 fullscreen-overlay=1 sync=false

gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle=\"<0,0,1920,1080>\"" sync=false fullscreen-overlay=true 
```
## 位移 
ender-rectangle="<x,y,w,h>"
```bash
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle="<1280,680,1280,800>" sync=false
```
## 縮放
! videoscale ! "video/x-raw,width=960,height=540" !
```bash
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! videoscale ! "video/x-raw,width=960,height=540" ! kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle="<960,600,540,800>" sync=false

gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! videoscale ! "video/x-raw,width=960,height=540" ! kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle="<0,0,960,540>" sync=false

gst-launch-1.0 -v v4l2src device=/dev/video2 ! video/x-raw, width=1920, height=1080 ! videoconvert ! videoscale ! "video/x-raw,width=960,height=540" ! kmssink bus-id=80000000.v_mix plane-id=35 render-rectangle="<960,0,960,540>" sync=false
```
## mpeg
```bash
gst-launch-1.0 v4l2src -vvv device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=80000000.v_mix plane-id=34 fullscreen-overlay=1 sync=false
```
## mpeg multi
```bash
gst-launch-1.0 v4l2src device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=80000000.v_mix plane-id=34 fullscreen-overlay=1 sync=false \
v4l2src device=/dev/video2 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=80000000.v_mix plane-id=35 fullscreen-overlay=1 sync=false
```
## mpeg move
```bash
gst-launch-1.0 -vvv v4l2src device=/dev/video6 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle=\"<0,0,320,240>\"" sync=false fullscreen-overlay=true
```
### mpeg multi
```bash
gst-launch-1.0 -vvv v4l2src device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle=\"<0,0,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video2 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=35 render-rectangle=\"<320,0,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video4 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=36 render-rectangle=\"<0,240,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video6 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=37 render-rectangle=\"<320,240,320,240>\"" sync=false fullscreen-overlay=true \
```
```bash
gst-launch-1.0 -vvv v4l2src device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=15/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle=\"<0,0,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video2 ! image/jpeg,width=640,height=480,framerate=5/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=35 render-rectangle=\"<320,0,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video4 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=36 render-rectangle=\"<0,240,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video6 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=37 render-rectangle=\"<320,240,320,240>\"" sync=false fullscreen-overlay=true \
```
### mp4 decode
```bash
gst-launch-1.0 \
filesrc location=/home/ubuntu/video/tmp_960.mp4 ! decodebin name=dec ! videoconvert \
! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle=\"<0,0,960,540>\"" show-preroll-frame=false sync=false can-scale=false
```
### rtsp rx
```bash
gst-launch-1.0 rtspsrc location=rtsp://192.168.3.188:8554/test latency=100 \
! queue ! rtph264depay ! h264parse ! avdec_h264 \
! fpsdisplaysink video-sink="autovideosink"
```

## Multiple UVC camera
show uvcvideo kernel message
```bash
echo 0xffff > /sys/module/uvcvideo/parameters/trace
```

```bash
gst-launch-1.0 v4l2src device=/dev/video0 \
! video/x-raw, width=1920, height=1080,framerate=5/1 \
! videoconvert ! fakesink

gst-launch-1.0 v4l2src device=/dev/video0 \
! video/x-raw, width=1280, height=720,framerate=10/1 \
! videoconvert ! fakesink

gst-launch-1.0 v4l2src device=/dev/video0 \
! video/x-raw, width=640, height=480,framerate=30/1 \
! videoconvert ! fakesink
```

```bash
gst-launch-1.0 v4l2src device=/dev/video0 \
! image/jpeg,width=1920,height=1080,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink

gst-launch-1.0 v4l2src device=/dev/video0 \
! image/jpeg,width=1280,height=720,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink

gst-launch-1.0 v4l2src device=/dev/video0 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink
```

```bash
gst-launch-1.0 v4l2src device=/dev/video0 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink

gst-launch-1.0 v4l2src device=/dev/video2 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink

gst-launch-1.0 v4l2src device=/dev/video4 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink

gst-launch-1.0 v4l2src device=/dev/video6 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink
```

```bash
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
```
```bash
gst-launch-1.0 \
v4l2src device=/dev/video8 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink \
v4l2src device=/dev/video10 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink \
v4l2src device=/dev/video12 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink \
v4l2src device=/dev/video14 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! fakesink
```

```bash
gst-launch-1.0 \
v4l2src device=/dev/video0 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! autovideosink \
v4l2src device=/dev/video2 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! autovideosink \
v4l2src device=/dev/video4 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! autovideosink \
v4l2src device=/dev/video6 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! autovideosink
```

```bash
./rtsp_server_app \
"videomixer name=mix \
sink_0::xpos=0 sink_0::ypos=0 \
sink_1::xpos=640 sink_1::ypos=0 \
sink_2::xpos=0 sink_2::ypos=480 \
sink_3::xpos=640 sink_2::ypos=480 \
! omxh264enc target-bitrate=2000 control-rate=2 \
! h264parse ! rtph264pay name=pay0 pt=96 \
v4l2src device=/dev/video8 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! mix.sink_0 \
v4l2src device=/dev/video10 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! mix.sink_1 \
v4l2src device=/dev/video12 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! mix.sink_2 \
v4l2src device=/dev/video14 \
! image/jpeg,width=640,height=480,framerate=30/1 \
! jpegparse ! jpegdec ! mix.sink_3"
```

# vvas pipeline  
## gstremaer launch
```bash
gst-launch-1.0 \
gst-launch-1.0 -vvv \
```
## input source
### 模板
```bash
v4l2src device=${UVC_CAMERA_DEV} ! video/x-raw, width=${WIDTH}, height=${HEIGHT} ! videoconvert \
filesrc location="${H264_VIDEO_FILE}" ! h264parse ! omxh264dec internal-entropy-buffers=3 \
multifilesrc location="${H264_VIDEO_FILE}" loop=${BOOL_LOOP} ! h264parse ! omxh264dec internal-entropy-buffers=3 \
```
### example
```bash
v4l2src device=/dev/video0 ! video/x-raw, width=1024, height=576 ! videoconvert \
v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert \
filesrc location="/home/petalinux/walking_humans.nv12.1920x1080.h264" ! h264parse ! omxh264dec internal-entropy-buffers=3 \
filesrc location="/home/petalinux/traffic_1920x1080.h264" ! h264parse ! omxh264dec internal-entropy-buffers=3 \
multifilesrc location="/home/petalinux/walking_humans.nv12.1920x1080.h264" loop=true ! h264parse ! omxh264dec internal-entropy-buffers=3 \
multifilesrc location="/home/petalinux/traffic_1920x1080.h264" loop=true ! h264parse ! omxh264dec internal-entropy-buffers=3 \
```
## inference & bbox process
### 模板
```bash
! tee name=t${NUM} \
t${NUM}.src_0 \
! queue ! ivas_xmultisrc kconfig="${PATH}/ped_pp.json"  \
! queue ! ivas_xfilter kernels-config="${PATH}/kernel_dpu.json"  \
! queue ! scalem${NUM}.sink_master ivas_xmetaaffixer name=scalem${NUM} scalem${NUM}.src_master \
! fakesink \
t${NUM}.src_1 \
! queue ! scalem${NUM}.sink_slave_0 scalem${NUM}.src_slave_0 \
! queue ! ivas_xfilter kernels-config="${PATH}/kernel_bbox.json"  \
```
### example
```bash
! tee name=t0 \
t0.src_0 \
! queue ! ivas_xmultisrc kconfig="/home/petalinux/cuz/densebox_640_360/ped_pp.json"  \
! queue ! ivas_xfilter kernels-config="/home/petalinux/cuz/densebox_640_360/kernel_dpu.json"  \
! queue ! scalem0.sink_master ivas_xmetaaffixer name=scalem0 scalem0.src_master \
! fakesink \
t0.src_1 \
! queue ! scalem0.sink_slave_0 scalem0.src_slave_0 \
! queue ! ivas_xfilter kernels-config="/home/petalinux/cuz/densebox_640_360/kernel_bbox.json"  \
```
## output sink
### 模板
```bash
! kmssink bus-id=${AXI_ADDRESS}.v_mix plane-id=${ID} render-rectangle="<${X_AXI},${Y_AXI},${WIDTH},${HEIGHT}>" show-preroll-frame=false sync=false can-scale=false \

! kmssink bus-id=fd4a0000.zynqmp-display fullscreen-overlay=1 sync=false
```
### example
```bash
! kmssink bus-id=80000000.v_mix plane-id=37 render-rectangle="<1920,1080,1200,1200>" show-preroll-frame=false sync=false can-scale=false \
```