#!/bin/sh

parted -s -m -a optimal /dev/sda -- set 1 raid on
mdadm --manage /dev/md0 --add /dev/sda1
grub2-install /dev/sda
echo "Now yucan reboot..."
