# **************************************************************************** #
#                                                           LE - /             #
#                                                               /              #
#    Dockerfile                                       .::    .:/ .      .::    #
#                                                  +:+:+   +:    +:  +:+:+     #
#    By: frfrey <frfrey@student.le-101.fr>          +:+   +:    +:    +:+      #
#                                                  #+#   #+    #+    #+#       #
#    Created: 2020/02/05 14:45:44 by frfrey       #+#   ##    ##    #+#        #
#    Updated: 2020/02/05 14:47:36 by frfrey      ###    #+. /#+    ###.fr      #
#                                                          /                   #
#                                                         /                    #
# **************************************************************************** #

FROM alpine:3.10.3

ENV 	TELEGRAF_VERSION 1.12.6

LABEL 	maintainer="Francois Frey <frfrey@student.le-101.fr>"

RUN apk --update --no-cache add vsftpd openssl && \
	rm -rf /tmp/* /var/cache/apk/*

COPY srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY start.sh /usr/local/bin
COPY srcs/telegraf.tar.gz .
COPY srcs/telegraf.conf /etc/telegraf/

RUN tar -C . -xzf telegraf.tar.gz; \
	chmod +x telegraf/*; \
	cp telegraf/telegraf /usr/bin/; \
	rm -rf *.tar.gz* telegraf/

EXPOSE 20 21 32099 32100

ENTRYPOINT ["start.sh"]

CMD ["tail", "-F", "/var/log/vsftpd.log"]
