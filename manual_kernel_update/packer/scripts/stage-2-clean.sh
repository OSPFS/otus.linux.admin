#!/bin/bash

echo "Clean all"
yum clean all

echo "Install vagrant default key"
mkdir -pm 700 /home/vagrant/.ssh
curl -L https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub >> /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "Install VirtualBox additions"
curl https://download.virtualbox.org/virtualbox/6.0.14/VBoxGuestAdditions_6.0.14.iso -o /tmp/VBoxGuestAdditions_6.0.14.iso
mount /tmp/VBoxGuestAdditions_6.0.14.iso /mnt -o loop
/mnt/VBoxLinuxAdditions.run
umount /mnt

echo "Remove temporary files"
rm -rf /tmp/*
rm  -f /var/log/wtmp /var/log/btmp
rm -rf /var/cache/* /usr/share/doc/*
rm -rf /var/cache/yum
rm -rf /usr/src/kernels/linux-5.3.8
rm -rf /vagrant/home/*.iso
rm  -f ~/.bash_history
history -c

rm -rf /run/log/journal/*

echo "Fill zeros all empty space"
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync

#grub2-set-default 1
#echo "###   Hi from secone stage" >> /boot/grub2/grub.cfg
