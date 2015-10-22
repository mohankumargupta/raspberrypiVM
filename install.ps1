#inspired by http://www.pcsteps.com/1199-raspberry-pi-emulation-for-windows-qemu/

Write-Output '......................................................................'
Write-Output 'About to begin descent.'
Write-Output '......................................................................'

#remove qemu directory if it exists
Write-Output 'STEP1: Removing previously created qemu directory.'
if (Test-Path qemu -pathType container) { Remove-Item -Force -Recurse qemu }
$sleepDuration = 5
Start-Sleep $sleepDuration

#download latest raspian image
Write-Output 'STEP2: Downloading raspian image (about 1.2G) '
$imageUrl = 'http://downloads.raspberrypi.org/raspbian/images/raspbian-2014-12-25/2014-12-24-wheezy-raspbian.zip'
#$imageUrl = 'http://downloads.raspberrypi.org/raspbian_latest' 
$wgetCommand = ".\wget.exe -c $imageUrl  "
Invoke-Expression -Command $wgetCommand

#check if using 32-bit or 64-bit OS
#$is64bitOS = [environment]::Is64BitOperatingSystem
#$qemuExe = if ($is64bitOS) {'qemu-w64-setup-20150925.exe'} else {'qemu-w32-setup-20150925.exe'}
$qemuExe = 'qemu-w32-setup-20150925.exe'

#unzip qemu
Write-Output 'STEP3:unzip qemu into qemu directory'
$unzipCommand = ".\7z.exe e $qemuexe *.* -oqemu"
Invoke-Expression -Command $unzipCommand

#unzip raspian zip
Write-Output 'STEP4:unzip raspian into qemu directory'
$rpifilename = (Get-ChildItem *.zip).name
$unzipCommand = '.\7z.exe e ' + $rpifilename + ' *.* -oqemu'
Invoke-Expression -Command $unzipCommand

#copy kernel-qemu to qemu directory
Write-Output 'STEP5:copy kernel to qemu directory'
$kernel = 'kernel-qemu'
#$kernel = 'kernel-qemu-jessie'
Copy-Item $kernel -Destination qemu  

#resize qemu image
Write-Output 'STEP6:Resize qemu image'
$newfilesize = Get-Content "RESIZED-FILESIZE.txt"|Out-String
cd qemu
$imgfile = (Get-ChildItem *.img).name
.\qemu-img.exe resize $imgfile +$newfilesize


#run qemu
Write-Output "STEP7:Running QEMU Virtualisation program with an image named:$imgfile"  
.\qemu-system-armw.exe -kernel $kernel -cpu arm1176 -m 192 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" -hda $imgfile
Write-Output ".\qemu-system-armw.exe -kernel $kernel -cpu arm1176 -m 192 -M versatilepb -no-reboot -serial stdio -append `"root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash`" -hda $imgfile"