## Стенд домашнего задания по теме "Bash, awk, sed, grep и другие"

###### При инициализации Vagrant файла запускается скрипт, который полносью настраивает машину

* При старте ВМ копируется основной и тестовый скрипт в папку /opt/LogCHK
* Создается симлинк но основной скрипт в папке /etc/cron.hourly
* Запускается тестовый скрипт имитирующий постепенное наполнение файла access.log
* Результаты теста можно проверить в локальной почте root'a комманда mail -u root (без -u root не работает :)