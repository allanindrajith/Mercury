#!/bin/bash
# render-outfits.sh — compile and run the Mochi outfit planche renderer
# NOT in CI. Run manually: bash scripts/render-outfits.sh
# Output: /tmp/mercury-outfits.png

set -e
cd "$(dirname "$0")/.."

SDK=$(xcrun --sdk macosx --show-sdk-path)

echo "Compiling renderer..."
swiftc \
  -parse-as-library \
  -sdk "$SDK" \
  -target arm64-apple-macosx15.0 \
  Mercury/Sources/MercuryKit/IslandScreenGeometry.swift \
  Mercury/Sources/MercuryKit/IslandTypes.swift \
  Mercury/Sources/MercuryKit/MochiWardrobe.swift \
  Mercury/Sources/MercuryKit/BotEngine.swift \
  Mercury/Sources/MercuryKit/MochiOutfitDrawing.swift \
  scripts/RenderOutfits.swift \
  -framework AppKit \
  -framework SwiftUI \
  -o /tmp/mercury-render-outfits \
  2>&1

echo "Running renderer..."
/tmp/mercury-render-outfits
echo "Opening..."
open /tmp/mercury-outfits.png
