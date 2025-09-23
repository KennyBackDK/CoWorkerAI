#!/usr/bin/env bash
set -euo pipefail

PRODUCT="${1:?Product Name (quoted)}"
BUNDLE="${2:?Bundle ID}"
SCHEME="${3:-App}"

# Update SPEC (product_name + bundle_id)
SPEC="specs/Example_SPEC_v7.0.json"
if [[ -f "$SPEC" ]]; then
  python3 - <<PY
import json
path="${SPEC}"
with open(path,"r+",encoding="utf-8") as f:
    data=json.load(f)
    data["product_name"]="${PRODUCT}"
    data["bundle_id"]="${BUNDLE}"
    f.seek(0); json.dump(data,f,indent=2,ensure_ascii=False); f.truncate()
print("Updated", "${SPEC}")
PY
else
  echo "WARN: ${SPEC} not found (skipping)."
fi

# Update CI scheme
CI=".github/workflows/ci.yml"
if [[ -f "$CI" ]]; then
  # macOS/BSD sed: -i ''
  sed -i '' 's/-scheme "App"/-scheme "'"$SCHEME"'"/g' "$CI" || true
  echo "Updated Xcode scheme to '$SCHEME' in $CI"
fi

echo "Init complete → PRODUCT='${PRODUCT}', BUNDLE='${BUNDLE}', SCHEME='${SCHEME}'"
