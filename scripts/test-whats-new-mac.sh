#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-whats-new.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc Mercury/Sources/App/MacUpdate.swift Mercury/Sources/App/WhatsNew.swift tests/WhatsNewTests.swift -o "$TEST_DIR/whats-new-tests"
"$TEST_DIR/whats-new-tests"
python3 scripts/test-whats-new.py
