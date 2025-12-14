# 📤 Guía para Subir el Proyecto a GitHub

## ✅ Estado Actual

El repositorio Git local ya está inicializado y el primer commit está hecho con todos los archivos del proyecto.

```
✅ Git inicializado
✅ Archivos agregados
✅ Primer commit realizado
✅ README.md creado
✅ .gitignore configurado
```

---

## 🚀 Pasos para Subir a GitHub

### Paso 1: Crear Repositorio en GitHub

1. Ve a [github.com](https://github.com)
2. Inicia sesión en tu cuenta
3. Click en el botón **"+"** (arriba derecha) → **"New repository"**
4. Configura el repositorio:
   - **Repository name**: `control-de-gastos` (o el nombre que prefieras)
   - **Description**: "Aplicación móvil de control de gastos con Flutter"
   - **Visibility**: 
     - ✅ **Public** (recomendado para portfolio)
     - ⬜ Private (si prefieres mantenerlo privado)
   - ⚠️ **NO marques** "Initialize this repository with a README"
   - ⚠️ **NO agregues** .gitignore ni license (ya los tenemos)
5. Click en **"Create repository"**

### Paso 2: Conectar Repositorio Local con GitHub

GitHub te mostrará instrucciones. Usa estas:

#### Opción A: Si el repositorio está vacío (recomendado)

Ejecuta estos comandos en tu terminal:

```bash
# Agregar el remote de GitHub (reemplaza TU-USUARIO con tu nombre de usuario)
git remote add origin https://github.com/TU-USUARIO/control-de-gastos.git

# Renombrar la rama principal a 'main' (si es necesario)
git branch -M main

# Subir el código a GitHub
git push -u origin main
```

#### Opción B: Si ya tienes un repositorio con contenido

```bash
# Agregar el remote
git remote add origin https://github.com/TU-USUARIO/control-de-gastos.git

# Hacer pull primero
git pull origin main --allow-unrelated-histories

# Subir los cambios
git push -u origin main
```

### Paso 3: Verificar que se Subió Correctamente

1. Refresca la página de tu repositorio en GitHub
2. Deberías ver todos los archivos:
   - ✅ README.md
   - ✅ Carpeta `lib/` con todos los screens
   - ✅ Archivos de documentación (.md)
   - ✅ pubspec.yaml
   - ✅ Configuraciones de Android/iOS

---

## 🔧 Comandos Útiles de Git

### Ver el estado del repositorio
```bash
git status
```

### Ver el historial de commits
```bash
git log --oneline
```

### Ver los remotes configurados
```bash
git remote -v
```

### Hacer cambios futuros
```bash
# 1. Hacer cambios en los archivos
# 2. Agregar los cambios
git add .

# 3. Hacer commit
git commit -m "Descripción de los cambios"

# 4. Subir a GitHub
git push
```

---

## 📋 Checklist de Verificación

Antes de subir, verifica que tienes:

- [x] README.md completo y profesional
- [x] .gitignore configurado para Flutter
- [x] Documentación en archivos .md
- [x] Código organizado en carpetas
- [x] Commit inicial hecho
- [ ] Repositorio creado en GitHub
- [ ] Remote configurado
- [ ] Código subido a GitHub

---

## 🎯 Después de Subir a GitHub

### 1. Agregar Topics (Etiquetas)

En GitHub, ve a tu repositorio y agrega topics:
- `flutter`
- `dart`
- `expense-tracker`
- `finance-app`
- `mobile-app`
- `supabase`
- `neumorphic-design`

### 2. Agregar Descripción

En la página principal del repositorio, agrega una descripción corta:
```
💰 Aplicación móvil de control de gastos con Flutter - Diseño premium, análisis inteligente y funcionalidades avanzadas
```

### 3. Agregar Website (Opcional)

Si despliegas la app web, agrega el link aquí.

### 4. Configurar GitHub Pages (Opcional)

Para documentación:
1. Ve a Settings → Pages
2. Source: Deploy from a branch
3. Branch: main → /docs (si tienes carpeta docs)

### 5. Agregar Badges al README

Ya están incluidos en el README.md:
- Flutter version
- Dart version
- License
- Status

---

## 🔐 Autenticación con GitHub

### Si te pide credenciales:

#### Opción 1: Personal Access Token (Recomendado)

1. Ve a GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic)
3. Selecciona scopes: `repo` (todos)
4. Copia el token
5. Úsalo como contraseña cuando Git te lo pida

