<!--
 Copyright (c) 2024 innodisk Crop.
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

1. Install `xserver-xorg-video-dummy`.
   ```bash
    sudo apt-get install xserver-xorg-video-dummy
   ```
2. Create file `/usr/share/X11/xorg.conf.d/xorg.conf` within following text.
   ```
   Section "Device"
        Identifier  "Configured Video Device"
        Driver      "dummy"
    EndSection

    Section "Monitor"
        Identifier  "Configured Monitor"
        HorizSync 31.5-48.5
        VertRefresh 50-70
    EndSection

    Section "Screen"
        Identifier  "Default Screen"
        Monitor     "Configured Monitor"
        Device      "Configured Video Device"
        DefaultDepth 24
        SubSection "Display"
        Depth 24
        Modes "1920x1080"
        EndSubSection
    EndSection
   ```
3. Reboot the system.

- Then the instance of display port will be not availble, remove the `xorg.conf` to disable the dummy screen if in need.