#### Стенд домашнего задания №10 по теме "Автоматизация администрирования. Ansible."

* При запуске Vagrant файла, поднимаются 2 машины _ansible_ и _web_

Файлы настроек ansible лежат в */etc/ansible*, роль Nginx в */etc/ansible/roles/httpd*. Для инсталяции роли Nginx небходимо на машине _ansible_ из под пользователя vagrant дать команду:
```
ansible-playbook /etc/ansible/nginx.yml
```

Для проверки можно запустить бараузер (уже установлен) на машине _ansible_:
```
lynx web:8080
```
