#!/usr/bin/env bash

# 01_create_users.sh

set -euo pipefail

kubectl apply -f manifests/namespaces/
kubectl apply -f manifests/serviceaccounts/

echo "Namespaces и ServiceAccounts созданы."

# Печать короткоживущих токенов
echo "Tokens (may be short-lived):"
for pair in "sales:user-dev" "data:user-viewer" "platform:user-secops" "platform:user-platform"; do
  ns="${pair%%:*}"; sa="${pair##*:}"
  printf "\n--- %s/%s ---\n" "$ns" "$sa"
  kubectl -n "$ns" create token "$sa" || true
done
