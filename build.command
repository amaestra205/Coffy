#!/bin/bash
# Doble clic: compila, quita la versión anterior (Tapa Cerrada) si estaba, instala en Aplicaciones y abre Coffy.
cd "$(dirname "$0")"
LOG="$PWD/build.log"
(
  set -e
  echo "== $(date '+%H:%M:%S')"
  scripts/build-app.sh
  scripts/remove-legacy.sh
  DEST=/Applications
  [ -w "$DEST" ] || DEST="$HOME/Applications"
  mkdir -p "$DEST"
  pkill -x Coffy || true      # al cerrarse restaura el reposo normal
  sleep 1
  rm -rf "$DEST/Coffy.app"
  cp -R "build/Coffy.app" "$DEST/"
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$DEST/Coffy.app" || true
  echo "$DEST" > build/.dest
  echo "== BUILD_OK $(date '+%H:%M:%S')"
) > "$LOG" 2>&1
if grep -q BUILD_OK "$LOG"; then
  open "$(cat build/.dest)/Coffy.app"
  echo "Coffy instalada y abierta (icono de taza en la barra de menús)."
else
  echo "Ha fallado la compilación. Detalle en build.log:"
  tail -40 "$LOG"
fi
exit 0
