# EMULATE RASPBERRY PI 2 ON WINDOWS HOST (Windows 7 or Windows 10)


## Installation:
Download using the 'Download Zip' button on the right and unzip to a folder on your computer.Then follow the instructions below.

### Steps to follow:

1. double-click on install.bat 
   (could take a while, be patient, also needs to download raspian image ~1.2GB)
    Here is what happens
    - Downloads latest raspian image (OS of raspberry pi 2)
    - unzips emulator(QEMU) and raspian image
    - expands the raspian image (how large it expands the image is controlled by a file called 
      'RESIZED-FILESIZE.txt' , default is 4G)
    - emulator opens in new window. If all goes to plan, you should end up with the following screen.
    ![install.jpg](https://raw.githubusercontent.com/mohankumargupta/raspberrypiVM/master/install.jpg)

2. On the emulator screen, type the following command:
    sed -i -e 's/^/#/' /etc/ld.preload.so

    Then type the following commands one line at a time (unfortunately, no copy/paste available in qemu).

    echo > /etc/udev/rules.d/90-qemu.rules

    echo 'KERNEL=="sda", SYMLINK+="mmcblk0"' >> /etc/udev/rules.d/90-qemu.rules

    echo 'KERNEL=="sda?", SYMLINK+="mmcblk0p%n"' >> /etc/udev/rules.d/90-qemu.rules

    echo 'KERNEL=="sda2", SYMLINK+="root"' >> /etc/udev/rules.d/90-qemu.rules

    cat /etc/udev/rules.d/90-qemu.rules

    The last command will print the contents of 90-qemu.rules file - the output should look like this
    ![udevrules.jpg](https://raw.githubusercontent.com/mohankumargupta/raspberrypiVM/master/udevrules.jpg)

2a. dosfsck -w -r -l -a -v -t /dev/mmcblk0p1

3. double-click run.bat

   ### RUNNING FOR THE FIRST TIME
   When you run for the first time, you will end up on this screen.

   ![run.jpg](https://raw.githubusercontent.com/mohankumargupta/raspberrypiVM/master/run.jpg)

4. Now fool raspian into thinking that our raspian image is on a SD card 

   ln -snf mmcblk0p2 /dev/root

5. Now type the following:

   raspi-config

   This is known as the raspi-config tool (see https://www.raspberrypi.org/documentation/configuration/raspi-config.md for more info)

   We need to make 3 changes:
   1. Expand Filesystem
   2. Enable Boot to Desktop/Scratch
   3. Change keyboard layout by choosing 3 Internationisation Options -> I3 Change Keyboard Layout 



6. Type the following one line at a time

     cat <<EOF > /etc/X11/xorg.conf
     Section "Screen"
     Identifier "Default Screen"
     DefaultDepth 16
     SubSection "Display"
     # Viewport 0 0
     Depth 16
     Modes "800x600"
     EndSubsection
     EndSection    
     EOF




