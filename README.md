<p align="center">
  <img src="docs/icon.png" width="128" alt="Icono de Coffy">
</p>

<h1 align="center">Coffy</h1>

<p align="center">
  Cierra la tapa de tu MacBook, conecta una pantalla y sigue trabajando.<br>
  Sin abrir el portátil, sin tocar nada.
</p>

<p align="center"><i>Antes se llamaba «Tapa Cerrada». English summary at the bottom.</i></p>

---

## Qué hace

macOS solo usa el modo «tapa cerrada» si el Mac ya está enchufado y con pantalla
antes de cerrar la tapa. Si lo cierras primero, se duerme y te toca abrirlo otra vez.
Apps como Amphetamine lo arreglan a medias: hay que abrir el Mac y activar una sesión.

**Coffy** vive en la barra de menús y lo decide sola:

| Situación | Qué hace |
|---|---|
| Hay una pantalla externa conectada | No se duerme, aunque cierres la tapa |
| Cierras la tapa sin pantalla | Te da un margen (5 min por defecto) para conectarla; si no, se duerme |
| Con cargador (opcional) | Puede esperar la pantalla con la tapa cerrada sin límite de tiempo |
| No lo usas (con o sin pantalla externa) | Se duerme por inactividad con el tiempo de tus Ajustes (salvo vídeo, música o descargas) |
| Batería por debajo del mínimo (15 %) | Sin pantalla: reposo normal. Con pantalla: te avisa y solo lo duerme al llegar al 5 % |
| Cierras la app | Se restaura siempre el reposo normal |

El icono de la taza se rellena cuando el reposo está bloqueado.

## Instalación

Requiere un **MacBook** con **macOS 14 Sonoma o posterior**, Apple Silicon o Intel.

### Opción A: descargar la app

1. Descarga el `.zip` de la última versión en [Releases](../../releases).
2. Descomprímelo y arrastra **Coffy** a **Aplicaciones**.
3. Ábrela. Como la app no está firmada con una cuenta de desarrollador de Apple,
   macOS la bloqueará la primera vez:
   - Ve a **Ajustes del Sistema → Privacidad y seguridad** y pulsa **Abrir igualmente**, o
   - en Terminal: `xattr -dr com.apple.quarantine "/Applications/Coffy.app"`

### Opción B: compilar desde el código

Necesitas las herramientas de desarrollo de Apple (`xcode-select --install`).

```bash
git clone https://github.com/amaestra205/coffy.git
cd coffy
./install.sh
```

### Si tenías «Tapa Cerrada»

`install.sh` (y `build.command`) cierran y borran la versión anterior antes de
instalar Coffy. Su permiso de administrador (`/etc/sudoers.d/tapacerrada`) se borra
solo cuando le das el permiso a Coffy. Si descargas el `.zip`, al abrir Coffy se
cierra la versión anterior; bórrala de Aplicaciones a mano.

### Primer arranque

- Te pedirá **tu contraseña una sola vez** (ver [Seguridad](#seguridad)).
- Te pedirá permiso para **notificaciones** (solo se usan para avisar de batería baja).
- Se añade sola a los ítems de inicio de sesión. Si macOS avisa de un
  «ítem en segundo plano», acéptalo.

## Opciones del menú

- **Activado**: interruptor general.
- **Margen con la tapa cerrada sin pantalla**: ninguno, 2, 5, 10, 15 o 30 min.
- **Con cargador, esperar la pantalla sin límite**: desactivado por defecto para que
  no se quede despierto toda la noche si lo cargas con la tapa cerrada.
- **Reposo por inactividad**: por defecto, el mismo tiempo que en Ajustes del
  Sistema (el mayor entre «apagar pantalla» y «reposo»). Vale también con pantalla
  externa; elige **Nunca** si no quieres que se duerma nunca mientras la usas.
- **Dormir si la batería baja de…** (con pantalla externa solo avisa hasta el 5 %).
- **Despertar al conectar el cargador**: si tu Mac lo admite. Sirve para
  cuando ya estaba dormido del todo. Solo aparece con el permiso instalado.
- **Dormir ahora**: mientras la app tiene el reposo bloqueado, «Reposo» del
  menú Apple no funciona; usa esta opción.
- **Ver registro**: `~/Library/Logs/Coffy.log`.

## Seguridad

Para impedir el reposo con la tapa cerrada hay que cambiar el ajuste del sistema
`pmset disablesleep`, que requiere permisos de administrador. En lugar de ejecutar
un servicio con privilegios, la app instala (con tu contraseña, una vez) el fichero
`/etc/sudoers.d/coffy`, que solo permite estos comandos exactos a tu usuario:

```
/usr/bin/pmset -a disablesleep 0
/usr/bin/pmset -a disablesleep 1
/usr/bin/pmset -a acwake 0
/usr/bin/pmset -a acwake 1
```

Puedes quitarlo cuando quieras desde el menú (**Quitar permiso de administrador…**)
o con `uninstall.sh`.

> ⚠️ Con la tapa cerrada el Mac se refrigera peor. No lo metas en una mochila con
> el reposo bloqueado durante mucho rato: para eso el margen es corto por defecto.

## Desinstalar

```bash
./uninstall.sh
```

O a mano: menú → *Quitar permiso de administrador…*, *Salir*, y borra la app de Aplicaciones.

## Desarrollo

```
Sources/            Código Swift (AppKit, IOKit, ServiceManagement, UserNotifications)
  App.swift         Barra de menús, permisos, inicio de sesión y migración desde Tapa Cerrada
  Controller.swift  Lógica: cuándo bloquear el reposo y cuándo dormir
  Support.swift     Lectura de tapa, pantallas, batería; pmset; ajustes; registro; avisos
Resources/          Info.plist, icono y LaunchAgent
scripts/            build-app.sh (compila .app universal), package.sh (crea el .zip),
                    remove-legacy.sh (quita la versión anterior)
build.command       Doble clic: compila, instala y abre (desarrollo)
```

Publicar una versión: sube un tag y GitHub Actions compila y adjunta el `.zip`
a la release.

```bash
git tag v2.0.0 && git push origin v2.0.0
```

## Cambios

### 2.0.0
- Nuevo nombre: **Coffy** (antes «Tapa Cerrada»). Migra sola desde la versión anterior.
- Con pantalla externa también se duerme por inactividad (antes no se dormía nunca
  y en batería la vaciaba hasta el mínimo).
- El tiempo de inactividad «como en Ajustes» usa el mayor entre «apagar pantalla» y
  «reposo» (antes podía dormirse al minuto en batería).
- Con pantalla externa y batería baja avisa con una notificación y no duerme el Mac
  hasta el 5 %.
- El registro en el inicio de sesión se reintenta si la primera vez falló.
- «Despertar al conectar el cargador» solo aparece cuando hay permiso.

## Licencia

MIT. Mira [LICENSE](LICENSE).

---

## English summary

**Coffy** (formerly "Tapa Cerrada") is a small menu bar app for macOS 14+ that lets you
close your MacBook's lid, plug in an external display and keep working, without
opening the laptop first. It keeps the Mac awake (`pmset disablesleep`) while an
external display or the charger is connected, gives you a short grace period on
battery to plug the display in, still sleeps when idle, and otherwise falls back to
normal sleep. It asks for your admin password once to install a narrowly scoped
sudoers rule. Install from [Releases](../../releases) or run `./install.sh` from a clone.
The UI is in Spanish.
