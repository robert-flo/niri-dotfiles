#!/usr/bin/env bash
# Optimiza vídeos para fondos de pantalla (1080p, 30 FPS, sin audio, aceleración por hardware Intel VA-API).
set -euo pipefail

WP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/clavis/wallpapers/video"
ORIGINALS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/clavis/wallpapers/video_originals"

usage() {
    echo "Uso: $0 <ruta-al-video> [ruta-de-salida]"
    echo ""
    echo "Ejemplos:"
    echo "  $0 ~/Downloads/nuevo_fondo.mp4"
    echo "  -> Optimiza a 1080p @ 30fps, guarda respaldo en video_originals/ y coloca el optimizado en $WP_DIR"
    exit 1
}

if [[ $# -lt 1 ]]; then
    usage
fi

INPUT="$1"
if [[ ! -f "$INPUT" ]]; then
    echo "ERROR: El archivo de vídeo '$INPUT' no existe." >&2
    exit 1
fi

mkdir -p "$WP_DIR" "$ORIGINALS_DIR"

BASENAME="$(basename "$INPUT")"
OUTPUT="${2:-$WP_DIR/$BASENAME}"
TMP_OUTPUT="$(mktemp "/tmp/opt_XXXXXX_${BASENAME}")"

trap 'rm -f "$TMP_OUTPUT"' EXIT

echo "==> Analizando vídeo origen: '$INPUT'..."
if command -v ffprobe >/dev/null 2>&1; then
    ffprobe -v error -select_streams v:0 -show_entries stream=width,height,r_frame_rate,codec_name -of default=noprint_wrappers=1 "$INPUT" || true
fi

# Respaldar original si no existe copia previa
BACKUP_FILE="$ORIGINALS_DIR/$BASENAME"
if [[ ! -f "$BACKUP_FILE" ]]; then
    if [[ "$(realpath "$INPUT")" != "$(realpath "$BACKUP_FILE")" ]]; then
        echo "==> Respaldando original en: $BACKUP_FILE"
        cp -p "$INPUT" "$BACKUP_FILE"
    fi
fi

echo "==> Optimizando a 1080p @ 30 FPS..."

ENCODE_SUCCESS=0
# Intentar codificación por hardware Intel QuickSync / VA-API
if [[ -e /dev/dri/renderD128 ]]; then
    echo "==> Procesando con aceleración por hardware Intel VA-API..."
    if ffmpeg -hide_banner -loglevel warning -stats \
        -vaapi_device /dev/dri/renderD128 \
        -i "$INPUT" \
        -vf "fps=30,format=nv12,hwupload,scale_vaapi=w=1920:h=1080" \
        -c:v h264_vaapi -b:v 6M -maxrate 8M -bufsize 12M \
        -an -y "$TMP_OUTPUT"; then
        ENCODE_SUCCESS=1
    else
        echo "AVISO: Falló la codificación VA-API, reintentando por software (libx264)..."
    fi
fi

# Fallback con libx264 si VA-API no está disponible
if [[ $ENCODE_SUCCESS -eq 0 ]]; then
    echo "==> Procesando por software CPU (libx264)..."
    ffmpeg -hide_banner -loglevel warning -stats \
        -i "$INPUT" \
        -vf "fps=30,scale=1920:1080:flags=bicubic" \
        -c:v libx264 -preset fast -crf 20 \
        -an -y "$TMP_OUTPUT"
fi

mv "$TMP_OUTPUT" "$OUTPUT"
chmod 644 "$OUTPUT"

echo ""
echo "==> ¡Listo! Vídeo optimizado con éxito:"
echo "    Destino: $OUTPUT"
ls -lh "$OUTPUT"
