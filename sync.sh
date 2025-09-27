#!/usr/bin/env bash
set -euo pipefail

PROJECT="/Users/kenny/Xcode Projects/CoWorkerAI"
TEMPLATE="/Users/kenny/Xcode Projects/CoWorkAI-Foundation"

[ -d "$PROJECT" ]  || { echo "PROJECT findes ikke: $PROJECT"; exit 1; }
[ -d "$TEMPLATE" ] || { echo "TEMPLATE findes ikke: $TEMPLATE"; exit 1; }

echo "== Kopierer alt nødvendigt skelet til templaten =="
rsync -a --exclude='.git' \
  "$PROJECT/CoWorkerAI/" \
  "$TEMPLATE/CoWorkerAI/"

echo "== Kopierer scripts/hooks/gitignore/README =="
mkdir -p "$TEMPLATE/scripts" "$TEMPLATE/.githooks"
rsync -a "$PROJECT/scripts/"    "$TEMPLATE/scripts/"
rsync -a "$PROJECT/.githooks/"  "$TEMPLATE/.githooks/" 2>/dev/null || true
cp -f "$PROJECT/.gitignore"     "$TEMPLATE/.gitignore"
cp -f "$PROJECT/README.md"      "$TEMPLATE/README.md"

echo "== Gør scripts kørbare og sæt hooksPath =="
chmod +x "$TEMPLATE"/scripts/*.sh 2>/dev/null || true
chmod +x "$TEMPLATE/.githooks/pre-commit" 2>/dev/null || true
cd "$TEMPLATE"
git config core.hooksPath .githooks

echo "== Kør preflight i templaten =="
if [ -x scripts/preflight.sh ]; then
  ./scripts/preflight.sh
else
  echo "ERROR: scripts/preflight.sh mangler i templaten (burde være kopieret)."
  exit 1
fi

echo "== Commit & push =="
git add .
git commit -m "chore(template): sync full skeleton (App, Notes, Settings, Logging, Persistence, Services)"
git push || echo "(ingen remote sat?)"

echo "SYNC færdig."
