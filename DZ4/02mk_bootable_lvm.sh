#!/bin/bash

set -x
echo "Add dracut module..."
mkdir /usr/lib/dracut/modules.d/01test
cp /vagrant/module-setup.sh /vagrant/test.sh /usr/lib/dracut/modules.d/01test
dracut -f -v
lsinitrd -m /boot/initramfs-$(uname -r).img
lsinitrd -m /boot/initramfs-$(uname -r).img | grep test
echo "Make bootable LVM"
lsblk
mount /dev/VG01/LV-root /mnt
lvcreate -L 1G -n LV-swap VG01
mkswap /dev/VG01/LV-swap
lsblk
sleep 2
cp /vagrant/arum.repo /etc/yum.repos.d/
cat /etc/yum.repos.d/arum.repo
sleep 3
yum --enablerepo=arum install grub2.x86_64 -y
yum list installed grub2
xfsdump -J - /|xfsrestore -J - /mnt
ls -la /mnt/boot
cp -dpRx /boot/* /mnt/boot/
umount /boot
mount --bind /proc /mnt/proc && mount --bind /dev /mnt/dev && mount --bind /sys /mnt/sys && mount --bind /run /mnt/run
chroot /mnt /vagrant/mk_bootable_lvm2.sh 
