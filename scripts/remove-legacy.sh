#!/bin/bash
# Quita la versión anterior de la app («Tapa Cerrada») sin pedir contraseña.
# Su permiso (/etc/sudoers.d/tapacerrada) lo borra Coffy al darle el suyo,
# o uninstall.sh. No falla si no estaba instalada.
set -uo pipefail
OLD_ID=com.alejandro.tapacerrada
found=0
if pgrep -x TapaCerrada >/dev/null 2>&1; then
  found=1
  launchctl bootout "gui/$(id -u)/$OLD_ID.agent" 2>/dev/null || true
  pkill -x TapaCerrada 2>/dev/null || true   # al cerrarse restaura el reposo normal
  sleep 1
fi
launchctl bootout "gui/$(id -u)/$OLD_ID.agent" 2>/dev/null || true
for D in /Applications "$HOME/Applications"; do
  if [ -d "$D/Tapa Cerrada.app" ]; then
    found=1
    rm -rf "$D/Tapa Cerrada.app" && echo "Borrada la versión anterior: $D/Tapa Cerrada.app"
  fi
done
defaults delete "$OLD_ID" 2>/dev/null || true
rm -f "$HOME/Library/Logs/TapaCerrada.log"
[ "$found" = 1 ] && echo "Versión anterior (Tapa Cerrada) quitada."
exit 0
