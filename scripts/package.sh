#!/bin/bash
# Crea dist/Coffy-<versión>.zip listo para subir a GitHub Releases.
set -euo pipefail
cd "$(dirname "$0")/.."
VERSION="${1:-$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' Resources/Info.plist)}"
VERSION="${VERSION#v}"
scripts/build-app.sh "$VERSION"
mkdir -p dist
ZIP="dist/Coffy-$VERSION.zip"
rm -f "$ZIP"
ditto -c -k --sequesterRsrc --keepParent "build/Coffy.app" "$ZIP"
shasum -a 256 "$ZIP"
echo "== Paquete: $ZIP"
