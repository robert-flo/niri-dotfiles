# niri-dotfiles

Configuración de un escritorio **niri + Clavis** (Quickshell) sobre Arch Linux / Omarchy, con estética tipo macOS (MacTahoe), colores dinámicos generados desde el wallpaper (Matugen) y temas por aplicación.

> Basado en el escritorio de **[StatIndet](https://github.com/StatIndet)** presentado en [r/unixporn](https://www.reddit.com/r/unixporn/s/4QCJSEDKQ7). Ver [Créditos y atribución](#créditos-y-atribución).

▶️ **Showcase:** [`.github/showcase.mp4`](.github/showcase.mp4)

Repositorio *bare* gestionado con [dotbare](https://github.com/kazhala/dotbare): los archivos viven en su lugar dentro de `$HOME`.

## Qué incluye

| Ruta | Contenido |
|---|---|
| `.config/niri/` | `config.kdl`, fragmentos gestionados por Clavis (`clavis/*.kdl`), cursor, animaciones spring, focus ring con degradado, reglas de blur para Obsidian y Thunderbird |
| `.config/clavis/` | `config.json` de Clavis y registro de plantillas Matugen propias (`matugen/config.toml`) |
| `.local/share/statindet-niri/`, `.local/share/fcitx5-matugen-theme/`, `.local/share/clavis-fish-theme/` | plantillas Matugen: focus ring de niri, tema de fcitx5 y prompt de fish |
| `.config/mpv/` | mpv con interfaz uosc personalizada (`hwdec=vaapi`) |
| `.config/gtk-3.0/`, `.config/gtk-4.0/` | tema GTK MacTahoe-Dark (incluido libadwaita) y botones de ventana a la izquierda |
| `.config/environment.d/` | `QT_QPA_PLATFORMTHEME=gtk3` |
| `.config/fcitx5/conf/classicui.conf` | fcitx5 con el tema Matugen |
| `.config/fish/`, `.config/alacritty/`, `.bashrc` | fish como shell de Alacritty con prompt de colores Matugen; bash carga el entorno Omarchy y, si existe, `CURSOR_API_KEY` |
| `.config/thunderbird/` | perfil con tema CSS (`chrome/`) y `user.js` (solo tema, sin datos de correo) |
| `.config/obsidian/`, `Documents/Notas/.obsidian/` | tema Violet de Obsidian (solo apariencia, sin notas) |
| `.local/share/clavis/wallpapers/` | dos wallpapers |
| `.icons/default/index.theme` | cursor MacTahoe por defecto para apps que no reciben `XCURSOR_THEME` |
| `.local/bin/niri-dotfiles-postinstall` | pasos posteriores a la instalación (ver abajo) |

## Requisitos

- `niri` (fork con minimizar y `background-effect blur`) y la shell **Clavis** con su CLI `key`.
- Temas globales MacTahoe: iconos (`MacTahoe-dark`), cursores (`MacTahoe-dark-cursors`) y GTK (`MacTahoe-Dark`).
- Paquetes: `mpv`, `thunderbird`, `obsidian`, `fish`, `alacritty`, `fcitx5`, `matugen`, `ttf-lxgw-wenkai-screen`, `ttf-jetbrains-mono-nerd`.

## Instalación

```bash
# requiere dotbare (AUR: yay -S dotbare)
export DOTBARE_DIR="$HOME/.cfg" DOTBARE_TREE="$HOME"
dotbare finit -u https://github.com/robert-flo/niri-dotfiles.git
```

`finit -u` respalda los archivos existentes que entren en conflicto (en `~/.local/share/dotbare/`) antes de hacer checkout.

Después, una vez:

```bash
~/.local/bin/niri-dotfiles-postinstall
```

El script es idempotente y hace lo que no puede vivir en archivos versionados:

- adapta a tu `$HOME` las rutas absolutas de `~/.config/clavis/config.json` (wallpaper) y `~/.config/obsidian/obsidian.json` (vault);
- aplica `gsettings`: tema GTK, iconos, cursor, modo oscuro y botones a la izquierda;
- habilita los servicios de usuario `clavis-shell.service` y `clavis-clipboard.service` (son los que arrancan la barra y el portapapeles; `config.kdl` no los lanza para no duplicar la barra);
- crea `~/Pictures/mpv` (capturas de mpv);
- genera los colores Matugen desde el wallpaper (focus ring de niri, fcitx5 y fish);
- valida la configuración de niri.

Si se ejecuta fuera de una sesión gráfica, avisa de lo que no pudo aplicar; basta con volver a ejecutarlo dentro de la sesión. Al cambiar el wallpaper desde Clavis, los colores se regeneran solos.

## Notas

- `~/.config/niri/clavis/*.kdl` los gestiona Clavis desde su configuración; no editarlos a mano.
- El perfil de Thunderbird debe coincidir con `[Install…] Default=` de `~/.config/thunderbird/installs.ini`.
- Para el CLI/SDK de Cursor, guarda la key en `~/.config/cursor/api-key` con `chmod 600`. Fish y bash la cargan en `CURSOR_API_KEY` solo si el archivo existe; `.config/cursor/` está en `.gitignore`.

## Créditos y atribución

La idea, el diseño y la mayor parte de las piezas de este escritorio son obra de **[StatIndet](https://github.com/StatIndet)**, que lo mostró en Reddit:
**[niri: my new desktop — r/unixporn](https://www.reddit.com/r/unixporn/s/4QCJSEDKQ7)**.

Este repositorio no es un fork: reúne en una sola configuración piezas de varios proyectos, adaptadas e integradas en un sistema Omarchy / Arch. Todo el mérito del diseño original corresponde a sus autores.

Del autor original:

| Proyecto | Uso aquí |
|---|---|
| [StatIndet/quickshell](https://github.com/StatIndet/quickshell) (Clavis) y [StatIndet/key-cli](https://github.com/StatIndet/key-cli) | shell de escritorio y su CLI `key` |
| [StatIndet/niri-edge](https://github.com/StatIndet/niri-edge) | fork de niri con minimizar (Scale/Genie) y blur |
| [StatIndet/dotfiles](https://github.com/StatIndet/dotfiles) | animaciones de niri, plantilla del focus ring, `QT_QPA_PLATFORMTHEME` |
| [StatIndet/mpv](https://github.com/StatIndet/mpv) | configuración de mpv y uosc personalizado |
| [StatIndet/obsidian-violet](https://github.com/StatIndet/obsidian-violet) | tema Violet de Obsidian |
| [StatIndet/liquidbird](https://github.com/StatIndet/liquidbird) | tema LiquidBird de Thunderbird |
| [StatIndet/fcitx5-matugen-theme](https://github.com/StatIndet/fcitx5-matugen-theme) | tema de fcitx5 con colores Matugen |
| [StatIndet/clavis-fish-theme](https://github.com/StatIndet/clavis-fish-theme) | prompt de fish con colores Matugen |
| [StatIndet/wallpaper](https://github.com/StatIndet/wallpaper) | colección de wallpapers |

Otros proyectos:

| Proyecto | Uso aquí |
|---|---|
| [niri](https://github.com/YaLTeR/niri) | compositor Wayland base de niri-edge |
| [Quickshell](https://quickshell.org) | toolkit QML sobre el que corre Clavis |
| [Matugen](https://github.com/InioX/matugen) | generación de colores desde el wallpaper |
| [uosc](https://github.com/tomasklaen/uosc) | interfaz de mpv |
| [MacTahoe icon / cursor](https://github.com/vinceliuice/MacTahoe-icon-theme) y [MacTahoe GTK](https://github.com/vinceliuice/MacTahoe-gtk-theme) | iconos, cursores y tema GTK/libadwaita |
| [dotbare](https://github.com/kazhala/dotbare) | gestión de estos dotfiles |
| [Wallhaven 5y3571](https://wallhaven.cc/w/5y3571) y [Wallhaven rq6yqm](https://wallhaven.cc/w/rq6yqm) | wallpapers incluidos |

Los archivos de terceros conservan sus licencias originales (por ejemplo, GPL-3.0 en `fcitx5-matugen-theme` y en los iconos MacTahoe, MIT en el tema GTK MacTahoe, LGPL-2.1 en uosc); consultar cada proyecto.
