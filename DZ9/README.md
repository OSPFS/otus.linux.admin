## Стенд домашнего задания по теме "Docker"


* Собран образ [ospfs/my-ng](https://hub.docker.com/r/ospfs/my-ng) Dockerfile:

```
FROM alpine:latest
RUN apk add nginx && mkdir /run/nginx
RUN rm -f /etc/nginx/conf.d/*
RUN rm -f /var/lib/nginx/html/index.html
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/lib/nginx/html/index.html
EXPOSE 80
CMD [ "nginx","-g","daemon off;" ]
```
* На вопрос можно ли собрать ядро в контейненере, отвечу так: собрать можно, но установить нельзя
