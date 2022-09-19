
[](https://patorjk.com/software/taag/)
```
    _____   ___   ______  ____  _________ __ __
   /  _/ | / / | / / __ \/ __ \/  _/ ___// //_/
   / //  |/ /  |/ / / / / / / // / \__ \/ ,<   
 _/ // /|  / /|  / /_/ / /_/ // / ___/ / /| |  
/___/_/ |_/_/ |_/\____/_____/___//____/_/ |_|  

```                                                 
- [awk](#awk)
- [sed](#sed)
- [petalinux create](#petalinux-create)
- [petalinux2020.2 local mirror setver setup](#petalinux20202-local-mirror-setver-setup)
  - [At JHH](#at-jhh)
- [petalinux2020.2.2 local mirror setver setup](#petalinux202022-local-mirror-setver-setup)
  - [At JHH](#at-jhh-1)
- [petalinux  local mirror setver original](#petalinux--local-mirror-setver-original)
- [petalinux build app](#petalinux-build-app)
- [petalinux clean all](#petalinux-clean-all)
- [devicetree write protect](#devicetree-write-protect)
- [tar](#tar)
  - [打包](#打包)
  - [解壓](#解壓)
- [color bash](#color-bash)
- [kill](#kill)
- [device-tree](#device-tree)
- [samba](#samba)
- [plnx rootfs types](#plnx-rootfs-types)
- [reset USB](#reset-usb)
- [dd](#dd)
- [xmutil](#xmutil)
- [disk speed](#disk-speed)
- [modetest](#modetest)
- [gstreamer](#gstreamer)
  - [基礎](#基礎)
  - [位移](#位移)
  - [縮放](#縮放)
  - [mpeg](#mpeg)
  - [mpeg multi](#mpeg-multi)
  - [mpeg move](#mpeg-move)
    - [mpeg multi](#mpeg-multi-1)
    - [mp4 decode](#mp4-decode)
    - [rtsp rx](#rtsp-rx)
- [v4l2](#v4l2)
- [usb bandwidth ctrl](#usb-bandwidth-ctrl)
- [nvme fdisk](#nvme-fdisk)
- [i2c tools](#i2c-tools)
- [DPU fingerprint](#dpu-fingerprint)
  - [4096 fingerprint](#4096-fingerprint)
  - [3136 fingerprint](#3136-fingerprint)
- [vvas pipeline](#vvas-pipeline)
  - [gstremaer launch](#gstremaer-launch)
  - [input source](#input-source)
    - [模板](#模板)
    - [example](#example)
  - [inference & bbox process](#inference--bbox-process)
    - [模板](#模板-1)
    - [example](#example-1)
  - [output sink](#output-sink)
    - [模板](#模板-2)
    - [example](#example-2)
- [k26 suspend](#k26-suspend)
  - [設定喚醒機制](#設定喚醒機制)
    - [UART](#uart)
  - [system suspend](#system-suspend)
- [grep if](#grep-if)
- [install rpm](#install-rpm)
- [install rpm on ubuntu](#install-rpm-on-ubuntu)
- [set boot run script](#set-boot-run-script)
- [SD flash](#sd-flash)
- [minicom](#minicom)
- [aibox](#aibox)
- [PCIE reset](#pcie-reset)

# awk
```
awk {'print $2'}
awk -F: {'print $2'}
awk -F, {'print $2'}
```
# sed
```
sed -i 's/MEANR/%s/g' %s

| sed 's/MEANR/NWER/g'
```
# petalinux create

```
petalinux-create -t project --template zynqMP -n 

petalinux-config --get-hw-description

petalinux-build && petalinux-build --sdk && petalinux-package --sysroot

```
# petalinux2020.2 local mirror setver setup
## At JHH
```
file:///home/jhh/Lmirror/104_downloads/downloads
/home/jhh/Lmirror/sstate_aarch64_2020.2/aarch64

DL_DIR = "/home/jhh/Lmirror/104_downloads/downloads"
SSTATE_DIR = "/home/jhh/Lmirror/sstate_aarch64_2020.2/aarch64"
```
# petalinux2020.2.2 local mirror setver setup
## At JHH
```
file:///media/jhh/ExtraSSD/LMirror2020.2.2/kv260/downloads
/media/jhh/ExtraSSD/LMirror2020.2.2/sstate-cache/sstate_aarch64_2020.2.2-k26/aarch64

DL_DIR = "/media/jhh/ExtraSSD/LMirror2020.2.2/kv260/downloads"
SSTATE_DIR = "/media/jhh/ExtraSSD/LMirror2020.2.2/sstate-cache/sstate_aarch64_2020.2.2-k26/aarch64"
```
# petalinux  local mirror setver original
```
http://petalinux.xilinx.com/sswreleases/rel-v${PETALINUX_VER%%.*}/downloads 
```
# petalinux build app
```
petalinux-create -t apps --name nameofurapp

petalinux-build -c $APPNAME
```
app pl.stsi need to add "fpga-config-from-dmabuf;" to overlay0 for fpga_full
```
fragment@0 {
        overlay0: __overlay__ {
        fpga-config-from-dmabuf;
        };
};
```
# petalinux clean all
```
petalinux-build -x mrproper
petalinux-build -x distclean
petalinux-build -x mrproper && petalinux-build -x distclean
```


# devicetree write protect
```
&sdhci1 {
        no-1-8-v;
        disable-wp;
};
```

# tar
## 打包
```
cd <path-to-package-all>
sudo tar -zcvf rootfs.tar.gz .
sudo tar -zcvf <path-you-like>/rootfs.tar.gz .
```

## 解壓
```
sudo tar -zxvf rootfs.tar.gz -C $ROOTPATH
```

# color bash
```
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'
echo -e "I am ${RED}dangerous${NC}."
```

# kill
```
jobs -l

kill -9 ${PID}

ps -aux | pgrep ${TARGET} | xargs kill -9
```
# device-tree
```
dtc -O dts -o system.dts system.dtb

dtc -O dtb -o system.dtb system.dts
```
# samba
mount -t cifs -o username=jhh,password=user,vers=1.0 //172.16.92.131/share /mnt/cifs

# plnx rootfs types
cpio cpio.gz tar.gz ext4 cpio.gz.u-boot jffs2

# reset USB
sudo sh -c 'AUTHFILE="/sys/bus/usb/devices/usb2/authorized" ; echo 0 > "$AUTHFILE" ; sleep 1 ; echo 1 > "$AUTHFILE"'

# dd

# xmutil
```
xmutil unloadapp
xmutil listapps
xmutil loadapp

xmutil unloadapp && sleep 1 && xmutil loadapp 
```
# disk speed
```
dd if=/dev/zero of=/mnt/SDCard.dd conv=fdatasync bs=5M count=5 2>&1
time dd if=/dev/zero of=/run/media/nvme0n1p1/4K1M bs=4k count=1000000 oflag=direct status=progress

time dd if=/dev/zero of=/mnt/ssd/1M1K bs=1M count=1024
time dd if=/dev/zero of=/mnt/ssd/8K1M bs=8k count=1000000
sudo hdparm -Tt /dev/nvme0n1

time dd if=/dev/zero of=/mnt/ssd/ddout bs=4k count=1000000 conv=fsync oflag=direct status=progress
time dd if=/mnt/ssd/ddout of=/dev/null bs=4k count=1000000 conv=fsync iflag=direct status=progress
hdparm -Tt /dev/nvme0n1
fio --filename=/dev/nvme0n1 --direct=1 --rw=randrw --iodepth=128 -thread -numjobs=30 -rwmixread=50 -ioengine=psync -bs=4k -size=1G -group_reporting -name=test -runtime=10
fio --filename=/dev/nvme0n1 --direct=1 --rw=randrw --iodepth=128 -thread -numjobs=16 -rwmixread=50 -ioengine=psync -bs=4k -size=1G -group_reporting -name=test -runtime=10
fio --filename=/dev/nvme0n1 --direct=1 --rw=randrw --iodepth=128 -thread -numjobs=8 -rwmixread=50 -ioengine=psync -bs=4k -size=1G -group_reporting -name=test -runtime=10
```
# modetest
```
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
# gstreamer
## 基礎
```
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! kmssink bus-id=fd4a0000.zynqmp-display fullscreen-overlay=1 sync=false

gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! kmssink bus-id=80000000.v_mix plane-id=34 fullscreen-overlay=1 sync=false

gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle=\"<0,0,1920,1080>\"" sync=false fullscreen-overlay=true 
```
## 位移 
ender-rectangle="<x,y,w,h>"
```
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle="<1280,680,1280,800>" sync=false
```
## 縮放
! videoscale ! "video/x-raw,width=960,height=540" !
```
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! videoscale ! "video/x-raw,width=960,height=540" ! kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle="<960,600,540,800>" sync=false

gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert ! videoscale ! "video/x-raw,width=960,height=540" ! kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle="<0,0,960,540>" sync=false

gst-launch-1.0 -v v4l2src device=/dev/video2 ! video/x-raw, width=1920, height=1080 ! videoconvert ! videoscale ! "video/x-raw,width=960,height=540" ! kmssink bus-id=80000000.v_mix plane-id=35 render-rectangle="<960,0,960,540>" sync=false
```
## mpeg
```
gst-launch-1.0 v4l2src -vvv device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=80000000.v_mix plane-id=34 fullscreen-overlay=1 sync=false
```
## mpeg multi
```
gst-launch-1.0 v4l2src device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=80000000.v_mix plane-id=34 fullscreen-overlay=1 sync=false \
v4l2src device=/dev/video2 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! kmssink bus-id=80000000.v_mix plane-id=35 fullscreen-overlay=1 sync=false
```
##　mpeg scale
‵‵‵
gst-launch-1.0 -vvv v4l2src device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! videoscale ! kmssink bus-id=80000000.v_mix plane-id=34 fullscreen-overlay=1 sync=false
‵‵‵
## mpeg move
```
gst-launch-1.0 -vvv v4l2src device=/dev/video6 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle=\"<0,0,320,240>\"" sync=false fullscreen-overlay=true
```
### mpeg multi
```
gst-launch-1.0 -vvv v4l2src device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle=\"<0,0,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video2 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=35 render-rectangle=\"<320,0,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video4 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=36 render-rectangle=\"<0,240,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video6 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=37 render-rectangle=\"<320,240,320,240>\"" sync=false fullscreen-overlay=true \
```
```
gst-launch-1.0 -vvv v4l2src device=/dev/video0 ! image/jpeg,width=640,height=480,framerate=15/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle=\"<0,0,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video2 ! image/jpeg,width=640,height=480,framerate=5/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=35 render-rectangle=\"<320,0,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video4 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=36 render-rectangle=\"<0,240,320,240>\"" sync=false fullscreen-overlay=true \
                                        v4l2src device=/dev/video6 ! image/jpeg,width=640,height=480,framerate=30/1 ! jpegparse ! jpegdec ! videoconvert ! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=37 render-rectangle=\"<320,240,320,240>\"" sync=false fullscreen-overlay=true \
```
### mp4 decode
```
gst-launch-1.0 \
filesrc location=/home/ubuntu/video/tmp_960.mp4 ! decodebin name=dec ! videoconvert \
! fpsdisplaysink video-sink="kmssink bus-id=80000000.v_mix plane-id=34 render-rectangle=\"<0,0,960,540>\"" show-preroll-frame=false sync=false can-scale=false
```
### rtsp rx
```
gst-launch-1.0 rtspsrc location=rtsp://192.168.3.104:8554/test latency=100 \
! queue ! rtph264depay ! h264parse ! avdec_h264 \
! fpsdisplaysink video-sink="autovideosink"
```




# v4l2
```
v4l2-ctl -d /dev/video0 --all
v4l2-ctl --get-fmt-video -d /dev/video0
v4l2-ctl --set-fmt-video=width=640,height=480,pixelformat=1
```
# usb bandwidth ctrl
```
echo -1 > /sys/module/usbcore/parameters/autosuspend
echo 0x400 > /sys/module/uvcvideo/parameters/trace
echo 640 > /sys/module/uvcvideo/parameters/quirks
```

# nvme fdisk
```
umount /dev/nvme0n1p1
fdisk /dev/nvme0n1
mkfs.ext4 -L nvmessd /dev/nvme0n1p1
mount /dev/nvme0n1p1 /mnt/nvmeSSD/
```
# i2c tools
```
sudo i2cdetect -r -y 0
sudo i2cdump -f -y 0 0x74
sudo i2cset -f -y 0 0x74 0x00 0x0f
sudo i2cdump -f -y 0 0x27
```


# DPU fingerprint
## 4096 fingerprint
```
{"fingerprint":"0x1000020F6014407"}
```
## 3136 fingerprint
```
{"fingerprint":"0x1000020F6014406"}
```
# vvas pipeline  
## gstremaer launch
        gst-launch-1.0 \
        gst-launch-1.0 -vvv \
## input source
### 模板

        v4l2src device=${UVC_CAMERA_DEV} ! video/x-raw, width=${WIDTH}, height=${HEIGHT} ! videoconvert \
        filesrc location="${H264_VIDEO_FILE}" ! h264parse ! omxh264dec internal-entropy-buffers=3 \
        multifilesrc location="${H264_VIDEO_FILE}" loop=${BOOL_LOOP} ! h264parse ! omxh264dec internal-entropy-buffers=3 \
### example

        v4l2src device=/dev/video0 ! video/x-raw, width=1024, height=576 ! videoconvert \
        v4l2src device=/dev/video0 ! video/x-raw, width=1920, height=1080 ! videoconvert \
        filesrc location="/home/petalinux/walking_humans.nv12.1920x1080.h264" ! h264parse ! omxh264dec internal-entropy-buffers=3 \
        filesrc location="/home/petalinux/traffic_1920x1080.h264" ! h264parse ! omxh264dec internal-entropy-buffers=3 \
        multifilesrc location="/home/petalinux/walking_humans.nv12.1920x1080.h264" loop=true ! h264parse ! omxh264dec internal-entropy-buffers=3 \
        multifilesrc location="/home/petalinux/traffic_1920x1080.h264" loop=true ! h264parse ! omxh264dec internal-entropy-buffers=3 \

## inference & bbox process
### 模板

        ! tee name=t${NUM} \
        t${NUM}.src_0 \
        ! queue ! ivas_xmultisrc kconfig="${PATH}/ped_pp.json"  \
        ! queue ! ivas_xfilter kernels-config="${PATH}/kernel_dpu.json"  \
        ! queue ! scalem${NUM}.sink_master ivas_xmetaaffixer name=scalem${NUM} scalem${NUM}.src_master \
        ! fakesink \
        t${NUM}.src_1 \
        ! queue ! scalem${NUM}.sink_slave_0 scalem${NUM}.src_slave_0 \
        ! queue ! ivas_xfilter kernels-config="${PATH}/kernel_bbox.json"  \

### example

        ! tee name=t0 \
        t0.src_0 \
        ! queue ! ivas_xmultisrc kconfig="/home/petalinux/cuz/densebox_640_360/ped_pp.json"  \
        ! queue ! ivas_xfilter kernels-config="/home/petalinux/cuz/densebox_640_360/kernel_dpu.json"  \
        ! queue ! scalem0.sink_master ivas_xmetaaffixer name=scalem0 scalem0.src_master \
        ! fakesink \
        t0.src_1 \
        ! queue ! scalem0.sink_slave_0 scalem0.src_slave_0 \
        ! queue ! ivas_xfilter kernels-config="/home/petalinux/cuz/densebox_640_360/kernel_bbox.json"  \

## output sink
### 模板

        ! kmssink bus-id=${AXI_ADDRESS}.v_mix plane-id=${ID} render-rectangle="<${X_AXI},${Y_AXI},${WIDTH},${HEIGHT}>" show-preroll-frame=false sync=false can-scale=false \

        ! kmssink bus-id=fd4a0000.zynqmp-display fullscreen-overlay=1 sync=false

### example

        ! kmssink bus-id=80000000.v_mix plane-id=37 render-rectangle="<1920,1080,1200,1200>" show-preroll-frame=false sync=false can-scale=false \


# k26 suspend
## 設定喚醒機制
### UART
```
echo enabled > /sys/devices/platform/amba/ff000000.serial/tty/ttyPS1/power/wakeup
cat /sys/devices/platform/amba/ff000000.serial/tty/ttyPS1/power/wakeup

echo enabled > /sys/devices/platform/amba/ff010000.serial/tty/ttyPS0/power/wakeup
cat /sys/devices/platform/amba/ff010000.serial/tty/ttyPS0/power/wakeup
```
## system suspend
```
echo mem > /sys/power/state
```
# grep if
```
cat 1.log | grep -q "string"

if [ "$?" -eq "0" ] ; then
        echo "exist"
else
        echo "not exist"
fi
```
# install rpm
```
sudo rpm -ivh ./*.rpm
```

# install rpm on ubuntu
```
sudo alien --to-deb --target=arm64 ./*.rpm 

sudo dpkg -i --force-all ./*.deb
```
```
/usr/lib/aarch64-linux-gnu
```
# set boot run script
```
cd /etc/init.d
touch innodisk.sh
vi innodisk.sh
```
```
#!/bin/bash
case "$1" in
'start')
/home/petalinux/boot.sh 
;;
'stop')
;;
*)
;;
esac
exit
```
```
sudo update-rc.d innodisk.sh defaults 99
sudo update-rc.d -f innodisk.sh remove
```

# SD flash
```
echo -e "d\n\nd\n\nd\n\nn\n\n\n\n+1G\ny\na\nn\n\n\n\n\ny\nw\n" | sudo fdisk /dev/sdx
```
```
sudo mkfs.vfat -F 32 -n boot /dev/sd
sudo mkfs.ext4 -L root /dev/sd
```

# minicom
```
sudo minicom -c on -D /dev/ttyUSB1
```

# aibox
```
/usr/local/opencv/include/opencv2/
/usr/local/opencv/lib/

/usr/include/
/usr/lib/
```
```
export LD_LIBRARY_PATH=/home/ubuntu/aibox/ArenaSDK_Linux_ARM64/lib/:/home/ubuntu/aibox/ArenaSDK_Linux_ARM64/GenICam/library/lib/Linux64_ARM/:/home/ubuntu/aibox/ArenaSDK_Linux_ARM64/ffmpeg/:/usr/local/opencv/lib/

/home/ubuntu/aibox/aibox_tmp -v /home/ubuntu/aibox/test1_remux.webm /home/ubuntu/aibox/model256.xmodel

/home/ubuntu/aibox/aibox_tmp -i /home/ubuntu/aibox/tmp /home/ubuntu/aibox/model256.xmodel
```

# PCIE reset
echo 1 > /sys/bus/pci/rescan


