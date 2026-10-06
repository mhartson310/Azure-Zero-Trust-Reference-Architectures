#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"

require_cmd az
require_env APP_IDENTITY_PRINCIPAL_ID
require_env KEY_VAULT_NAME
require_env STORAGE_ACCOUNT_NAME
require_env RESOURCE_GROUP

failures=0

storage_id=$(az storage account show -g "$RESOURCE_GROUP" -n "$STORAGE_ACCOUNT_NAME" --query id -o tsv)
vault_id=$(az keyvault show -g "$RESOURCE_GROUP" -n "$KEY_VAULT_NAME" --query id -o tsv)

has_role() {
  local scope="$1"
  local role="$2"
  local count
  count=$(az role assignment list --assignee-object-id "$APP_IDENTITY_PRINCIPAL_ID" --scope "$scope" --query "[?roleDefinitionName=='$role'] | length(@)" -o tsv)
  [[ "$count" -ge 1 ]]
}

if has_role "$storage_id" "Storage Blob Data Reader"; then
  pass "ZT-NEG-003 Workload identity has Storage Blob Data Reader"
else
  fail "ZT-NEG-003 Missing Storage Blob Data Reader"
  failures=$((failures+1))
fi

if has_role "$vault_id" "Key Vault Secrets User"; then
  pass "ZT-NEG-003 Workload identity has Key Vault Secrets User"
else
  fail "ZT-NEG-003 Missing Key Vault Secrets User"
  failures=$((failures+1))
fi

broad_roles=$(az role assignment list --assignee-object-id "$APP_IDENTITY_PRINCIPAL_ID" --all \
  --query "[?roleDefinitionName=='Owner' || roleDefinitionName=='Contributor' || roleDefinitionName=='User Access Administrator' || roleDefinitionName=='Storage Blob Data Contributor' || roleDefinitionName=='Storage Blob Data Owner' || roleDefinitionName=='Key Vault Administrator'].[roleDefinitionName,scope]" -o tsv)

if [[ -z "$broad_roles" ]]; then
  pass "ZT-NEG-003 No broad admin/write role detected"
else
  echo "$broad_roles" >&2
  fail "ZT-NEG-003 Broad admin/write role detected"
  failures=$((failures+1))
fi

exit "$failures"
