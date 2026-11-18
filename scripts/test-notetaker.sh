#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-notetaker.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc Mercury/Sources/App/NoteModels.swift Mercury/Sources/App/NoteEcho.swift tests/NoteModelsTests.swift -o "$TEST_DIR/notetaker-tests"
"$TEST_DIR/notetaker-tests"
