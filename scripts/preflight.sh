#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="CoWorkerAI"

echo "== Preflight checks for ${PROJECT_NAME} =="

# 1) Fail if there are .swift files in repo root (duplicates)
ROOT_SWIFT=$(find . -maxdepth 1 -type f -name "*.swift" | wc -l | tr -d ' ')
if [ "${ROOT_SWIFT}" != "0" ]; then
  echo "ERROR: Found Swift files in repo root (should be none):"
  find . -maxdepth 1 -type f -name "*.swift" -print
  echo "Move these into CoWorkerAI/CoWorkerAI/... before committing."
  exit 1
fi

# 2) Fail if any *.swift.swift exists anywhere
DUP_EXT=$(find . -type f -name "*.swift.swift" | wc -l | tr -d ' ')
if [ "${DUP_EXT}" != "0" ]; then
  echo "ERROR: Found files with double extension *.swift.swift:"
  find . -type f -name "*.swift.swift" -print
  echo "Rename to a single .swift extension."
  exit 1
fi

# 3) Ensure expected top-level layout exists
missing=0
required=(
  "CoWorkerAI/CoWorkerAI/App/CoWorkerAIApp.swift"
  "CoWorkerAI/CoWorkerAI/App/ContentView.swift"
  "CoWorkerAI/CoWorkerAI/Logging/LoggerService.swift"
  "CoWorkerAI/CoWorkerAI/Persistence/AppPaths.swift"
  "CoWorkerAI/CoWorkerAI/Services/ServiceFactory.swift"
  "CoWorkerAI/CoWorkerAI/Features/Notes/Models/Note.swift"
  "CoWorkerAI/CoWorkerAI/Features/Notes/Services/NotesRepository.swift"
  "CoWorkerAI/CoWorkerAI/Features/Notes/ViewModels/NotesViewModel.swift"
  "CoWorkerAI/CoWorkerAI/Features/Notes/Views/NotesView.swift"
  "CoWorkerAI/CoWorkerAI/Features/Notes/Views/NoteEditorView.swift"
  "CoWorkerAI/CoWorkerAI/Settings/SettingsView.swift"
)
for p in "${required[@]}"; do
  if [ ! -f "$p" ]; then
    echo "ERROR: Missing required file: $p"
    missing=1
  fi
done
if [ $missing -ne 0 ]; then
  echo "Fix the missing files before committing."
  exit 1
fi

echo "OK: Preflight passed."