#### Opción 2: GitHub CLI

```bash
# Instalar GitHub CLI
winget install GitHub.cli

# Autenticarse
gh auth login

# Seguir las instrucciones
```

#### Opción 3: SSH

```bash
# Generar clave SSH
ssh-keygen -t ed25519 -C "tu-email@ejemplo.com"

# Copiar la clave pública
cat ~/.ssh/id_ed25519.pub

# Agregar en GitHub → Settings → SSH and GPG keys
```

---

## 📱 Migración a FlutterFlow (Siguiente Paso)

Una vez que el código esté en GitHub:

### Opción 1: Importar desde GitHub a FlutterFlow

1. En FlutterFlow, crea un nuevo proyecto
2. Ve a Settings → GitHub Integration
3. Conecta tu cuenta de GitHub
4. Selecciona el repositorio `control-de-gastos`
5. FlutterFlow importará el código

### Opción 2: Recrear en FlutterFlow

1. Usa el código como referencia
2. Sigue la guía en `FLUTTERFLOW_MIGRATION.md`
3. Crea las pantallas visualmente
4. Exporta el código de FlutterFlow
5. Combina con tu código existente

---

## 🎨 Personalizar el Repositorio

### Agregar Screenshots

1. Crea una carpeta `screenshots/` en la raíz
2. Agrega capturas de pantalla de la app
3. Actualiza el README.md con las imágenes:

```markdown
## 📸 Capturas

<div align="center">
  <img src="screenshots/home.png" width="250" />
  <img src="screenshots/calendar.png" width="250" />
  <img src="screenshots/graphs.png" width="250" />
</div>
```

### Agregar LICENSE

Crea un archivo `LICENSE` con la licencia MIT:

```
MIT License

Copyright (c) 2025 Tu Nombre

Permission is hereby granted, free of charge, to any person obtaining a copy...
```

### Agregar CONTRIBUTING.md

Si quieres que otros contribuyan:

```markdown
# Contribuir al Proyecto

¡Gracias por tu interés en contribuir!

## Cómo Contribuir

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request
```

---

## 🚨 Problemas Comunes

### Error: "remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/TU-USUARIO/control-de-gastos.git
```

### Error: "failed to push some refs"
```bash
git pull origin main --rebase
git push origin main
```

### Error: "Permission denied"
- Verifica tus credenciales
- Usa Personal Access Token
- O configura SSH

---

## ✅ Verificación Final

Después de subir, verifica en GitHub:

1. ✅ Todos los archivos están presentes
2. ✅ README.md se ve correctamente
3. ✅ La estructura de carpetas es correcta
4. ✅ Los badges funcionan
5. ✅ La documentación es accesible

---

## 🎯 Comando Completo (Copia y Pega)

Reemplaza `TU-USUARIO` con tu nombre de usuario de GitHub:

```bash
# Agregar remote
git remote add origin https://github.com/TU-USUARIO/control-de-gastos.git

# Renombrar rama a main
git branch -M main

# Subir a GitHub
git push -u origin main
```

---

**¡Listo! Tu proyecto estará en GitHub y podrás:**
- ✅ Compartir el link con otros
- ✅ Usar en tu portfolio
- ✅ Colaborar con otros desarrolladores
- ✅ Importar a FlutterFlow
- ✅ Hacer deploy desde GitHub

---

**Siguiente Paso**: Una vez en GitHub, seguir la guía `FLUTTERFLOW_MIGRATION.md` para visualizar la app en FlutterFlow.
