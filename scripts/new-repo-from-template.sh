#!/usr/bin/env bash
set -euo pipefail

OWNER="${1:?GitHub owner/org}"
NEWREPO="${2:?New repo name}"
VISIBILITY="${3:-private}"  # public|private
if [[ "$VISIBILITY" != "public" && "$VISIBILITY" != "private" ]]; then
  echo "Visibility must be 'public' or 'private'"; exit 1
fi

TEMPLATE="KennyBackDK/CoWorkAI-Foundation"

# Login to gh if needed
gh auth status -h github.com >/dev/null 2>&1 || gh auth login -h github.com -s repo -s workflow

# Create repo from template and clone
if [[ "$VISIBILITY" == "public" ]]; then
  gh repo create "${OWNER}/${NEWREPO}" --template "$TEMPLATE" --public --clone
else
  gh repo create "${OWNER}/${NEWREPO}" --template "$TEMPLATE" --private --clone
fi

cd "$NEWREPO"
if [[ -f scripts/foundation-health.sh ]]; then
  bash scripts/foundation-health.sh || true
fi
echo "Done → ${OWNER}/${NEWREPO}"
