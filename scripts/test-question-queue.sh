#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-question-queue.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc Mercury/Sources/App/QuestionQueue.swift Mercury/Sources/App/AskQuestion.swift \
    tests/QuestionQueueTests.swift -o "$TEST_DIR/question-queue-tests"
"$TEST_DIR/question-queue-tests"
