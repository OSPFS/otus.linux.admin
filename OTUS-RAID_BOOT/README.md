# Инструкция по переносу системного диска на RAID-1 в Centos 7

* Копируем таблицу разделов с системного диска на новый диск
```
sfdisk -d /dev/sda | sfdisk /dev/sdb
```
* Помечаем новый раздел для использования RAID
```
parted -s -m -a optimal /dev/sdb -- set 1 raid on
```
* Создаем RAID-1 без одного диска
```
yes | mdadm --create /dev/md0 --level=1 --raid-devices=2 missing /dev/sdb1
```
* Форматируем, монтируем и копируем все данные с системного диска 
```
mkfs.xfs /dev/md0
mount /dev/md0 /mnt
cp -dpRx / /mnt
```
* Мняем корень на RAID
```
mount --bind /proc /mnt/proc && mount --bind /dev /mnt/dev && mount --bind /sys /mnt/sys && mount --bind /run /mnt/run
chroot /mnt/
```
* Прописываем новый fstab
```
UD=$(blkid|grep md0|cut -d' ' -f2|sed 's/"//g')
head -8 /etc/fstab > /etc/fstab.new
echo "$UD   /   xfs   defaults   0 0" >>/etc/fstab.new
echo "/swapfile none swap defaults 0 0" >> /etc/fstab.new
mv -f /etc/fstab.new /etc/fstab
```
* Пропишем конфиг RAID'а
```
echo "DEVICE partitions" > /etc/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf
```
* Создаем новую ramfs
```
dracut -f /boot/initramfs-$(uname -r).img $(uname -r)
```
* Прописываем UUID RAID'а в /etc/default/grub
```
UUDR=$(mdadm -D /dev/md0|grep UUID|cut -d':' -f2,3,4,5|sed 's/ / rd.md.uuid=/')
GRB=$(cat /etc/default/grub |grep GRUB_CMDLINE_LINUX|sed 's/"$//')
sed -i '/GRUB_CMDLINE_LINUX/d' /etc/default/grub
echo "$GRB$UUDR\"" >> /etc/default/grub
```
* Делаем новый GRUB конфиг, устанавливаем загрузчик на новый диск 
```
grub2-mkconfig -o /boot/grub2/grub.cfg && grub2-install /dev/sdb
```
* Отключил SELINUX иначе после перезагрузки не пускает в систему (не стал углубляться)
```
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
```
* Перемонтируем обратно корень и перегружаемся
```
mount /dev/sda1 /mnt
mount --bind /proc /mnt/proc && mount --bind /dev /mnt/dev && mount --bind /sys /mnt/sys && mount --bind /run /mnt/run
chroot /mnt/
```
* Теперь при перезагрузке нужно в БИОСе указать, что грузимся со второго диска
* После перезагрузки:
```
parted -s -m -a optimal /dev/sda -- set 1 raid on  # Изменяем тип раздела для использования RAID
mdadm --manage /dev/md0 --add /dev/sda1  #  Добавляем старый диск в наш RAID
```
* Ждем пока RAID пересоберется и ставим новый загрузчик на старый диск
```
grub2-install /dev/sda
```
* Можем перегрузиться и всё заработает
