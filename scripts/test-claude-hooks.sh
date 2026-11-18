#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-claude-hooks.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc Mercury/Sources/App/ClaudeHookDetection.swift \
    tests/ClaudeHookDetectionTests.swift -o "$TEST_DIR/claude-hooks-tests"
"$TEST_DIR/claude-hooks-tests"
