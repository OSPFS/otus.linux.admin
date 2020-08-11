#!/bin/bash

# Install stuff
yum update -y
yum group install "Development Tools" -y
yum install ncurses-devel bison flex elfutils-libelf-devel openssl-devel bc -y
# Install new kernel
cd /usr/src/kernels/
curl https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.8.tar.xz -o linux-5.3.8.tar.xz
tar xf linux-5.3.8.tar.xz
cd linux-5.3.8
cp -v /boot/config-$(uname -r) .config

dt1=$(date)
make olddefconfig
date > dt && make -j 10 && date >> dt
make modules_install
make install

dt2=$(date)
echo
echo "Kernel Done! $dt1 - $dt2"

# Update GRUB
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0

echo "Grub update done. Rebooting..."
# Reboot VM
shutdown -r now
