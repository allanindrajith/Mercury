#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-pill-colors.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc Mercury/Sources/MercuryKit/PillColors.swift \
    tests/PillColorsTests.swift -o "$TEST_DIR/pill-colors-tests"
"$TEST_DIR/pill-colors-tests"
