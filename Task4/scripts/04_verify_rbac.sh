#!/usr/bin/env bash
set -euo pipefail

# Цвета для удобства
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_check() {
  local desc="$1"
  local cmd="$2"
  printf "%-70s" "$desc"
  if eval "$cmd" &>/dev/null; then
    echo -e "${GREEN}✅ OK${NC}"
  else
    echo -e "${RED}❌ FAIL${NC}"
    FAILURES+=("$desc")
  fi
}

echo -e "${BLUE}🔍 Проверка RBAC-политик${NC}"
echo "=================================================="

declare -a FAILURES=()

# --- 1. user-dev в sales ---
echo -e "\n${BLUE}→ Проверка: sales/user-dev (разработчик)${NC}"
print_check "Может создавать Deployment в sales" \
  "kubectl auth can-i create deploy -n sales --as=system:serviceaccount:sales:user-dev"
print_check "НЕ может читать Secret в sales" \
  "! kubectl auth can-i get secret -n sales --as=system:serviceaccount:sales:user-dev"

# --- 2. user-secops (SecOps) ---
echo -e "\n${BLUE}→ Проверка: platform/user-secops (SecOps)${NC}"
print_check "Может читать Secret в finance" \
  "kubectl auth can-i get secrets -n finance --as=system:serviceaccount:platform:user-secops"
print_check "Может читать Secret в sales" \
  "kubectl auth can-i get secrets -n sales --as=system:serviceaccount:platform:user-secops"
print_check "НЕ может создавать Pod в sales (только read!)" \
  "! kubectl auth can-i create pod -n sales --as=system:serviceaccount:platform:user-secops"

# --- 3. user-viewer в data ---
echo -e "\n${BLUE}→ Проверка: data/user-viewer (аналитик)${NC}"
print_check "Может читать Deployment в data" \
  "kubectl auth can-i get deploy -n data --as=system:serviceaccount:data:user-viewer"
print_check "НЕ может изменять Deployment в data" \
  "! kubectl auth can-i patch deploy -n data --as=system:serviceaccount:data:user-viewer"
print_check "НЕ может читать Secret в data" \
  "! kubectl auth can-i get secrets -n data --as=system:serviceaccount:data:user-viewer"

# --- 4. user-platform (platform engineer) ---
echo -e "\n${BLUE}→ Проверка: platform/user-platform (платформа)${NC}"
print_check "Может создавать Namespace" \
  "kubectl auth can-i create namespace --as=system:serviceaccount:platform:user-platform"
print_check "НЕ может читать Secret в sales" \
  "! kubectl auth can-i get secrets -n sales --as=system:serviceaccount:platform:user-platform"
print_check "НЕ может обновлять ClusterRole" \
  "! kubectl auth can-i update clusterrole --as=system:serviceaccount:platform:user-platform"

# --- Итог ---
echo
echo "=================================================="
if [ ${#FAILURES[@]} -eq 0 ]; then
  echo -e "${GREEN}🎉 Все проверки пройдены. RBAC настроен корректно.${NC}"
  exit 0
else
  echo -e "${RED}❗ Найдено ${#FAILURES[@]} нарушений:${NC}"
  for fail in "${FAILURES[@]}"; do
    echo "  • $fail"
  done
  echo
  echo -e "${BLUE}💡 Совет: проверьте RoleBinding и subjects.namespace в манифестах.${NC}"
  exit 1
fi