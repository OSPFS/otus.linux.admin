# Создание виртуальной машины с RAID-5

* Создаем RAID-5
```
mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g}  # Инициализация
mdadm --create --verbose /dev/md0 -l 5 -n 5 /dev/sd{b,c,d,e,f}  # Создание RAID-5
mdadm --add /dev/md0 /dev/sdg # Добавим еще один диск Hot spare для резерва
```
* Прописываем конфиг-файл RAID'а
```
echo "DEVICE partitions" > /etc/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf
```
* Создаем разделы
```
parted -s /dev/md0 mklabel gpt
parted /dev/md0 mkpart primary xfs 0% 20%
parted /dev/md0 mkpart primary xfs 20% 40%
parted /dev/md0 mkpart primary xfs 40% 60%
parted /dev/md0 mkpart primary xfs 60% 80%
parted /dev/md0 mkpart primary xfs 80% 100%
partprobe /dev/md0
```
* Форматируем разделы
```
for i in $(seq 1 5); do sudo mkfs.xfs /dev/md0p$i; done
```
* Создаем точки монтирования для новых разделов и монтируем их
```
mkdir -p /raid/part{1,2,3,4,5}        
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done
```
* Дописываем точки монтирования в файл /etc/fstab
```
echo "/dev/md0p1     /raid/part1        xfs     defaults        0 0" >> /etc/fstab
echo "/dev/md0p2     /raid/part2        xfs     defaults        0 0" >> /etc/fstab
echo "/dev/md0p3     /raid/part3        xfs     defaults        0 0" >> /etc/fstab
echo "/dev/md0p4     /raid/part4        xfs     defaults        0 0" >> /etc/fstab
echo "/dev/md0p5     /raid/part5        xfs     defaults        0 0" >> /etc/fstab
```
