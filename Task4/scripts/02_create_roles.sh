#!/usr/bin/env bash

# 02_create_roles.sh

set -euo pipefail

kubectl apply -f manifests/roles-cluster/

for ns in sales tenant finance data; do
  kubectl -n "$ns" apply -f "manifests/roles/$ns/"
done

echo "ClusterRoles и Roles созданы."
