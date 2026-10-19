# Video wallpapers (mpvpaper)

Colección de wallpapers animados optimizados a **1080p @ 30 FPS** con bajo consumo de GPU. Aparecen automáticamente en el selector de fondos de Clavis.

Requiere `mpvpaper` (preferiblemente `mpvpaper-git` >= 1.9) y `ffmpeg`.

## Agregar nuevos fondos

Para agregar un nuevo vídeo optimizado:

```bash
optimize-wallpaper /ruta/al/nuevo_video.mp4
```

El script lo reescala automáticamente a 1080p @ 30 FPS con aceleración Intel QuickSync/VA-API (o fallback CPU con libx264), elimina audio y lo coloca en este directorio.
