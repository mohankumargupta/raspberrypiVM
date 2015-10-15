#taken from http://www.pcsteps.com/1199-raspberry-pi-emulation-for-windows-qemu/

#remove qemu directory if it exists
if (Test-Path qemu -pathType container) { Remove-Item -Force -Recurse qemu }
Start-Sleep 5

#download latest raspian image
#$wgetUrl = (Get-Location).Path +  '\wget -c http://downloads.raspberrypi.org/raspbian_latest'
$wgetUrl = 'http://downloads.raspberrypi.org/raspbian/images/raspbian-2014-12-25/2014-12-24-wheezy-raspbian.zip'
Invoke-Expression -Command $wgetUrl

#unzip qemu
#$unzipCommand = '.\7z.exe e qemu-w32-setup-20150925.exe *.* -oqemu' 
#Invoke-Expression -Command $unzipCommand
.\7z.exe e qemu-w32-setup-20150925.exe *.* -oqemu

#unzip raspian zip
$rpifilename = (Get-ChildItem *.zip).name
#$unzipCommand = '.\7z.exe e ' + $rpifilename + ' *.* -oqemu'
#Invoke-Expression -Command $unzipCommand
.\7z.exe e $rpifilename *.* -oqemu

#copy kernel-qemu to qemu directory
Copy-Item kernel-qemu -Destination qemu  

#cd qemu and run command
cd qemu
$imgfile = (Get-ChildItem *.img).name
#.\qemu-img.exe resize $imgfile +2G


#run qemu
Write-Output $imgfile
#.\qemu-system-armw.exe -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" -hda $imgfile


