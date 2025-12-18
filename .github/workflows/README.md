# 🚀 GitHub Actions - Compilación y Release Automático

Este proyecto utiliza GitHub Actions para compilar automáticamente el APK y AAB de Android, y crear releases automáticos.

## 📋 ¿Qué hace el workflow?

El workflow `android_build.yaml` se ejecuta automáticamente en los siguientes casos:

1. **Push a la rama `main`**: Cada vez que subes código a la rama principal
2. **Pull Requests a `main`**: Cuando se crea un PR hacia la rama principal

## 🔧 Pasos del workflow

### 1. **Checkout del código**
Descarga el código del repositorio para que el workflow tenga acceso a él.

### 2. **Setup Java 17**
Configura el entorno Java requerido (Zulu distribution).

### 3. **Setup Flutter 3.24.5**
Instala Flutter en la versión estable especificada con cache habilitado.

### 4. **Instalar dependencias**
Ejecuta `flutter pub get` para resolver todas las dependencias.

### 5. **Análisis de código**
Ejecuta `flutter analyze` (continúa si hay errores).

### 6. **Tests**
Ejecuta `flutter test` (continúa si hay errores).

### 7. **Compilar APK**
Ejecuta `flutter build apk --release` para generar el APK de producción.

### 8. **Compilar App Bundle (AAB)**
Ejecuta `flutter build appbundle --release` para generar el AAB de producción.

### 9. **Subir artefactos**
Sube el APK y AAB como artefactos de GitHub para descarga.

### 10. **Extraer versión**
Lee la versión del archivo `pubspec.yaml` automáticamente.

### 11. **Verificar etiqueta**
Comprueba si ya existe un release con esa versión.

### 12. **Modificar etiqueta**
Si la etiqueta existe, agrega `-build-<número>` para hacerla única.

### 13. **Crear Release**
Crea un release automático en GitHub con el APK y AAB adjuntos (solo en push a main).

---

## 📦 Descargar el APK/AAB compilado

### Opción 1: Desde Actions (Artefactos)
1. Ve a la pestaña **Actions** en GitHub
2. Selecciona el workflow más reciente
3. Descarga el artefacto `Releases`
4. Descomprime para obtener el APK y AAB

### Opción 2: Desde Releases
1. Ve a la pestaña **Releases** en GitHub
2. Descarga el APK o AAB adjunto al release
3. El nombre incluye la versión: `control-gastos-v1.0.0.apk`

---

## 🏷️ Versionado Automático

El workflow extrae automáticamente la versión del archivo `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

- **Tag del release**: `v1.0.0`
- **Si el tag existe**: Se modifica a `v1.0.0-build-123`

Para crear una nueva versión:
1. Actualiza el `version` en `pubspec.yaml`
2. Haz commit y push
3. El workflow creará automáticamente el release

---

## ⚙️ Configuración

### Versiones utilizadas:
- **Flutter**: 3.24.5 (stable)
- **Java**: 17 (Zulu)
- **Plataforma**: Ubuntu latest
- **Cache**: Habilitado para Flutter

### Artefactos generados:
- `app-release.apk` - APK de producción
- `app-release.aab` - App Bundle de producción

---

## 🔍 Solución de problemas

### El workflow falla en `flutter analyze`
- El análisis continúa aunque haya errores (`continue-on-error: true`)
- Revisa los warnings en la pestaña Actions
- Los errores no bloquean la compilación

### El workflow falla en `flutter test`
- Los tests continúan aunque fallen (`continue-on-error: true`)
- Agrega tests en el directorio `test/`
- Los errores no bloquean la compilación

### El APK no se genera
- Verifica que el archivo `pubspec.yaml` esté correcto
- Asegúrate de que todas las dependencias estén disponibles
- Revisa los logs en la pestaña Actions
- Verifica que `android/build.gradle` tenga la configuración correcta

### El release no se crea
- Los releases solo se crean en **push a main**
- No se crean en Pull Requests
- Verifica que `GITHUB_TOKEN` tenga permisos

---

## 📝 Notas importantes

- ✅ El APK generado es de tipo **release** (optimizado y firmado con debug key)
- ✅ El AAB es para publicación en Google Play Store
- ✅ Los artefactos se conservan por 90 días
- ✅ Los releases son permanentes
- ✅ El versionado es automático desde `pubspec.yaml`
- ✅ Si la versión ya existe, se agrega un sufijo único

---

## 🚀 Flujo de trabajo típico

1. **Desarrollas** tu feature en una rama
2. **Haces PR** a `main` → El workflow compila y verifica
3. **Merges** el PR → El workflow compila, sube artefactos y crea release
4. **Descargas** el APK/AAB desde Releases o Artifacts
5. **Distribuyes** o publicas en Google Play Store

---

## 🔗 Enlaces útiles

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Build APK](https://docs.flutter.dev/deployment/android)
- [Flutter GitHub Actions](https://github.com/marketplace/actions/flutter-action)
- [Release Action](https://github.com/ncipollo/release-action)

---

## 📊 Estado del Build

Puedes ver el estado del último build en:
`https://github.com/yeison1124/control-gastos-app/actions`

Badge del workflow:
```markdown
![Build & Release](https://github.com/yeison1124/control-gastos-app/workflows/Build%20&%20Release/badge.svg)
```
