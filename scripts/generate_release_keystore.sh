#!/usr/bin/env bash
# Generates a release signing keystore for the Android app and writes the
# keystore.properties file that android/app/build.gradle reads.
#
# Usage:  ./scripts/generate_release_keystore.sh
# Then add the generated android/private/release.keystore + keystore.properties
# to your CI secrets (KEYSTORE_FILE, KEYSTORE_PASSWORD, KEY_ALIAS, KEY_PASSWORD).
set -euo pipefail

cd "$(dirname "$0")/.."

PRIVATE_DIR="android/private"
mkdir -p "$PRIVATE_DIR"

STORE="${PRIVATE_DIR}/release.keystore"
STORE_PASS="$(openssl rand -base64 32)"
KEY_ALIAS="upload"
KEY_PASS="$(openssl rand -base64 32)"

# User is prompted once; store keys in keystore.properties (gitignored).
keytool -genkeypair -v \
  -keystore "$STORE" \
  -alias "$KEY_ALIAS" \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -storepass "$STORE_PASS" \
  -keypass "$KEY_PASS" \
  -dname "CN=Upload Key, OU=Mobile, O=sk8er22, L=Unknown, ST=Unknown, C=US"

cat > "$PRIVATE_DIR/keystore.properties" <<EOF
keystoreFile=$STORE
keystorePassword=$STORE_PASS
keyAlias=$KEY_ALIAS
keyPassword=$KEY_PASS
EOF

chmod 600 "$PRIVATE_DIR/keystore.properties" "$STORE"

echo "✅ Release keystore created: $STORE"
echo "✅ Config written to: $PRIVATE_DIR/keystore.properties (KEYS BELOW - KEEP SECRET)"
grep -E "keystorePassword|keyPassword" "$PRIVATE_DIR/keystore.properties"
echo ""
echo "Add these as GitHub Actions secrets:"
echo "  KEYSTORE_FILE       = path to release.keystore inside the runner"
echo "  KEYSTORE_PASSWORD   = $STORE_PASS"
echo "  KEY_ALIAS           = $KEY_ALIAS"
echo "  KEY_PASSWORD        = $KEY_PASS"
