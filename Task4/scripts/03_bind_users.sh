#!/usr/bin/env bash

# 03_bind_users.sh

set -euo pipefail

# Кластерные привязки
kubectl apply -f manifests/bindings/cluster/

# Доменные привязки (минимум две — для примера: sales/dev и data/viewer)
kubectl apply -f manifests/bindings/sales/
kubectl apply -f manifests/bindings/data/

echo "ClusterRoleBinding и RoleBinding созданы."
