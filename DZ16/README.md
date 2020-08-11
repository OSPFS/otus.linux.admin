#### Стенд домашнего задания №16 по теме "Резервное копирование"

* При запуске Vagrant файла, поднимаются 2 виртуальные машины _server_ и _client_

На обе машины ставится пакет borgbackup, далее клиент инициализирует хранилище на сервере

```
borg init -e=none borg@192.168.11.150:/home/borg/client
```
Затем по крону,
```
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin

*/10 * * * * root /root/bb.sh
```
каждые 10 минут выпоняется скрипт бэкапа, который сохраняет 
6 - копий за последний час
24 - копии за день
7 - копий за каждый день в неделю
4 - недельные копии
6 - ежемесячных копий
```
#!/bin/sh

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO=borg@192.168.11.150:/home/borg/client

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression lz4               \
    --exclude-caches                \
    --exclude '/home/*/.cache/*'    \
                                    \
    ::'{hostname}-{now}'            \
    /etc                            \
    /home                           \
    /root                           \

backup_exit=$?

info "Pruning repository"

borg prune                          \
    --list                          \
    --prefix '{hostname}-'          \
    --show-rc                       \
    --keep-minutely 6               \
    --keep-hourly   24               \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup and Prune finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup and/or Prune finished with warnings"
else
    info "Backup and/or Prune finished with errors"
fi

exit ${global_exit}

```
В ите получаем:

```
client-2020-01-18T00:50:01           Sat, 2020-01-18 00:50:01 [80af2a6c4c9011cb5f21a9a5003a7f114b7285de9b9cff6db83aa1dfe832967e]
client-2020-01-18T01:50:01           Sat, 2020-01-18 01:50:02 [d3154f8365c7b609d7ae1f197eda1a5f2dc6c8d88434961eefee981ccd4d1088]
client-2020-01-18T02:50:01           Sat, 2020-01-18 02:50:02 [b2f421210d77fe8dde21565cb47188f94dcb4e06e0362f0666656116b503662c]
client-2020-01-18T03:50:02           Sat, 2020-01-18 03:50:02 [59ab8e916f2505e2ae6d1c3999b0296c4c52e4fc35ad4c4828fc3382e578e97f]
client-2020-01-18T04:50:01           Sat, 2020-01-18 04:50:02 [94e5d979a350599d7a612f550eebbf68db3deac75172d76a78b51ad91c08b4c2]

client-2020-01-18T05:20:01           Sat, 2020-01-18 05:20:02 [91a1d06b779d82af0c6cf6b197cab7945eaf1c8c2694a1be79eadf2563f6c444]
client-2020-01-18T05:30:01           Sat, 2020-01-18 05:30:02 [ac5f6254893aa20cc82330e0aec3ce9f9e96153cf0152fa7ac6de9bbe8e8a48b]
client-2020-01-18T05:40:01           Sat, 2020-01-18 05:40:02 [59454358cfaba5ad1f87395d034c38488eb16038ffaedb6c057dc452ec1ac65d]
client-2020-01-18T05:50:01           Sat, 2020-01-18 05:50:02 [1aa83daa154179ffdb484814395f9f8195f56ea25531e5ddf4b322165329e96a]
client-2020-01-18T06:00:02           Sat, 2020-01-18 06:00:03 [76c8d233b749a31c5edc58c867690c516d74c4a49861d506c27a66f9ea6dec3e]
client-2020-01-18T06:10:02           Sat, 2020-01-18 06:10:03 [5fd5536cddd10aa1719ac21ebc18de8f426ea4e15cd3dbf75f42aef3a7bf79fb]
```