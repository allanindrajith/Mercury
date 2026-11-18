#!/usr/bin/env bash
set -e
echo "Running IntentParser tests…"
swiftc -o /tmp/voice-intent-tests \
  tests/VoiceTestStubs.swift \
  tests/PillFixture.swift \
  Mercury/Sources/App/Voice/VoiceIntent.swift \
  Mercury/Sources/App/Voice/EntityResolver.swift \
  Mercury/Sources/App/Voice/IntentParser.swift \
  Mercury/Sources/App/Voice/VoiceQuery.swift \
  tests/IntentParserTests.swift
/tmp/voice-intent-tests
