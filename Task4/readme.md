# Применение скриптов

Перейти в каталог Task4

Удостовериться, что стоит чистый minikub

Шаг 1

```bash
# Создаст ClusterRole (глобально) и Role в sales, tenant, finance, data.
./scripts/01_create_roles.sh
```

Проверка

```bash
kubectl get clusterroles | grep -E 'sales|data|platform'
kubectl get roles -n sales
kubectl get roles -n data
```

Шаг 2

```bash
./scripts/02_create_users.sh
```

Шаг 3

```bash
./scripts/03_bind_users.sh
```

Проверка

```bash
./scripts/04_verify_rbac.sh
```
