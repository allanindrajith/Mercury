#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-launch.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc Mercury/Sources/App/LaunchScript.swift Mercury/Sources/App/TerminalTarget.swift \
    tests/SessionLaunchTests.swift -o "$TEST_DIR/launch-tests"
"$TEST_DIR/launch-tests"
