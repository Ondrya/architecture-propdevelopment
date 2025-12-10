#!/usr/bin/env bash
set -euxo pipefail

kubectl create namespace traffic || true
kubectl config set-context --current --namespace=traffic

kubectl run front-end-app           --image=nginx --labels=role=front-end           --expose --port=80 || true
kubectl run back-end-api-app        --image=nginx --labels=role=back-end-api        --expose --port=80 || true
kubectl run admin-front-end-app     --image=nginx --labels=role=admin-front-end     --expose --port=80 || true
kubectl run admin-back-end-api-app  --image=nginx --labels=role=admin-back-end-api  --expose --port=80 || true

kubectl apply -f non-admin-api-allow.yaml
