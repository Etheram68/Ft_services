# **************************************************************************** #
#                                                           LE - /             #
#                                                               /              #
#    setup.sh                                         .::    .:/ .      .::    #
#                                                  +:+:+   +:    +:  +:+:+     #
#    By: frfrey <frfrey@student.le-101.fr>          +:+   +:    +:    +:+      #
#                                                  #+#   #+    #+    #+#       #
#    Created: 2020/01/30 15:45:38 by frfrey       #+#   ##    ##    #+#        #
#    Updated: 2020/02/05 17:26:48 by frfrey      ###    #+. /#+    ###.fr      #
#                                                          /                   #
#                                                         /                    #
# **************************************************************************** #

#!/bin/sh

wait_for_deploy () {
	printf "\e[0;34mWaiting for \e[0;35m"$1"\e[0;34m...\e[0m"
	sleep 5s
	export "$1"_POD=$( kubectl get pods -l app=$1 -o custom-columns=:metadata.name | tr -d '[:space:]' )
	export POD_TEMP=${1}_POD
	while [ "$( kubectl get pod ${!POD_TEMP} -o json | jq ".status.containerStatuses[0].ready" | tr -d '[:space:]' )" != "true" ]; do
		printf "\e[0;34m.\e[0m"
		sleep 5s
		export "$1"_POD=$( kubectl get pods -l app=$1 -o custom-columns=:metadata.name | tr -d '[:space:]' )
		export POD_TEMP=${1}_POD
	done
	sleep 2s
	printf "\e[0;34mDONE\e[0m\n"
}

# Ensure docker and minikube are installed
if ! which docker >/dev/null 2>&1 ||
    ! which minikube >/dev/null 2>&1
then
    echo Please install Docker and Minikube
    exit 1
fi

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

####################################   RENAME   ########################################
# Raname vsftpf.conf and modify kube ip on ftps
printf "\n\n\033[31mExport ip Image\033[00m\n"
KUB_IP=$(minikube ip)
printf "\n\033[31mCreate file conf for ftps\033[00m\n\n"
cp srcs/ftps/srcs/vsftpd.conf_model srcs/ftps/srcs/vsftpd.conf
sed -i '' "s/##KUB_IP##/$KUB_IP/g" srcs/ftps/srcs/vsftpd.conf

####################################    BUILD   ########################################
if [ "$1" = "delete" ]
then
    kubectl delete -k srcs
	helm delete grafana
	helm delete influxdb
else
	helm install -f srcs/influxdb.yml influxdb stable/influxdb
    wait_for_deploy influxdb

    helm install -f srcs/grafana.yml grafana stable/grafana
    wait_for_deploy grafana

printf "\n\033[31mBuild NGINX Image\033[00m\n\n"
docker build -t nginx_kube srcs/nginx

printf "\n\033[31mBuild MYSQL Image\033[00m\n\n"
docker build -t mysql_kube srcs/mysql

printf "\n\033[31mBuild PHPMYADMIN Image\033[00m\n\n"
docker build -t phpmyadmin_kube srcs/phpmyadmin

printf "\n\033[31mBuild WORDPRESS Image\033[00m\n\n"
docker build -t wordpress_kube srcs/wordpress

printf "\n\033[31mBuild FTPS Image\033[00m\n\n"
docker build -t ftps_kube srcs/ftps


#################################### DEPLOYMENT ########################################
printf "\n\033[31mDeploy All\033[00m\n\n"
kubectl apply -k srcs

fi


echo "\n\nMinikube ip : $KUB_IP\n"
kubectl get all
echo "                                               http://$KUB_IP"
