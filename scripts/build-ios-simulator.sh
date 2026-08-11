#!/bin/bash
# Builds the iOS simulator app (Kotlin shared framework + SwiftUI shell).
set -euo pipefail
cd "$(dirname "$0")/.."
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
xcodebuild -project iosApp/Mercado.xcodeproj -target Mercado \
  -sdk iphonesimulator -configuration Debug \
  ARCHS=arm64 ONLY_ACTIVE_ARCH=NO build
echo "app: iosApp/build/Debug-iphonesimulator/Mercado.app"
