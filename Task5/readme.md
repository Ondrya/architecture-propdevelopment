# Задание 5

Выполнить скрипт `init.sh`.

```bash
    ./init.sh
```

```bash
    kubectl run test-$RANDOM --rm -i -t --image=alpine -- sh # wget -qO- --timeout=2 http://apiserver
```
