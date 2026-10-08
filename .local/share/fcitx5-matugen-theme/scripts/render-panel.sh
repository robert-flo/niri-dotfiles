#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    printf 'Usage: %s INPUT.svg OUTPUT.png\n' "$0" >&2
    exit 2
fi

# Rasterize at the SVG's intrinsic size: theme margins use these same pixels.
# Publish only a complete PNG, keeping the previous background on failure.
temporary=$(mktemp -- "${2}.XXXXXX")
trap 'rm -f -- "$temporary"' EXIT
rsvg-convert --format=png --output="$temporary" -- "$1"
mv -f -- "$temporary" "$2"
