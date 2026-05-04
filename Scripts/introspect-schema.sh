#!/usr/bin/env bash
# Dev-only helper: introspect a single GraphQL type from the Upwork schema and pretty-print
# its fields. Reads the access token from the macOS Keychain (matches what the app stores).
#
# Usage:
#   Scripts/introspect-schema.sh ContractTimeReportNode
#   Scripts/introspect-schema.sh Query     # to see all root fields
#
# Requires: jq, curl, security (default on macOS).

set -euo pipefail

TYPE="${1:-Query}"
TENANT="${UPWORK_TENANT_ID:-}"

TOKEN=$(security find-generic-password -s com.upworkbuddy.tokens -a access -w 2>/dev/null || true)
if [[ -z "${TOKEN}" ]]; then
  echo "No access token found in Keychain. Sign in via the app first." >&2
  exit 1
fi

QUERY=$(cat <<EOF
{ "query": "query Q(\$name: String!) { __type(name: \$name) { name kind fields { name type { name kind ofType { name kind ofType { name kind } } } } } }",
  "variables": { "name": "${TYPE}" } }
EOF
)

HEADERS=(-H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/json")
if [[ -n "${TENANT}" ]]; then
  HEADERS+=(-H "X-Upwork-API-TenantId: ${TENANT}")
fi

curl -s "${HEADERS[@]}" -X POST https://api.upwork.com/graphql --data "${QUERY}" \
  | jq '.data.__type'
