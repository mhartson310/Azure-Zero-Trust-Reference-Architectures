#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"

require_cmd az
require_env RESOURCE_GROUP
require_env WEB_APP_NAME
require_env KEY_VAULT_NAME
require_env STORAGE_ACCOUNT_NAME

failures=0

check_pe() {
  local resource_id="$1"
  local label="$2"
  local count
  count=$(az network private-endpoint-connection list --id "$resource_id" --query "[?properties.privateLinkServiceConnectionState.status=='Approved'] | length(@)" -o tsv 2>/dev/null || echo 0)
  if [[ "$count" -ge 1 ]]; then
    pass "ZT-NEG-002 $label has an approved private endpoint"
  else
    fail "ZT-NEG-002 $label has no approved private endpoint"
    failures=$((failures+1))
  fi
}

web_id=$(az webapp show -g "$RESOURCE_GROUP" -n "$WEB_APP_NAME" --query id -o tsv)
kv_id=$(az keyvault show -g "$RESOURCE_GROUP" -n "$KEY_VAULT_NAME" --query id -o tsv)
st_id=$(az storage account show -g "$RESOURCE_GROUP" -n "$STORAGE_ACCOUNT_NAME" --query id -o tsv)

check_pe "$web_id" "App Service"
check_pe "$kv_id" "Key Vault"
check_pe "$st_id" "Storage"

exit "$failures"
