
#### Стенд домашнего задания №23 по теме "Мосты, туннели и VPN"


При запуске Vagrant файла, поднимаются 3 виртуальные машины. Server1 принимает сединения от Server2 и client1. 
В на сденде был поднят VPN между Server1 & Server 2 в TUN/TAP режимах, которые показали следующие скорости:
* TUN:
```
[root@server1 vagrant]# iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.10.2, port 46830
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 46832
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-1.00   sec  15.0 MBytes   126 Mbits/sec
[  5]   1.00-2.00   sec  10.6 MBytes  89.3 Mbits/sec
[  5]   2.00-3.00   sec  9.97 MBytes  83.5 Mbits/sec
[  5]   3.00-4.00   sec  11.6 MBytes  97.2 Mbits/sec
[  5]   4.00-5.00   sec  15.4 MBytes   129 Mbits/sec
[  5]   5.00-6.00   sec  13.6 MBytes   114 Mbits/sec
[  5]   6.00-7.00   sec  15.0 MBytes   126 Mbits/sec
[  5]   7.00-8.00   sec  14.8 MBytes   124 Mbits/sec
[  5]   8.00-9.00   sec  16.0 MBytes   134 Mbits/sec
[  5]   9.00-10.00  sec  14.9 MBytes   125 Mbits/sec
[  5]  10.00-10.05  sec   676 KBytes   104 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-10.05  sec  0.00 Bytes  0.00 bits/sec                  sender
[  5]   0.00-10.05  sec   137 MBytes   115 Mbits/sec                receiver
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```
* TAP:
```
[root@server1 openvpn]# iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.10.2, port 46834
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 46836
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-1.00   sec  16.7 MBytes   140 Mbits/sec
[  5]   1.00-2.00   sec  17.2 MBytes   144 Mbits/sec
[  5]   2.00-3.00   sec  17.0 MBytes   143 Mbits/sec
[  5]   3.00-4.00   sec  17.8 MBytes   150 Mbits/sec
[  5]   4.00-5.00   sec  18.0 MBytes   151 Mbits/sec
[  5]   5.00-6.00   sec  19.6 MBytes   165 Mbits/sec
[  5]   6.00-7.00   sec  18.3 MBytes   154 Mbits/sec
[  5]   7.00-8.00   sec  19.4 MBytes   163 Mbits/sec
[  5]   8.00-9.00   sec  19.4 MBytes   163 Mbits/sec
[  5]   9.00-10.00  sec  20.0 MBytes   168 Mbits/sec
[  5]  10.00-10.05  sec   686 KBytes   125 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-10.05  sec  0.00 Bytes  0.00 bits/sec                  sender
[  5]   0.00-10.05  sec   184 MBytes   154 Mbits/sec                receiver
-----------------------------------------------------------
```

Так же на Server1 OpenVPN поднимается в режиме RAS и к нему подключается client1, командой:
```
openvpn --config /etc/openvpn/client.conf
```