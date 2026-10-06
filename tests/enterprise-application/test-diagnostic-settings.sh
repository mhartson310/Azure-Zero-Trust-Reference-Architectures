#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"

require_cmd az
require_env RESOURCE_GROUP
require_env KEY_VAULT_NAME
require_env STORAGE_ACCOUNT_NAME
require_env LOG_ANALYTICS_WORKSPACE_ID

failures=0

check_diag() {
  local resource_id="$1"
  local label="$2"
  local target
  target=$(az monitor diagnostic-settings list --resource "$resource_id" --query "value[?workspaceId=='$LOG_ANALYTICS_WORKSPACE_ID'].workspaceId | [0]" -o tsv)
  if [[ "$target" == "$LOG_ANALYTICS_WORKSPACE_ID" ]]; then
    pass "ZT-NEG-004 $label diagnostics target the expected workspace"
  else
    fail "ZT-NEG-004 $label diagnostics missing or misrouted"
    failures=$((failures+1))
  fi
}

kv_id=$(az keyvault show -g "$RESOURCE_GROUP" -n "$KEY_VAULT_NAME" --query id -o tsv)
st_id=$(az storage account show -g "$RESOURCE_GROUP" -n "$STORAGE_ACCOUNT_NAME" --query id -o tsv)

check_diag "$kv_id" "Key Vault"
check_diag "$st_id" "Storage"

exit "$failures"
