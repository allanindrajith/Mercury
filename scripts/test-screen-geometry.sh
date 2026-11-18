#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mercury-geometry.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc Mercury/Sources/MercuryKit/IslandScreenGeometry.swift \
    tests/IslandScreenGeometryTests.swift -o "$TEST_DIR/geometry-tests"
"$TEST_DIR/geometry-tests"
