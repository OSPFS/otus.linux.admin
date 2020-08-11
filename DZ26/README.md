#### Стенд домашнего задания по теме "DNS/DHCP настройка и обслуживание"

* При запуске Vagrant файла, поднимаются 4 виртуальные машины _NS01_ _NS02_ и клиенты _client1_ _client2_

Описание стенда:
DNS Север NS01 является мастером, NS02 slave'ом, сервера обслуживают DNS зоны:
- dns.lab
- newdns.lab
- 50.168.192.in-addr.arpa

в зоне dns.lab 
web1 - смотрит на client1
web2 смотрит на client2

в зоне newdns.lab
запись www - смотрит на обоих клиентов

client1 - видит обе зоны, но в зоне dns.lab только запись web1
client2 - видит только dns.lab

Для удобства тестирования в /usr/local/bin лежит скрипт nstest.sh
```
#!/bin/bash
set -x

dig -x 192.168.50.11 +short
dig web1.dns.lab +short
dig web2.dns.lab +short
dig www.newdns.lab +short

dig -x 192.168.50.11 +short @192.168.50.11
dig web1.dns.lab +short @192.168.50.11
dig web2.dns.lab +short @192.168.50.11
dig www.newdns.lab +short @192.168.50.11
```
