#!/usr/bin/env bash
set -euo pipefail

PROJECT="/Users/kenny/Xcode Projects/CoWorkerAI"
TEMPLATE="/Users/kenny/Xcode Projects/CoWorkAI-Foundation"

echo "== Paths =="
echo "PROJECT:  $PROJECT"
echo "TEMPLATE: $TEMPLATE"
[ -d "$PROJECT" ] || { echo "!! PROJECT findes ikke"; exit 1; }
[ -d "$TEMPLATE" ] || { echo "!! TEMPLATE findes ikke"; exit 1; }

cd "$PROJECT"

echo
echo "== Git status (skal være clean) =="
git status --porcelain=v1 || true

echo
echo "== Preflight i PROJEKT =="
[ -x scripts/preflight.sh ] || { echo "!! scripts/preflight.sh mangler eller er ikke kørbar"; exit 1; }
./scripts/preflight.sh

echo
echo "== Rod-*.swift (må ikke findes) =="
find . -maxdepth 1 -type f -name "*.swift" -print || true

echo
echo "== Forventede filer i PROJEKT =="
missing=0
while read -r p; do
  [ -z "$p" ] && continue
  if [ ! -f "$p" ]; then echo "Missing: $p"; missing=1; fi
done <<'EOF2'
CoWorkerAI/CoWorkerAI/App/CoWorkerAIApp.swift
CoWorkerAI/CoWorkerAI/App/ContentView.swift
CoWorkerAI/CoWorkerAI/Logging/LoggerService.swift
CoWorkerAI/CoWorkerAI/Persistence/AppPaths.swift
CoWorkerAI/CoWorkerAI/Services/ServiceFactory.swift
CoWorkerAI/CoWorkerAI/Features/Notes/Models/Note.swift
CoWorkerAI/CoWorkerAI/Features/Notes/Services/NotesRepository.swift
CoWorkerAI/CoWorkerAI/Features/Notes/ViewModels/NotesViewModel.swift
CoWorkerAI/CoWorkerAI/Features/Notes/Views/NotesView.swift
CoWorkerAI/CoWorkerAI/Features/Notes/Views/NoteEditorView.swift
CoWorkerAI/CoWorkerAI/Settings/SettingsView.swift
EOF2
[ $missing -eq 0 ] && echo "OK: alle kernefiler findes."

echo
echo "== Hooks-opsætning (pre-commit) =="
git config --get core.hooksPath || echo "(ingen hooksPath sat endnu)"

echo
echo "== TEMPLATENS preflight (dry-run) =="
cd "$TEMPLATE"
git config core.hooksPath .githooks >/dev/null 2>&1 || true
if [ -x scripts/preflight.sh ]; then
  ./scripts/preflight.sh || echo "Preflight i templaten fejlede (forventeligt hvis den ikke er opdateret endnu)."
else
  echo "(Templaten har endnu ikke scripts/preflight.sh – vi lægger det ind i næste trin)"
fi

echo
echo "CHECK færdig."
