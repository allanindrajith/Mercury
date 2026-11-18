#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-review.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc Mercury/Sources/MercuryKit/ReviewPolicy.swift tests/ReviewPolicyTests.swift -o "$TEST_DIR/review-tests"
"$TEST_DIR/review-tests"
