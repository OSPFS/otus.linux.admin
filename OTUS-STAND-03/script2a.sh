#!/bin/bash

set -x
mount /dev/VGM/LV-var /var
sed -i -e 's/LogVol00/LV-root/g' -e 's/LogVol01/LV-swap rd.lvm.lv=VolGroup00\/LV-home rd.lvm.lv=VGM\/LV-var/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
cd /boot ; for i in `ls initramfs-*img`; do dracut $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done

set +x
echo ""
echo " Now you can reboot the server....."
echo ""

exit && reboot
