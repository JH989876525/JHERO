<!--
 Copyright (c) 2023 innodisk Crop.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->
# Example
## Smartcam
```bash
GST_DEBUG=2 gst-launch-1.0 -vvv \
v4l2src device=/dev/video0 ! video/x-raw, width=640, height=480 \
! videoconvert ! video/x-raw, format=NV12 \
! tee name=t \
! queue ! vvas_xmultisrc kconfig="/home/petalinux/config/preprocess.json" \
! queue ! vvas_xfilter kernels-config="/home/petalinux/config/aiinference.json" \
! ima.sink_master vvas_xmetaaffixer name=ima ima.src_master ! fakesink \
t. \
! queue max-size-buffers=1 leaky=0 ! ima.sink_slave_0 ima.src_slave_0 \
! queue ! vvas_xfilter kernels-config="/home/petalinux/config/drawresult.json" \
! kmssink bus-id=fd4a0000.display fullscreen-overlay=1 sync=false
```