#!/bin/sh

minikube start --memory=16g --cpus=4 --disk-size=100g --addons=ingress,ingress-dns,metrics-server,registry,yakd

minikube service yakd-dashboard -n yakd-dashboard