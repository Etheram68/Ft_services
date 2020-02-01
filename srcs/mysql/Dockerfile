# **************************************************************************** #
#                                                           LE - /             #
#                                                               /              #
#    Dockerfile                                       .::    .:/ .      .::    #
#                                                  +:+:+   +:    +:  +:+:+     #
#    By: frfrey <frfrey@student.le-101.fr>          +:+   +:    +:    +:+      #
#                                                  #+#   #+    #+    #+#       #
#    Created: 2020/02/01 17:03:58 by frfrey       #+#   ##    ##    #+#        #
#    Updated: 2020/02/01 17:51:50 by frfrey      ###    #+. /#+    ###.fr      #
#                                                          /                   #
#                                                         /                    #
# **************************************************************************** #

FROM 	alpine

LABEL 	maintainer="Francois Frey <frfrey@student.le-101.fr>"

RUN 	apk add --update mysql mysql-client \
		&& rm -f /var/cache/apk/*

COPY 	srcs/mysql.cnf /etc/mysql/my.cnf
COPY 	start /start

RUN 	mkdir /app

EXPOSE 	3306

CMD sh /start
