#!/bin/bash
# Desinstala Coffy (y la versión anterior, «Tapa Cerrada», si queda algo) y deja el reposo como estaba.
set -uo pipefail
cd "$(dirname "$0")"
echo "Cerrando Coffy…"
launchctl bootout "gui/$(id -u)/com.alejandro.coffy.agent" 2>/dev/null || true
pkill -x Coffy 2>/dev/null || true
sleep 1
[ -x scripts/remove-legacy.sh ] && scripts/remove-legacy.sh
echo "Restaurando el reposo y quitando el permiso (pide tu contraseña)…"
sudo /usr/bin/pmset -a disablesleep 0
sudo /bin/rm -f /etc/sudoers.d/coffy /etc/sudoers.d/tapacerrada
for D in /Applications "$HOME/Applications"; do
  [ -d "$D/Coffy.app" ] && rm -rf "$D/Coffy.app" && echo "Borrada $D/Coffy.app"
done
defaults delete com.alejandro.coffy 2>/dev/null || true
rm -f "$HOME/Library/Logs/Coffy.log"
echo "Hecho. Si aparece en Ajustes > General > Ítems de inicio, ya puedes ignorarlo: desaparecerá solo."
