#!/bin/bash

minikube config set vm-driver virtualbox

minikube start --cpus=2 --memory 4000
minikube addons enable dashboard
minikube addons enable metallb

eval $(minikube docker-env)
docker build -t nginx srcs/nginx
docker build -t mysql srcs/MySQL
docker build -t phpmyadmin srcs/PhpMyAdmin
docker build -t wordpress srcs/wordpress

kubectl create secret generic db-user-pass --from-file=./srcs/username.txt --from-file=./srcs/password.txt
kubectl create configmap confnginx --from-file=./srcs/nginx/nginx.conf
kubectl describe cm config -n metallb-system
kubectl apply -k srcs