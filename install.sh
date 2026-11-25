#!/bin/bash
# Instala Coffy compilándola desde el código (no necesita Gatekeeper ni descargas de binarios).
# Si tenías la versión anterior («Tapa Cerrada»), la quita antes.
# Uso:  ./install.sh            (desde una copia del repositorio)
set -euo pipefail
cd "$(dirname "$0")"

if ! xcrun --find swiftc >/dev/null 2>&1; then
  echo "Hacen falta las herramientas de desarrollo de Apple. Se va a abrir el instalador;"
  echo "cuando termine, vuelve a ejecutar ./install.sh"
  xcode-select --install || true
  exit 1
fi

scripts/build-app.sh
scripts/remove-legacy.sh
DEST=/Applications
[ -w "$DEST" ] || DEST="$HOME/Applications"
mkdir -p "$DEST"
pkill -x Coffy 2>/dev/null || true     # al cerrarse restaura el reposo normal
sleep 1
rm -rf "$DEST/Coffy.app"
cp -R "build/Coffy.app" "$DEST/"
open "$DEST/Coffy.app"
echo
echo "Listo: Coffy está en $DEST y en la barra de menús (icono de taza)."
echo "La primera vez te pedirá la contraseña de administrador una sola vez."
