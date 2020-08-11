#!/bin/bash

setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config
sed -i -e 's/console=ttyS0,115200n8 //g' -e 's/rhgb quiet/selinux=0/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

set -x
lsblk
sleep 5

vgs
vgrename VolGroup00 VGRoot
vgs
sleep 3

cat /etc/fstab
sed -i 's/VolGroup00/VGRoot/g' /etc/fstab
cat /etc/fstab

sed -i 's/VolGroup00/VGRoot/g' /etc/default/grub
sed -i 's/VolGroup00/VGRoot/g' /boot/grub2/grub.cfg
mkinitrd -f /boot/initramfs-$(uname -r).img $(uname -r)

lsblk
pvcreate --bootloaderareasize 1m /dev/sdb
vgcreate VG01 /dev/sdb
lvcreate -l 80%FREE -n LV-root VG01
mkfs.xfs /dev/VG01/LV-root -f

set +x
echo
echo "Rebooting server..."
echo
echo "If server stuck on reboot process, reset him!"
echo
echo "After reboot start /vagrant/02mk_bootable_lvm.sh script"
reboot
