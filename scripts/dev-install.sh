#!/usr/bin/env bash
# Builds Mercury the way it runs every day (DebugCloud: signed with the Apple Development
# certificate, iPhone link on) and makes it the only Mercury: installed in /Applications,
# the copies left by earlier builds removed.
#
# Why: macOS gives its permissions (Accessibility, Screen Recording, microphone...) to one
# app signed one way. An unsigned Debug build looks like a new app after every build, and
# each copy of Mercury.app is one more entry to allow. One signed app at one place keeps
# its permissions from one build to the next.
#
#   ./scripts/dev-install.sh
#
# Use it instead of xcodebuild by hand or ▶ in Xcode (which leave copies in DerivedData).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUNDLE_ID="com.mercury.app"
DERIVED="${HOME}/Library/Developer/Xcode/DerivedData/MercuryDev"
BUILT="${DERIVED}/Build/Products/DebugCloud/Mercury.app"
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister"

# The App Store Mercury (com.mercury.app) has the same file name: never overwrite it.
TARGET="/Applications/Mercury.app"
if [ -d "${TARGET}" ]; then
  EXISTING=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "${TARGET}/Contents/Info.plist" 2>/dev/null || echo "")
  if [ "${EXISTING}" != "${BUNDLE_ID}" ]; then
    mkdir -p "${HOME}/Applications"
    TARGET="${HOME}/Applications/Mercury.app"
    echo "/Applications/Mercury.app is another Mercury (${EXISTING}): installing in ~/Applications instead."
  fi
fi

echo "Building (DebugCloud)..."
cd "${REPO_ROOT}/Mercury"
xcodegen >/dev/null
xcodebuild -scheme MercuryCloud -configuration DebugCloud -allowProvisioningUpdates \
  -derivedDataPath "${DERIVED}" -quiet build

echo "Quitting Mercury..."
osascript -e "tell application id \"${BUNDLE_ID}\" to quit" >/dev/null 2>&1 || true
for _ in 1 2 3 4 5; do pgrep -x Mercury >/dev/null || break; sleep 1; done
pkill -x Mercury 2>/dev/null || true

echo "Installing in ${TARGET}..."
rm -rf "${TARGET}"
ditto "${BUILT}" "${TARGET}"

# The build stays in DerivedData for the next (incremental) build, but macOS must not
# count it as another Mercury. Copies from Xcode's own builds (▶, xcodebuild by hand) go.
"${LSREGISTER}" -u "${BUILT}" >/dev/null 2>&1 || true
for old in "${HOME}"/Library/Developer/Xcode/DerivedData/Mercury-*/Build/Products/*/Mercury.app; do
  [ -d "$old" ] || continue
  "${LSREGISTER}" -u "$old" >/dev/null 2>&1 || true
  rm -rf "$old"
  echo "Removed an old build: $old"
done
"${LSREGISTER}" -f "${TARGET}" >/dev/null 2>&1 || true

open "${TARGET}"
echo "Mercury is running from ${TARGET}."
