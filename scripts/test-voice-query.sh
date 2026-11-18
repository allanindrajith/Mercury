#!/usr/bin/env bash
set -e
echo "Running VoiceQuery tests…"
swiftc -o /tmp/voice-query-tests \
  tests/VoiceTestStubs.swift \
  tests/PillFixture.swift \
  Mercury/Sources/App/Voice/VoiceIntent.swift \
  Mercury/Sources/App/Voice/EntityResolver.swift \
  Mercury/Sources/App/Voice/IntentParser.swift \
  Mercury/Sources/App/Voice/VoiceQuery.swift \
  tests/VoiceQueryTests.swift
/tmp/voice-query-tests
