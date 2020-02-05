# **************************************************************************** #
#                                                           LE - /             #
#                                                               /              #
#    Dockerfile                                       .::    .:/ .      .::    #
#                                                  +:+:+   +:    +:  +:+:+     #
#    By: frfrey <frfrey@student.le-101.fr>          +:+   +:    +:    +:+      #
#                                                  #+#   #+    #+    #+#       #
#    Created: 2020/02/05 13:23:10 by frfrey       #+#   ##    ##    #+#        #
#    Updated: 2020/02/05 14:42:52 by frfrey      ###    #+. /#+    ###.fr      #
#                                                          /                   #
#                                                         /                    #
# **************************************************************************** #

FROM wordpress:php7.4-fpm-alpine

ENV 	TELEGRAF_VERSION 1.12.6

LABEL 	maintainer="Francois Frey <frfrey@student.le-101.fr>"

RUN apk update && \
	apk add nginx mysql-client

COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY start /start

COPY srcs/telegraf.tar.gz .
COPY srcs/telegraf.conf /etc/telegraf/
RUN tar -C . -xzf telegraf.tar.gz; \
	chmod +x telegraf/*; \
	cp telegraf/telegraf /usr/bin/; \
	rm -rf *.tar.gz* telegraf/

RUN  touch /var/log/nginx/access.log;

ENTRYPOINT sh /start

CMD ["tail", "-F", "/var/log/nginx/access.log"]
