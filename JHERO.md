
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
- [echo pipe](#echo-pipe)
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
  - [USB3.0](#usb30)
  - [USB2.0](#usb20)
- [xmutil](#xmutil)
- [dd](#dd)
  - [disk speed](#disk-speed)
- [usb bandwidth ctrl](#usb-bandwidth-ctrl)
- [nvme fdisk](#nvme-fdisk)
- [i2c tools](#i2c-tools)
- [DPU fingerprint](#dpu-fingerprint)
  - [4096 fingerprint](#4096-fingerprint)
  - [3136 fingerprint](#3136-fingerprint)
- [k26 suspend](#k26-suspend)
  - [設定喚醒機制](#設定喚醒機制)
    - [UART](#uart)
  - [system suspend](#system-suspend)
- [grep if](#grep-if)
- [install rpm](#install-rpm)
- [install rpm on ubuntu](#install-rpm-on-ubuntu)
- [set boot run script](#set-boot-run-script)
- [SD flash](#sd-flash)
  - [basic](#basic)
  - [combo to emmc](#combo-to-emmc)
- [minicom](#minicom)
  - [resize](#resize)
- [aibox](#aibox)
- [PCIE reset](#pcie-reset)
- [ffmpeg](#ffmpeg)
  - [mp4 to 264](#mp4-to-264)
  - [resize](#resize-1)
- [kill](#kill-1)
- [ethernet](#ethernet)
  - [ethernet change speed](#ethernet-change-speed)

# awk
```bash
awk '{print $4}'
awk -F: {'print $2'}
awk -F, {'print $2'}
```
# sed
```bash
sed -i 's/MEANR/%s/g' %s

sed 's/MEANR/NWER/g'
```
# echo pipe
```bash
find /sys/devices/platform -name "control" | grep 'usb1\|usb2\|usb3\|usb4' | xargs cat

echo on | tee $(find /sys/devices/platform -name "control" | grep 'usb1\|usb2\|usb3\|usb4')
```
# petalinux create
```bash
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
```bash
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
```bash
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
```bash
cd <path-to-package-all>
sudo tar -zcvf rootfs.tar.gz .
sudo tar -zcvf <path-you-like>/rootfs.tar.gz .
```

## 解壓
```bash
sudo tar -zxvf rootfs.tar.gz -C $ROOTPATH
```

# color bash
```bash
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'
echo -e "I am ${RED}dangerous${NC}."
```

# kill
```bash
jobs -l

kill -9 ${PID}

ps -aux | pgrep ${TARGET} | xargs kill -9
```
# device-tree
```bash
dtc -O dts -o system.dts system.dtb

dtc -O dtb -o system.dtb system.dts
```
# samba
mount -t cifs -o username=jhh,password=user,vers=1.0 //172.16.92.131/share /mnt/cifs

# plnx rootfs types
cpio cpio.gz tar.gz ext4 cpio.gz.u-boot jffs2

# reset USB
## USB3.0
```bash
sudo sh -c 'AUTHFILE="/sys/bus/usb/devices/usb2/authorized" ; echo 0 > "$AUTHFILE" ; sleep 1 ; echo 1 > "$AUTHFILE"'
```

## USB2.0
```bash
sudo sh -c 'AUTHFILE="/sys/bus/usb/devices/usb1/authorized" ; echo 0 > "$AUTHFILE" ; sleep 1 ; echo 1 > "$AUTHFILE"'
```

# xmutil
```bash
xmutil unloadapp
xmutil listapps
xmutil loadapp

xmutil unloadapp && sleep 1 && xmutil loadapp 
```
# dd
## disk speed
```bash
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

# usb bandwidth ctrl
```bash
echo -1 > /sys/module/usbcore/parameters/autosuspend
echo 0x400 > /sys/module/uvcvideo/parameters/trace
echo 640 > /sys/module/uvcvideo/parameters/quirks
```

# nvme fdisk
```bash
umount /dev/nvme0n1p1
fdisk /dev/nvme0n1
mkfs.ext4 -L nvmessd /dev/nvme0n1p1
mount /dev/nvme0n1p1 /mnt/nvmeSSD/
```
# i2c tools
```bash
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


# k26 suspend
## 設定喚醒機制
### UART
```bash
echo enabled > /sys/devices/platform/amba/ff000000.serial/tty/ttyPS1/power/wakeup
cat /sys/devices/platform/amba/ff000000.serial/tty/ttyPS1/power/wakeup

echo enabled > /sys/devices/platform/amba/ff010000.serial/tty/ttyPS0/power/wakeup
cat /sys/devices/platform/amba/ff010000.serial/tty/ttyPS0/power/wakeup
```
## system suspend
```bash
echo mem > /sys/power/state
```
# grep if
```bash
cat 1.log | grep -q "string"

if [ "$?" -eq "0" ] ; then
        echo "exist"
else
        echo "not exist"
fi
```
# install rpm
```bash
sudo rpm -ivh ./*.rpm
```

# install rpm on ubuntu
```bash
sudo alien --to-deb --target=arm64 ./*.rpm 

sudo dpkg -i --force-all ./*.deb
```
```bash
/usr/lib/aarch64-linux-gnu
```
# set boot run script
```bash
cd /etc/init.d
touch innodisk.sh
vi innodisk.sh
```
```bash
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
```bash
sudo update-rc.d innodisk.sh defaults 99
sudo update-rc.d -f innodisk.sh remove
```

# SD flash
## basic
```bash
echo -e "d\n\nd\n\nd\n\nn\n\n\n\n+1G\ny\na\nn\n\n\n\n\ny\nw\n" | sudo fdisk /dev/sdx
```
```bash
sudo mkfs.vfat -F 32 -n boot /dev/sd
sudo mkfs.ext4 -L root /dev/sd
```
## combo to emmc
```bash
echo -e "d\n\nd\n\nd\n\nn\n\n\n\n+1G\ny\na\nn\n\n\n\n\ny\nw\n" | fdisk /dev/mmcblk0 
sleep 3
mkfs.vfat -F 32 -n boot /dev/mmcblk0p1
mkfs.ext4 -L root /dev/mmcblk0p2
sleep 3
mount /dev/mmcblk0p1 /media/sd-mmcblk0p1
mount /dev/mmcblk0p2 /media/sd-mmcblk0p2
sleep 3
cp /home/petalinux/emmc/* /media/sd-mmcblk0p1/
sleep 3
tar -zxvf rootfs.tar.gz -C /media/sd-mmcblk0p2/
sync
```

# minicom
```bash
sudo minicom -c on -D /dev/ttyUSB1
```
## resize
```bash
shopt -s checkwinsize && resize
```

# aibox
```bash
/usr/local/opencv/include/opencv2/
/usr/local/opencv/lib/

/usr/include/
/usr/lib/
```
```bash
export LD_LIBRARY_PATH=/home/ubuntu/aibox/ArenaSDK_Linux_ARM64/lib/:/home/ubuntu/aibox/ArenaSDK_Linux_ARM64/GenICam/library/lib/Linux64_ARM/:/home/ubuntu/aibox/ArenaSDK_Linux_ARM64/ffmpeg/:/usr/local/opencv/lib/

/home/ubuntu/aibox/aibox_tmp -v /home/ubuntu/aibox/test1_remux.webm /home/ubuntu/aibox/model256.xmodel

/home/ubuntu/aibox/aibox_tmp -i /home/ubuntu/aibox/tmp /home/ubuntu/aibox/model256.xmodel
```

# PCIE reset
```bash
echo 1 > /sys/bus/pci/rescan
```

# ffmpeg
## mp4 to 264
```bash
ffmpeg -i $INPUTVIDEO -an -vcodec libx264 -crf 23 $OUTPUTVIDEO
```
## resize
```bash
ffmpeg -i $INPUTVIDEO -vf scale=${W}:${H} $OUTPUTVIDEO
ffmpeg -i $INPUTVIDEO -vf scale=${W}:-1 $OUTPUTVIDEO
```

# kill
```bash
ps aux | pgrep gst | sudo xargs kill -9
```

# ethernet
## ethernet change speed
```bash
SPEED=${1:-1000}
sudo ethtool -s eth0 autoneg on speed ${SPEED} duplex full
sleep 3
cat /sys/class/net/eth0/speed
```