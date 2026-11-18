#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-wardrobe.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc Mercury/Sources/MercuryKit/MochiWardrobe.swift \
    tests/MochiWardrobeTests.swift -o "$TEST_DIR/wardrobe-tests"
"$TEST_DIR/wardrobe-tests"
