#!/bin/sh

sfdisk -d /dev/sda | sfdisk /dev/sdb
parted -s -m -a optimal /dev/sdb -- set 1 raid on
yes | mdadm --create /dev/md0 --level=1 --raid-devices=2 missing /dev/sdb1
mkfs.xfs /dev/md0
mount /dev/md0 /mnt
cp -dpRx / /mnt
mount --bind /proc /mnt/proc && mount --bind /dev /mnt/dev && mount --bind /sys /mnt/sys && mount --bind /run /mnt/run && chroot /mnt/
UD=$(blkid|grep md0|cut -d' ' -f2|sed 's/"//g')
head -8 /etc/fstab > /etc/fstab.new
echo "$UD   /   xfs   defaults   0 0" >>/etc/fstab.new
echo "/swapfile none swap defaults 0 0" >> /etc/fstab.new
mv -f /etc/fstab.new /etc/fstab
echo "DEVICE partitions" > /etc/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf
dracut -f /boot/initramfs-$(uname -r).img $(uname -r)
UUDR=$(mdadm -D /dev/md0|grep UUID|cut -d':' -f2,3,4,5|sed 's/ / rd.md.uuid=/')
GRB=$(cat /etc/default/grub |grep GRUB_CMDLINE_LINUX|sed 's/"$//')
sed -i '/GRUB_CMDLINE_LINUX/d' /etc/default/grub
echo "$GRB$UUDR\"" >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg && grub2-install /dev/sdb
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
mount /dev/sda1 /mnt
mount --bind /proc /mnt/proc && mount --bind /dev /mnt/dev && mount --bind /sys /mnt/sys && mount --bind /run /mnt/run
chroot /mnt/
echo " "
echo " Reboot Server and boot from second disk "
