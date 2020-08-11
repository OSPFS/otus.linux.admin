#!/bin/bash

set -x
lsblk
sed -i -e 's/VGRoot\/LogVol00/VG01\/LV-root/g' -e 's/VGRoot\/LogVol01/VG01\/LV-swap/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
dracut -f
lsblk
MYDEV=$(pvs|grep VG01|cut -d' ' -f3)
grub2-install $MYDEV
head -8 /etc/fstab > /etc/fstab.new
echo "/dev/VG01/LV-root /   xfs     defaults        0 0" >> /etc/fstab.new
echo "/dev/VG01/LV-swap swap                    swap    defaults        0 0" >> /etc/fstab.new
mv /etc/fstab.new /etc/fstab -f
set +x
echo
echo 
echo "***************************************"
echo "*"
echo "* Please Reboot server from SECOND disk"
echo "*"
echo "***************************************"

exit
