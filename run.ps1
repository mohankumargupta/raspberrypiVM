cd qemu
$imgfile = (Get-ChildItem *.img).name
$kernel = 'kernel-qemu'
.\qemu-system-armw.exe -kernel $kernel -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -hda $imgfile -net user -redir tcp:3333::22