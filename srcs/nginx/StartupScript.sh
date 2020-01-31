# **************************************************************************** #
#                                                           LE - /             #
#                                                               /              #
#    StartupScript.sh                                 .::    .:/ .      .::    #
#                                                  +:+:+   +:    +:  +:+:+     #
#    By: frfrey <frfrey@student.le-101.fr>          +:+   +:    +:    +:+      #
#                                                  #+#   #+    #+    #+#       #
#    Created: 2020/01/31 15:35:35 by frfrey       #+#   ##    ##    #+#        #
#    Updated: 2020/01/31 15:52:17 by frfrey      ###    #+. /#+    ###.fr      #
#                                                          /                   #
#                                                         /                    #
# **************************************************************************** #

#!/bin/sh

#Start all service on my docker
/usr/sbin/php-fpm7
/usr/sbin/sshd
/usr/sbin/nginx

while [ true ]
do true = true
done
