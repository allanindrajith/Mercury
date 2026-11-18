#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-flow-keys.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc Mercury/Sources/App/FlowKeyLogic.swift Mercury/Sources/App/DictationTranscript.swift \
    tests/FlowKeyLogicTests.swift -o "$TEST_DIR/flow-keys-tests"
"$TEST_DIR/flow-keys-tests"
