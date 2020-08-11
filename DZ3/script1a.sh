#!/bin/bash

set -x
grub2-mkconfig -o /boot/grub2/grub.cfg
cd /boot ; for i in `ls initramfs-*img`; do dracut $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done
#grub2-install /dev/sdb

sed -i 's/mapper\/VolGroup00-LogVol00/sdb1/g' /etc/fstab

set +x
echo ""
echo " Reboot server and run script /vagrant/script2.sh ..."
echo ""

exit && reboot