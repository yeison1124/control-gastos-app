# 🚀 GitHub Actions - Compilación Automática de APK

Este proyecto utiliza GitHub Actions para compilar automáticamente el APK de Android.

## 📋 ¿Qué hace el workflow?

El workflow `android_build.yaml` se ejecuta automáticamente en los siguientes casos:

1. **Push a la rama `main`**: Cada vez que subes código a la rama principal
2. **Pull Requests**: Cuando se crea un PR hacia `main`
3. **Releases**: Cuando creas un nuevo release en GitHub

## 🔧 Pasos del workflow

1. **Checkout del código**: Descarga el código del repositorio
2. **Setup Java 17**: Instala Java (requerido para Flutter)
3. **Setup Flutter 3.24.5**: Instala Flutter en la versión estable
4. **Obtener dependencias**: Ejecuta `flutter pub get`
5. **Análisis de código**: Ejecuta `flutter analyze` (continúa si hay errores)
6. **Tests**: Ejecuta `flutter test` (continúa si hay errores)
7. **Compilar APK**: Ejecuta `flutter build apk --release`
8. **Subir artefacto**: Sube el APK como artefacto de GitHub
9. **Subir a Release**: Si es un release, adjunta el APK automáticamente

## 📦 Descargar el APK compilado

### Opción 1: Desde Actions
1. Ve a la pestaña **Actions** en GitHub
2. Selecciona el workflow más reciente
3. Descarga el artefacto `app-release`

### Opción 2: Desde Releases
1. Ve a la pestaña **Releases** en GitHub
2. Descarga el APK adjunto al release

## 🏷️ Crear un Release

Para crear un release y generar un APK automáticamente:

```bash
# Crear un tag
git tag v1.0.0

# Subir el tag
git push origin v1.0.0
```

Luego en GitHub:
1. Ve a **Releases** → **Draft a new release**
2. Selecciona el tag `v1.0.0`
3. Completa título y descripción
4. Publica el release

El APK se compilará y adjuntará automáticamente.

## ⚙️ Configuración

El workflow está configurado para:
- **Flutter**: 3.24.5 (stable)
- **Java**: 17 (Zulu)
- **Plataforma**: Ubuntu latest
- **Cache**: Habilitado para Flutter

## 🔍 Solución de problemas

### El workflow falla en `flutter analyze`
- El análisis continúa aunque haya errores (`continue-on-error: true`)
- Revisa los warnings en la pestaña Actions

### El workflow falla en `flutter test`
- Los tests continúan aunque fallen (`continue-on-error: true`)
- Agrega tests en el directorio `test/`

### El APK no se genera
- Verifica que el archivo `pubspec.yaml` esté correcto
- Asegúrate de que todas las dependencias estén disponibles
- Revisa los logs en la pestaña Actions

## 📝 Notas

- El APK generado es de tipo **release** (optimizado)
- El archivo se llama `app-release.apk`
- En releases, el nombre incluye el tag: `control-gastos-v1.0.0.apk`
- Los artefactos se conservan por 90 días (configuración por defecto de GitHub)

## 🔗 Enlaces útiles

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Build APK](https://docs.flutter.dev/deployment/android)
- [Flutter GitHub Actions](https://github.com/marketplace/actions/flutter-action)
