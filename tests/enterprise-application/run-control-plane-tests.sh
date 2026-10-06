#!/usr/bin/env bash
set -euo pipefail
base="$(cd "$(dirname "$0")" && pwd)"

tests=(
  "test-public-endpoints-disabled.sh"
  "test-private-endpoints-approved.sh"
  "test-least-privilege-rbac.sh"
  "test-diagnostic-settings.sh"
)

failures=0
for test in "\${tests[@]}"; do
  echo
  echo "=== $test ==="
  if ! "$base/$test"; then
    failures=$((failures+1))
  fi
done

echo
if [[ "$failures" -eq 0 ]]; then
  echo "PASS  All control-plane negative-security tests passed."
  exit 0
fi

echo "FAIL  $failures control-plane test group(s) failed." >&2
exit 1
