#!/bin/bash

CARPETA="$HOME/Downloads"

echo "Organizando archivos en $CARPETA..."

mkdir -p "$CARPETA/Imagenes"
mkdir -p "$CARPETA/Documentos"
mkdir -p "$CARPETA/Videos"
mkdir -p "$CARPETA/Codigo"
mkdir -p "$CARPETA/Otros"

for f in "$CARPETA"/*.jpg "$CARPETA"/*.jpeg "$CARPETA"/*.png "$CARPETA"/*.gif "$CARPETA"/*.webp; do
  [ -f "$f" ] && mv "$f" "$CARPETA/Imagenes/" && echo "Movido imagen: $(basename $f)"
done

for f in "$CARPETA"/*.pdf "$CARPETA"/*.docx "$CARPETA"/*.doc "$CARPETA"/*.txt "$CARPETA"/*.xlsx; do
  [ -f "$f" ] && mv "$f" "$CARPETA/Documentos/" && echo "Movido documento: $(basename $f)"
done

for f in "$CARPETA"/*.mp4 "$CARPETA"/*.mov "$CARPETA"/*.avi; do
  [ -f "$f" ] && mv "$f" "$CARPETA/Videos/" && echo "Movido video: $(basename $f)"
done

for f in "$CARPETA"/*.js "$CARPETA"/*.py "$CARPETA"/*.cpp "$CARPETA"/*.html "$CARPETA"/*.css; do
  [ -f "$f" ] && mv "$f" "$CARPETA/Codigo/" && echo "Movido codigo: $(basename $f)"
done

echo ""
echo "Listo! Archivos organizados."