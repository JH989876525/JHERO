
[](https://patorjk.com/software/taag/)
```
       ____  ____________  ____ 
      / / / / / ____/ __ \/ __ \
 __  / / /_/ / __/ / /_/ / / / /
/ /_/ / __  / /___/ _, _/ /_/ / 
\____/_/ /_/_____/_/ |_|\____/  
                                
```                                                 
- [awk](#awk)
- [sed](#sed)
- [echo pipe](#echo-pipe)
- [tar](#tar)
  - [compress](#compress)
  - [decompress](#decompress)
- [color bash](#color-bash)
- [kill](#kill)
- [device-tree compiler](#device-tree-compiler)
- [samba](#samba)
- [reset USB](#reset-usb)
  - [USB3.0](#usb30)
  - [USB2.0](#usb20)
- [fio](#fio)
- [usb bandwidth ctrl](#usb-bandwidth-ctrl)
- [i2c tools](#i2c-tools)
- [can util](#can-util)
- [k26 suspend](#k26-suspend)
  - [waking up IO from UART](#waking-up-io-from-uart)
  - [system suspend](#system-suspend)
- [grep if](#grep-if)
- [install rpm](#install-rpm)
- [install rpm on ubuntu](#install-rpm-on-ubuntu)
- [initrd boot run script](#initrd-boot-run-script)
- [SD flash](#sd-flash)
  - [basic](#basic)
  - [combo to emmc](#combo-to-emmc)
  - [resize disk](#resize-disk)
- [minicom](#minicom)
- [PCIE reset](#pcie-reset)
- [ffmpeg](#ffmpeg)
  - [mp4 to 264](#mp4-to-264)
  - [resize](#resize)
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

# tar
## compress
```bash
cd <path-to-package-all>
sudo tar -zcvf rootfs.tar.gz .
sudo tar -zcvf <path-you-like>/rootfs.tar.gz .
```

## decompress
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
# device-tree compiler
```bash
dtc -O dts -o system.dts system.dtb

dtc -O dtb -o system.dtb system.dts
```
# samba
mount -t cifs -o username=jhh,password=user,vers=1.0 //172.16.92.131/share /mnt/cifs

# reset USB
## USB3.0
```bash
sudo sh -c 'AUTHFILE="/sys/bus/usb/devices/usb2/authorized" ; echo 0 > "$AUTHFILE" ; sleep 1 ; echo 1 > "$AUTHFILE"'
```

## USB2.0
```bash
sudo sh -c 'AUTHFILE="/sys/bus/usb/devices/usb1/authorized" ; echo 0 > "$AUTHFILE" ; sleep 1 ; echo 1 > "$AUTHFILE"'
```

# fio
[Github repo.](https://github.com/JH989876525/fio4k)

# usb bandwidth ctrl
[Reference from](https://www.thegoodpenguin.co.uk/blog/multiple-uvc-cameras-on-linux/)
```bash
echo -1 > /sys/module/usbcore/parameters/autosuspend
echo 0x400 > /sys/module/uvcvideo/parameters/trace
echo 640 > /sys/module/uvcvideo/parameters/quirks
```

# i2c tools
```bash
i2cdetect -r -y 0
i2cdump -f -y 0 0x74
i2cset -f -y 0 0x74 0x00 0x0f
i2cdump -f -y 0 0x27
```

# can util
```bash
ip link set can0 up type can bitrate 100000
cansend can0 123#0011223344556677
candump can0
ifconfig can0 down
```

# k26 suspend
## waking up IO from UART
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
sudo rpm -ivh --froce ./*.rpm
```

# install rpm on ubuntu
```bash
sudo alien --to-deb --target=arm64 ./*.rpm 

sudo dpkg -i --force-all ./*.deb
```

# initrd boot run script
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
## resize disk
```
cfdisk /dev/mmcblk1
e2fsck -f /dev/mmcblk1p2
resize2fs /dev/mmcblk1p2
```

# minicom
```bash
sudo minicom -c on -D /dev/ttyUSB1
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