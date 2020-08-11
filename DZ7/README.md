## Стенд домашнего задания по теме "Управление процессами"

#### При старте ВМ копируются скрипты mlsof.sh & mpsax.sh в папку /usr/local/bin

* Скрипт mlsof.sh может запускаться, как с параметром (путь к директории или файлу)
так и без него (покажет все открытые файлы, кроме /dev решил уменьшить вывод) 
```
[root@DZ7 bin]# ./mlsof.sh /var/log

PID: 1301 Name:	auditd
Opened Files:
/var/log/audit/audit.log

PID: 2454 Name:	rsyslogd
Opened Files:
/var/log/cron
/var/log/messages
/var/log/secure
/var/log/maillog

PID: 2456 Name:	tuned
Opened Files:
/var/log/tuned/tuned.log
```
* Скрипт mpsax.sh просто показывает список запущенных процессов вида PID STATE COMMAND
```
[root@DZ7 bin]# ./mpsax.sh
PID	STATE	COMMAND
1	S	/usr/lib/systemd/systemd --switched-root --system --deserialize 21
2	S	kthreadd
3	S	ksoftirqd/0
5	S	kworker/0:0H
6	S	kworker/u4:0
7	S	migration/0
8	S	rcu_bh
9	S	rcu_sched
10	S	lru-add-drain
11	S	watchdog/0
12	S	watchdog/1
13	S	migration/1
14	S	ksoftirqd/1
16	S	kworker/1:0H
18	S	kdevtmpfs
19	S	netns
20	S	khungtaskd
21	S	writeback
22	S	kintegrityd
23	S	bioset
24	S	bioset
25	S	bioset
```

