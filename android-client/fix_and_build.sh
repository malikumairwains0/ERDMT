#!/bin/bash

set -e

MANIFEST="app/src/main/AndroidManifest.xml"
JAVA_DIR="app/src/main/java/com/erdmt"
BACKUP="$MANIFEST.bak"

echo -e "📦 Backing up AndroidManifest.xml to \033[1;34m$BACKUP\033[0m"
cp "$MANIFEST" "$BACKUP"

echo -e "🔍 Checking for missing attributes and permissions..."

# Fix android:exported in all receivers with intent-filter
sed -i '/<receiver[^>]*android:name=.*SmsReceiver/ s|<receiver|<receiver android:exported="true"|' "$MANIFEST"
sed -i '/<receiver[^>]*android:name=.*BootReceiver/ s|<receiver|<receiver android:exported="true"|' "$MANIFEST"

# Remove duplicate permissions
awk '!seen[$0]++' "$MANIFEST" > temp && mv temp "$MANIFEST"

# Remove obsolete package declaration
sed -i '/<manifest .*package=/ s/package="[^"]*" //' "$MANIFEST"

echo -e "🛠️ Ensuring required permissions..."
for PERM in "INTERNET" "RECORD_AUDIO" "CAMERA" "READ_CONTACTS" "READ_SMS" "RECEIVE_SMS" "READ_CALL_LOG" "READ_PHONE_STATE" "ACCESS_FINE_LOCATION"; do
  grep -q "android.permission.$PERM" "$MANIFEST" || \
  sed -i "/<uses-permission/a\    <uses-permission android:name=\"android.permission.$PERM\" />" "$MANIFEST"
done

echo -e "📄 Ensuring required services..."
SERVICE_LINE='<service android:name=".service.CallLogService" android:exported="false" />'
grep -q "$SERVICE_LINE" "$MANIFEST" || \
sed -i '/<service android:name=".service.ERDMTService"/a\        '"$SERVICE_LINE" "$MANIFEST"

echo -e "🔨 Running \033[1;32mGradle clean build\033[0m..."
./gradlew clean build > build.log 2>&1

if [ $? -eq 0 ]; then
    echo -e "✅ \033[1;32mBUILD SUCCESSFUL\033[0m"
else
    echo -e "❌ \033[1;31mBUILD FAILED\033[0m. Showing last 20 lines of log:"
    tail -n 20 build.log
fi
