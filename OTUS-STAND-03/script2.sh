#!/bin/bash

set -x
lsblk

yes|lvresize -L 8G VolGroup00/LogVol00
mkfs.xfs /dev/VolGroup00/LogVol00 -f

lvrename VolGroup00 LogVol00 LV-root
lvrename VolGroup00 LogVol01 LV-swap

pvcreate /dev/sdc /dev/sdd
vgcreate VGM /dev/sdc /dev/sdd
lvcreate -L 950M -m1 -n LV-var VGM
mkfs.xfs /dev/VGM/LV-var

lvcreate -L 5.5G -n LV-home /dev/VolGroup00
mkfs.xfs /dev/VolGroup00/LV-home

lsblk

mount /dev/VGM/LV-var /mnt
cp -aR /var/* /mnt
umount /mnt

mount /dev/VolGroup00/LV-home /mnt
cp -aR /home/* /mnt
umount /mnt

mount /dev/VolGroup00/LV-root /mnt
xfsdump -J - /|xfsrestore -J - /mnt
rm -rf /mnt/home/*
rm -rf /mnt/var/*

head -8 /etc/fstab > /mnt/etc/fstab
echo "/dev/mapper/VolGroup00-LV--root / xfs defaults 0 0" >>/mnt/etc/fstab
echo "/dev/mapper/VolGroup00-LV--home /home xfs defaults 0 0" >>/mnt/etc/fstab
echo "/dev/mapper/VGM-LV--var /var xfs defaults 0 0" >>/mnt/etc/fstab
echo "/dev/mapper/VolGroup00-LV--swap swap swap defaults 0 0" >>/mnt/etc/fstab

for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt /vagrant/script2a.sh

