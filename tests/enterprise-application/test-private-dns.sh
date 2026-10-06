#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"

require_cmd python3
require_env WEB_APP_NAME
require_env KEY_VAULT_NAME
require_env STORAGE_ACCOUNT_NAME

python3 - "$WEB_APP_NAME" "$KEY_VAULT_NAME" "$STORAGE_ACCOUNT_NAME" <<'PY'
import ipaddress
import socket
import sys

names = [
    f"{sys.argv[1]}.azurewebsites.net",
    f"{sys.argv[2]}.vault.azure.net",
    f"{sys.argv[3]}.blob.core.windows.net",
]

failed = False
for name in names:
    try:
        addresses = sorted(set(socket.gethostbyname_ex(name)[2]))
    except Exception as exc:
        print(f"FAIL  ZT-NEG-005 {name} did not resolve: {exc}")
        failed = True
        continue

    private = [ip for ip in addresses if ipaddress.ip_address(ip).is_private]
    if private:
        print(f"PASS  ZT-NEG-005 {name} resolves privately: {', '.join(private)}")
    else:
        print(f"FAIL  ZT-NEG-005 {name} resolved without a private IP: {', '.join(addresses)}")
        failed = True

sys.exit(1 if failed else 0)
PY
