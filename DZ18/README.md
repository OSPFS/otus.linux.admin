
#### Стенд домашнего задания №18 по теме "Архитектура сетей"
![Network](/drawio.jpg)

При запуске Vagrant файла, поднимаются 7 виртуальных машин со следующими сетевыми настройками:
```
:inetRouter => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.1', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "router-net"},
                ]
  },
  :centralRouter => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.2', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "router-net"},
                   {ip: '192.168.0.1', adapter: 3, netmask: "255.255.255.240", virtualbox__intnet: "dir-net"},
                   {ip: '192.168.0.33', adapter: 4, netmask: "255.255.255.240", virtualbox__intnet: "office-hw0"},
                   {ip: '192.168.0.65', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "wi-fi"},
                ]
  },
  :office1Router => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.0.3', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "dir-net"},
                   {ip: '192.168.2.1', adapter: 3, netmask: "255.255.255.192", virtualbox__intnet: "dev1"},
                   {ip: '192.168.2.65', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "test-srv1"},
                   {ip: '192.168.2.129', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "managers1"},
                   {ip: '192.168.2.193', adapter: 6, netmask: "255.255.255.192", virtualbox__intnet: "office-hw1"},

                ]
  },
  :office2Router => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.0.4', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "dir-net"},
                   {ip: '192.168.1.1', adapter: 3, netmask: "255.255.255.128", virtualbox__intnet: "dev2"},
                   {ip: '192.168.1.129', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "test-srv2"},
                   {ip: '192.168.1.193', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "office-hw2"},
                ]
  },
  :centralServer => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.0.2', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "dir-net"},
                ]
  },
  :office1Server => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.2.2', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "dev1"},
                ]
  },
  :office2Server => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.1.2', adapter: 2, netmask: "255.255.255.128", virtualbox__intnet: "dev2"},
                ]
  },
```
Таблица маршрутизации на inetRouter:
```
default via 10.0.2.2 dev eth0 proto dhcp metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100
192.168.0.0/28 via 192.168.255.2 dev eth1 proto static metric 101
192.168.0.32/28 via 192.168.255.2 dev eth1 proto static metric 101
192.168.0.64/26 via 192.168.255.2 dev eth1 proto static metric 101
192.168.1.0/24 via 192.168.255.2 dev eth1 proto static metric 101  - в сети Office2 свободных подсетей нет, поэтому маршрут с маской 24
192.168.2.0/24 via 192.168.255.2 dev eth1 proto static metric 101   - в сети Office1 свободных подсетей нет, поэтому маршрут с маской 24
192.168.255.0/30 dev eth1 proto kernel scope link src 192.168.255.1 metric 101
```
Таблица маршрутизации на centralRouter:
```
default via 192.168.255.1 dev eth1 proto static metric 102
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 101
192.168.0.0/28 dev eth2 proto kernel scope link src 192.168.0.1 metric 100
192.168.0.32/28 dev eth3 proto kernel scope link src 192.168.0.33 metric 103
192.168.0.64/26 dev eth4 proto kernel scope link src 192.168.0.65 metric 104
192.168.1.0/24 via 192.168.0.4 dev eth2 proto static metric 100  - в сети Office2 свободных подсетей нет, поэтому маршрут с маской 24
192.168.2.0/24 via 192.168.0.3 dev eth2 proto static metric 100   - в сети Office1 свободных подсетей нет, поэтому маршрут с маской 24
192.168.255.0/30 dev eth1 proto kernel scope link src 192.168.255.2 metric 102
```
На маршрутизаторах office1Router & office2Route роутером по умолчанию является centralRouter, остальные маршруты прописывать нет необходимости т.к. о них знает centralRouter

##### Сеть central:
- 192.168.0.0/28 - 14 хостов, broadcast 192.168.0.15
- 192.168.0.16/28 - свободная подсеть, 14 хостов, broadcast 192.168.0.31
- 192.168.0.32/28 - 14 хостов, broadcast 192.168.0.47
- 192.168.0.64/26 - 62 хоста, broadcast 192.168.0.127
- 192.168.0.128/25 - свободная подсеть, 126 хостов, broadcast 192.168.0.255
  
##### Сеть office1 (свобдных подсетей нет)
- 192.168.2.0/26 - 62 хоста, broadcast 192.168.0.63
- 192.168.2.64/26 - 62 хоста, broadcast 192.168.0.127
- 192.168.2.128/26 - 62 хоста, broadcast 192.168.0.191
- 192.168.2.192/26 - 62 хоста, broadcast 192.168.0.255

##### Сеть office2 (свобдных подсетей нет)
- 192.168.1.0/25 - 126 хостов, broadcast 192.168.0.127
- 192.168.1.128/26 - 62 хоста, broadcast 192.168.0.191
- 192.168.1.192/26 - 62 хоста, broadcast 192.168.0.255
