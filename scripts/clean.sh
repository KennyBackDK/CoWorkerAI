#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="CoWorkerAI"
DD="$HOME/Library/Developer/Xcode/DerivedData"

echo "== Cleaning DerivedData entries for ${PROJECT_NAME} =="
if [ -d "$DD" ]; then
  find "$DD" -maxdepth 1 -type d -name "${PROJECT_NAME}-*" -print -exec rm -rf {} +
else
  echo "DerivedData folder not found: $DD"
fi
echo "Done."
