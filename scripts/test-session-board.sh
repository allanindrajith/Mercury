#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-session-board.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc -swift-version 6 -strict-concurrency=complete \
    Mercury/Sources/App/SessionBoard.swift tests/SessionBoardTests.swift -o "$TEST_DIR/session-board-tests"
"$TEST_DIR/session-board-tests"
