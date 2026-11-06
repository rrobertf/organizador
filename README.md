# Organizador de Archivos

Organiza archivos por extensión con Bash 3.2+ (macOS y Linux). No requiere paquetes adicionales.

```bash
bash organizador.sh --dry-run "$HOME/Downloads"
bash organizador.sh "$HOME/Downloads"
# Sin argumento usa ~/Downloads
bash organizador.sh
python3 -m unittest discover -s tests -v
```

| Carpeta | Extensiones |
|---|---|
| Imagenes | jpg, jpeg, png, gif, webp |
| Documentos | pdf, docx, doc, txt, xlsx |
| Videos | mp4, mov, avi |
| Codigo | js, py, cpp, html, css |
| Otros | Resto de archivos |

Reconoce mayúsculas y nombres con espacios. Solo procesa archivos del primer nivel; no recorre subcarpetas ni mueve archivos ocultos o enlaces simbólicos. Los destinos no pueden ser enlaces simbólicos.

Si el nombre ya existe en destino, **conserva ambos archivos sin sobrescribir** y deja el archivo de origen donde estaba. `--dry-run` muestra lo que haría sin mover archivos ni crear carpetas. La carpeta de origen debe existir; los errores terminan con un código distinto de cero. Los movimientos y omisiones se muestran en consola; puedes redirigir esa salida si necesitas un registro.

No organiza por fecha. Ejecútalo sobre carpetas bajo tu control, sin procesos que cambien simultáneamente sus archivos o destinos. Revisa primero la vista previa: la versión actual también coloca extensiones desconocidas en `Otros`.

**Roberto Feliciano** — [GitHub](https://github.com/rrobertf)
