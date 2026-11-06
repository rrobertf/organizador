#!/usr/bin/env bash
# Compatible con Bash 3.2 (macOS) y Bash en Linux.
set -euo pipefail

DRY_RUN=false
if [ "${1:-}" = '--dry-run' ]; then
  DRY_RUN=true
  shift
fi
if [ "$#" -gt 1 ] || [ "${1:-}" = '--help' ]; then
  printf 'Uso: bash organizador.sh [--dry-run] [carpeta]\n'
  [ "${1:-}" = '--help' ] && exit 0
  exit 1
fi
CARPETA="${1:-$HOME/Downloads}"
if [ ! -d "$CARPETA" ] || [ -L "$CARPETA" ]; then
  printf 'La carpeta debe existir y no ser un enlace simbólico: %s\n' "$CARPETA" >&2
  exit 1
fi
# Canonical absolute paths also prevent option-like filenames from reaching mv.
CARPETA=$(cd "$CARPETA" && pwd -P)
for categoria in Imagenes Documentos Videos Codigo Otros; do
  destino="$CARPETA/$categoria"
  if [ -L "$destino" ] || { [ -e "$destino" ] && [ ! -d "$destino" ]; }; then
    printf 'Destino inseguro: %s\n' "$destino" >&2
    exit 1
  fi
done

shopt -s nullglob nocaseglob
for archivo in "$CARPETA"/*; do
  [ -f "$archivo" ] && [ ! -L "$archivo" ] || continue
  nombre=${archivo##*/}
  # Lowercase extension without Bash 4-only syntax.
  extension=$(printf '%s' "${nombre##*.}" | tr '[:upper:]' '[:lower:]')
  case "$extension" in
    jpg|jpeg|png|gif|webp) categoria=Imagenes ;;
    pdf|docx|doc|txt|xlsx) categoria=Documentos ;;
    mp4|mov|avi) categoria=Videos ;;
    js|py|cpp|html|css) categoria=Codigo ;;
    *) categoria=Otros ;;
  esac
  destino="$CARPETA/$categoria/$nombre"
  if [ -e "$destino" ] || [ -L "$destino" ]; then
    printf 'Omitido (ya existe): %s\n' "$destino"
    continue
  fi
  if "$DRY_RUN"; then
    printf 'Vista previa: %s → %s\n' "$archivo" "$destino"
  else
    mkdir -p "$CARPETA/$categoria"
    # -n protects against a destination appearing after the existence check.
    mv -n "$archivo" "$destino"
    if [ -e "$archivo" ]; then
      printf 'Omitido (colisión): %s\n' "$archivo"
    else
      printf 'Movido: %s → %s\n' "$archivo" "$destino"
    fi
  fi
done
printf 'Listo.\n'
