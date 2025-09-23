#!/usr/bin/env bash
set -euo pipefail

fail=0
REQ=(
  "prompts/CoWorkAI_Master_v7.0.txt"
  "prompts/Prompt1_Arkitektur_v7.0.txt"
  "prompts/Prompt2_UI_v7.0.txt"
  "prompts/Controller_v7.0.txt"
  ".github/workflows/ci.yml"
  ".github/workflows/codeql.yml"
  ".github/workflows/openapi-lint.yml"
  ".github/workflows/foundation-check.yml"
  ".spectral.yaml"
  ".swiftlint.yml"
  ".swiftformat"
  "contracts/notes.openapi.json"
  "specs/Example_SPEC_v7.0.json"
)
for f in "${REQ[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "::error file=$f::Missing required file $f"
    fail=1
  fi
done

# SPEC keys check
if [[ -f "specs/Example_SPEC_v7.0.json" ]]; then
  keys=(product_name bundle_id platform min_os quality_gates observability apiSchemas design_tokens)
  for k in "${keys[@]}"; do
    if ! grep -q ""$k"" specs/Example_SPEC_v7.0.json; then
      echo "::error file=specs/Example_SPEC_v7.0.json::Missing key '$k'"
      fail=1
    fi
  done
fi

if [[ $fail -ne 0 ]]; then
  echo "Foundation health check FAILED"
  exit 1
else
  echo "Foundation health check PASSED"
fi
