# **************************************************************************** #
#                                                           LE - /             #
#                                                               /              #
#    start_service.sh                                 .::    .:/ .      .::    #
#                                                  +:+:+   +:    +:  +:+:+     #
#    By: frfrey <frfrey@student.le-101.fr>          +:+   +:    +:    +:+      #
#                                                  #+#   #+    #+    #+#       #
#    Created: 2020/01/30 15:45:38 by frfrey       #+#   ##    ##    #+#        #
#    Updated: 2020/02/01 17:38:53 by frfrey      ###    #+. /#+    ###.fr      #
#                                                          /                   #
#                                                         /                    #
# **************************************************************************** #

#!/bin/sh

# Ensure minikube is launched
if ! minikube status >/dev/null 2>&1
then
    echo Minikube is not started! Starting now...
    if ! minikube start --vm-driver=virtualbox \
        --cpus 3 --disk-size=30000mb --memory=3000mb \
		--extra-config=apiserver.service-node-port-range=1-32767
    then
        echo Cannot start minikube!
        exit 1
    fi
    minikube addons enable metrics-server
    minikube addons enable ingress
fi

# docker can run in minikube's vm
eval $(minikube docker-env);
####################################    BUILD   ########################################
printf "Build NGINX Image\n"
docker build -t nginx_kube srcs/nginx

printf "Build MYSQL Image\n"
docker build -t mysql_kube srcs/mysql


#################################### DEPLOYMENT ########################################
printf "Deploy All\n"
kubectl apply -k srcs
#printf "Deploy InfluxDB\n"
#helm install -f srcs/influxdb.yaml influxdb stable/influxdb
#wait influxdb
#printf "Deploy Grafana\n"
#helm install -f srcs/grafana.yaml grafana stable/grafana
#wait grafana
#printf "Deploy MySQL\n"
#kubectl apply -f srcs/mysql.yaml
#wait mysql
#printf "Deploy Wordpress\n"
#kubectl apply -f srcs/wordpress.yaml
#wait wordpress
#printf "Deploy PhpMyAdmin\n"
#kubectl apply -f srcs/phpmyadmin.yaml
#wait phpmyadmin
#printf "Build NGINX Image\n"
#docker build -t nginx_ssh srcs/nginx
#printf "Deploy NGINX\n"
#kubectl create secret generic ssl-keys --from-file=srcs/nginx/keys/nginx.crt --from-file=srcs/nginx/keys/nginx.key
# kubectl create secret generic ssh-keys --from-file=srcs/nginx/keys/ssh_host_dsa_key --from-file=srcs/nginx/keys/ssh_host_dsa_key.pub  --from-file=srcs/nginx/keys/ssh_host_rsa_key --from-file=srcs/nginx/keys/ssh_host_rsa_key.pub --from-file=srcs/nginx/keys/sshd_config
# kubectl create configmap nginx-config-map --from-file=srcs/nginx/nginx.conf
#kubectl apply -f srcs/nginx.yaml
# grep -vwE "192.168.99" ~/.ssh/known_hosts > ~/.ssh/temp && mv ~/.ssh/temp ~/.ssh/known_hosts
#wait nginx
#printf "Deploy Ingress\n"
#minikube addons enable ingress
#kubectl apply -f srcs/ingress.yaml
#printf "Waiting for Ingress...\n"
#sleep 10s
#printf "Deploy Ingress Controller\n"
#helm install -f srcs/nginx-ingress.yaml nginx-ingress stable/nginx-ingress
#printf "\nWaiting for Ingress Controller...\n"
#sleep 20s
export KUB_IP=$(minikube ip)
echo "\n\nMinikube ip : $KUB_IP\n"
#read -n 1 -s -r -p "Check at the end of srcs/ftps/vsftpd.conf if asv=address is the same, and replace it if necessary. Then, press enter."
#printf "\nBuild FTPS Image\n"
#docker build -t ftps_server srcs/ftps
#printf "Deploy FTPS Server\n"
#kubectl apply -f srcs/ftps.yaml
#wait ftps
#export KUB_IP=$(minikube ip)
#export WP_POD=$(kubectl get pods | grep wordpress | cut -d" " -f1)
#echo "curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"| (kubectl exec $WP_POD -it /bin/sh)
#echo "chmod +x wp-cli.phar" | (kubectl exec $WP_POD -it /bin/sh)
#echo "mv wp-cli.phar /usr/local/bin/wp" | (kubectl exec $WP_POD -it /bin/sh)
#echo "wp core install --path=/var/www/html --url=$KUB_IP:5050 --title="WP-CLI" --admin_user=admin --admin_password=password --admin_email=info@wp-cli.org --allow-root"| (kubectl exec $WP_POD -it /bin/sh)
#echo "wp user create user1 user1@example.com --user_pass=password --role=author --allow-root"| (kubectl exec $WP_POD -it /bin/sh)
#echo "wp user create user2 user2@example.com --user_pass=password --role=author --allow-root"| (kubectl exec $WP_POD -it /bin/sh)
kubectl get all
echo "                                               http://$KUB_IP"
