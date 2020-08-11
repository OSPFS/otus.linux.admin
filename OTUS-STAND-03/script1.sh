#!/bin/bash

setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config

set -x
yum install -y xfsdump
sed -i -e 's/console=ttyS0,115200n8 //g' -e 's/rhgb quiet/selinux=0/g' /etc/default/grub

lsblk
parted -s /dev/sdb mkla msdos mkpart prim 2048s 100%
sleep 3
mkfs.xfs /dev/sdb1
mount /dev/sdb1 /mnt
xfsdump -J - /|xfsrestore -J - /mnt
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt /vagrant/script1a.sh && reboot
