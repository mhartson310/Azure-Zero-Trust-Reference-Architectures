#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"

require_cmd az
require_env RESOURCE_GROUP
require_env WEB_APP_NAME
require_env KEY_VAULT_NAME
require_env STORAGE_ACCOUNT_NAME

failures=0

web_public=$(az webapp show -g "$RESOURCE_GROUP" -n "$WEB_APP_NAME" --query publicNetworkAccess -o tsv)
[[ "$web_public" == "Disabled" ]] && pass "ZT-NEG-001 App Service public access disabled" || { fail "ZT-NEG-001 App Service public access is $web_public"; failures=$((failures+1)); }

kv_public=$(az keyvault show -g "$RESOURCE_GROUP" -n "$KEY_VAULT_NAME" --query properties.publicNetworkAccess -o tsv)
[[ "$kv_public" == "Disabled" ]] && pass "ZT-NEG-001 Key Vault public access disabled" || { fail "ZT-NEG-001 Key Vault public access is $kv_public"; failures=$((failures+1)); }

st_public=$(az storage account show -g "$RESOURCE_GROUP" -n "$STORAGE_ACCOUNT_NAME" --query publicNetworkAccess -o tsv)
[[ "$st_public" == "Disabled" ]] && pass "ZT-NEG-001 Storage public access disabled" || { fail "ZT-NEG-001 Storage public access is $st_public"; failures=$((failures+1)); }

st_shared_key=$(az storage account show -g "$RESOURCE_GROUP" -n "$STORAGE_ACCOUNT_NAME" --query allowSharedKeyAccess -o tsv)
[[ "$st_shared_key" == "false" ]] && pass "Storage shared-key access disabled" || { fail "Storage shared-key access is not disabled"; failures=$((failures+1)); }

exit "$failures"
