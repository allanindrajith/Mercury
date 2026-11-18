#!/usr/bin/env bash
set -e
echo "Running VoiceActionRunner tests…"
swiftc -o /tmp/voice-runner-tests \
  tests/VoiceTestStubs.swift \
  tests/PillFixture.swift \
  Mercury/Sources/App/Voice/VoiceIntent.swift \
  Mercury/Sources/App/Voice/IntentParser.swift \
  Mercury/Sources/App/Voice/VoiceQuery.swift \
  Mercury/Sources/App/Voice/EntityResolver.swift \
  Mercury/Sources/App/Voice/VoiceActionRunner.swift \
  tests/VoiceActionRunnerTests.swift
/tmp/voice-runner-tests
