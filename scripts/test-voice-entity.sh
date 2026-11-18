#!/usr/bin/env bash
set -e
echo "Running EntityResolver tests…"
swiftc -o /tmp/voice-entity-tests \
  tests/VoiceTestStubs.swift \
  tests/PillFixture.swift \
  Mercury/Sources/App/Voice/VoiceIntent.swift \
  Mercury/Sources/App/Voice/IntentParser.swift \
  Mercury/Sources/App/Voice/VoiceQuery.swift \
  Mercury/Sources/App/Voice/EntityResolver.swift \
  tests/EntityResolverTests.swift
/tmp/voice-entity-tests
