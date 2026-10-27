#!/usr/bin/env bash
# Builds barUp.apk with plain SDK tools (no Gradle) -> tiny APK
set -euo pipefail
cd "$(dirname "$0")"
BT=${BT:-$ANDROID_HOME/build-tools/34.0.0}; JAR=${JAR:-$ANDROID_HOME/platforms/android-34/android.jar}
rm -rf out && mkdir -p out/cls gen
"$BT/aapt" package -f -M AndroidManifest.xml -S res -I "$JAR" -F out/base.apk -J gen
javac -source 8 -target 8 -nowarn -bootclasspath "$JAR" -d out/cls $(find src gen -name '*.java')
"$BT/d8" --release --min-api 28 --lib "$JAR" --output out $(find out/cls -name '*.class')
cp out/base.apk out/u.apk && (cd out && zip -qj u.apk classes.dex)
"$BT/zipalign" -f 4 out/u.apk out/a.apk
"$BT/apksigner" sign --ks release.jks --ks-pass pass:${KS_PASS:-barupks2026} --out out/barUp.apk out/a.apk
SIZE=$(stat -c%s out/barUp.apk); echo "APK size: $SIZE bytes"
[ "$SIZE" -lt 1048576 ] || { echo "APK over 1 MB"; exit 1; }
