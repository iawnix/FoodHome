#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export FLUTTER_HOME="/home/iaw/soft/flutter"
export ANDROID_SDK_ROOT="/home/iaw/soft/android/sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export JAVA_HOME="/home/iaw/soft/jdk21-local/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="$FLUTTER_HOME/bin:$JAVA_HOME/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/build-tools/36.0.0:$PATH"
export PUB_CACHE="$ROOT/.pub-cache"
export GRADLE_USER_HOME="$ROOT/.gradle"
export NO_PROXY="${NO_PROXY:-localhost,127.0.0.1,::1,10.0.2.2}"
export no_proxy="${no_proxy:-localhost,127.0.0.1,::1,10.0.2.2}"

echo "== FoodHome doctor =="
echo "ROOT=$ROOT"
flutter --version
flutter doctor -v

echo "== Flutter checks =="
cd "$ROOT/app"
flutter pub get
flutter analyze
flutter test

if command -v npm >/dev/null 2>&1; then
  echo "== Functions checks =="
  cd "$ROOT/functions"
  npm install
  npm test
else
  echo "npm missing; skipped functions checks"
fi
