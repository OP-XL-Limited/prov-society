#!/usr/bin/env bash
# SPEC 11.3: capture every screen on the iOS simulator in Nocturne and Atelier,
# at default and large text, into screenshots/<phase>/.
# Usage: scripts/capture-screenshots.sh <phase> [simulator-udid] route...
set -euo pipefail
phase="$1"; sim="$2"; shift 2
routes=("$@")
root="$(cd "$(dirname "$0")/.." && pwd)"
out="$root/screenshots/$phase"
mkdir -p "$out"
xcrun simctl bootstatus "$sim" -b >/dev/null
cd "$root/apps/mobile"
for theme in nocturne atelier; do
  for route in "${routes[@]}"; do
    flutter run -d "$sim" --no-resident --debug \
      --dart-define=PS_THEME="$theme" --dart-define=PS_ROUTE="/$route" >/dev/null 2>&1
    for size in default large; do
      if [ "$size" = large ]; then
        xcrun simctl ui "$sim" content_size accessibility-extra-extra-large
      else
        xcrun simctl ui "$sim" content_size large
      fi
      xcrun simctl terminate "$sim" society.provenance.provenanceSociety >/dev/null 2>&1 || true
      xcrun simctl launch "$sim" society.provenance.provenanceSociety >/dev/null
      sleep 4
      xcrun simctl io "$sim" screenshot "$out/${route}-${theme}-${size}.png" >/dev/null 2>&1
      echo "captured ${route}-${theme}-${size}"
    done
  done
done
xcrun simctl ui "$sim" content_size large
