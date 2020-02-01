# **************************************************************************** #
#                                                           LE - /             #
#                                                               /              #
#    Dockerfile                                       .::    .:/ .      .::    #
#                                                  +:+:+   +:    +:  +:+:+     #
#    By: frfrey <frfrey@student.le-101.fr>          +:+   +:    +:    +:+      #
#                                                  #+#   #+    #+    #+#       #
#    Created: 2020/02/01 12:22:34 by frfrey       #+#   ##    ##    #+#        #
#    Updated: 2020/02/01 13:35:17 by frfrey      ###    #+. /#+    ###.fr      #
#                                                          /                   #
#                                                         /                    #
# **************************************************************************** #

FROM 	nginx:1.17.6-alpine

ENV 	TELEGRAF_VERSION 1.12.6
ENV		NGINX_VERSION 1.17.6

LABEL 	maintainer="Francois Frey <frfrey@student.le-101.fr>"

RUN 	apk add --no-cache openrc nginx openssh-server; \
		rc-update add sshd; \
		echo "root:password" | chpasswd; \
		apk add wget;

COPY 	srcs/nginx.conf /etc/nginx
RUN 	chown -R nginx:nginx /usr/share/nginx;
COPY 	srcs/index.html /usr/share/nginx/html
RUN 	mkdir /etc/nginx/ssl;
COPY 	keys/nginx.crt /etc/nginx/ssl
COPY 	keys/nginx.key /etc/nginx/ssl
RUN 	chmod 600 /etc/nginx/ssl/nginx.key; \
		chmod 644 /etc/nginx/ssl/nginx.crt

COPY 	srcs/sshd_config /etc/ssh/
COPY 	keys/ssh_host_dsa_key /etc/ssh/
COPY 	keys/ssh_host_dsa_key.pub /etc/ssh/
COPY 	keys/ssh_host_rsa_key /etc/ssh/
COPY 	keys/ssh_host_rsa_key.pub /etc/ssh/

RUN 	chmod 600 /etc/ssh/ssh_host_dsa_key; \
		chmod 644 /etc/ssh/ssh_host_dsa_key.pub; \
		chmod 600 /etc/ssh/ssh_host_rsa_key; \
		chmod 644 /etc/ssh/ssh_host_rsa_key.pub

COPY 	srcs/telegraf.tar.gz .
COPY 	srcs/telegraf.conf /etc/telegraf/

RUN 	tar -C . -xzf telegraf.tar.gz; \
		chmod +x telegraf/*; \
		cp telegraf/telegraf /usr/bin/; \
		rm -rf *.tar.gz* telegraf/

COPY 	nginx.sh /usr/local/bin

EXPOSE 80 443 32022

ENTRYPOINT ["nginx.sh"]

CMD ["tail", "-F", "/var/log/nginx/access.log"]
