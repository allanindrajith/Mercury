#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-display.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc Mercury/Sources/App/IslandDisplayChoice.swift \
    tests/IslandDisplayChoiceTests.swift -o "$TEST_DIR/display-tests"
"$TEST_DIR/display-tests"
