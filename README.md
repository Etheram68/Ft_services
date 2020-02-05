# FT_SERVICE

# AVANT TEST

Install helm / jq / docker / docker-machine / virtualbox / kubectl
minikube start --cpus=4 --memory 4000 --disk-size 11000 --vm-driver virtualbox --extra-config=apiserver.service-node-port-range=1-35000
eval $(minikube docker-env)

# TESTS
```
                         - Nginx en connexion SSH -
export KUB_IP=$(minikube ip)
ssh -v root@$KUB_IP -p 32022
(password)
                          - Test redemarrage pods -
kubectl get pods
kubectl delete pods wordpress-...
                          - Dashboard Kubernetes -
minikube dashboard
                            - PersistentVolume -
kubectl get pods
kubectl deletet pods grafana-..
                       - Rentrer dans le pod influx-db -
kubectl exec -i -t --namespace default $(kubectl get pods --namespace default -l app=influxdb -o jsonpath='{.items[0].metadata.name}') /bin/sh
Logs influxdb :
kubectl logs -f --namespace default $(kubectl get pods --namespace default -l app=influxdb -o jsonpath='{ .items[0].metadata.name }')
```
