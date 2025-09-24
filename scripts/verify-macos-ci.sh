#!/usr/bin/env bash
set -euo pipefail

SCHEME="${1:-CoWorkerAI}"
EXPECT_BUNDLE="${2:-com.kennyback.coworkerai}"

# find projekt
PROJ="$(ls -1 *.xcodeproj 2>/dev/null | head -n1 || true)"
if [[ -z "${PROJ}" ]]; then
  echo "❌ Ingen .xcodeproj i mappen"; exit 1
fi
echo "• Projekt: ${PROJ}"

# 1) Scheme findes og er delt?
if [[ ! -f "${PROJ}/xcshareddata/xcschemes/${SCHEME}.xcscheme" ]]; then
  echo "❌ Shared scheme mangler: ${SCHEME}"
  echo "  Xcode → Product → Scheme → Manage Schemes… → sæt ✓ Shared på '${SCHEME}'"
  exit 1
fi
echo "✓ Shared scheme fundet: ${SCHEME}"

# 2) Bundle id matcher forventning?
BUNDLE_ID="$(xcodebuild -showBuildSettings -scheme "${SCHEME}" -destination 'platform=macOS' 2>/dev/null \
  | sed -n 's/^[ ]*PRODUCT_BUNDLE_IDENTIFIER = \(.*\)$/\1/p' | tail -n1)"
if [[ -z "${BUNDLE_ID}" ]]; then
  echo "❌ Kunne ikke læse PRODUCT_BUNDLE_IDENTIFIER via xcodebuild"; exit 1
fi
echo "• Bundle id i build settings: ${BUNDLE_ID}"
if [[ "${BUNDLE_ID}" != "${EXPECT_BUNDLE}" ]]; then
  echo "❌ Bundle id matcher ikke forventning"
  echo "  Forventet: ${EXPECT_BUNDLE}"
  echo "  Sæt den i Xcode: TARGETS ▸ ${SCHEME} ▸ General ▸ Bundle Identifier"
  exit 1
fi
echo "✓ Bundle id matcher forventning"

# 3) Test-build uden signering (som i CI)
echo "• Testbygger uden signering…"
xcodebuild -scheme "${SCHEME}" -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO >/dev/null
echo "✓ Build OK uden signering"

echo "✅ Alt ser rigtigt ud til CI (scheme, bundle, signing)"
