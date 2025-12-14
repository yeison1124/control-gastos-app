# ⚙️ Pantalla de Ajustes y Configuración - Documentación

## ✅ Implementación Completa

Se ha creado la **pantalla de Ajustes y Configuración** con organización jerárquica, preferencias de usuario y gestión de datos.

---

## 🎨 Componentes de la Pantalla

### 1. **Header (Encabezado)**
**Elementos:**
- Logo de la aplicación (circular con gradiente)
- Icono de billetera
- Email del usuario debajo

**Diseño:**
- Centrado
- Logo de 80x80px
- Gradiente verde-azul

### 2. **Tarjeta Premium Destacada**
**Contenido:**
- Gradiente púrpura-naranja
- Icono de estrella
- Título: "Obtener Premium"
- Subtítulo: "Desbloquea todas las funciones"
- Flecha de navegación

**Características:**
- Muy visible
- Call-to-action claro
- Diseño atractivo

---

## 📋 Secciones de Configuración

### **1. Gestión Financiera Central**
**5 Opciones:**
- ⚙️ General
- 📁 Categorías
- 🔄 Transacciones Recurrentes
- 💰 Presupuesto
- 📊 Análisis

**Diseño:**
- Iconos azules
- Flechas de navegación
- Separadores sutiles

### **2. Herramientas de Datos**
**1 Opción:**
- 📤📥 Importar y Exportar Datos

### **3. Preferencias de Usuario**
**4 Opciones:**

#### a) Moneda (Divisas)
- Icono: 💵
- Muestra moneda actual
- Abre selector con 8 monedas:
  - USD - Dólar Estadounidense ($)
  - EUR - Euro (€)
  - GBP - Libra Esterlina (£)
  - JPY - Yen Japonés (¥)
  - MXN - Peso Mexicano ($)
  - COP - Peso Colombiano ($)
  - ARS - Peso Argentino ($)
  - BRL - Real Brasileño (R$)

#### b) Usar Decimales
- Icono: 🔢
- Toggle switch
- Activado por defecto

#### c) Inicio de Semana
- Icono: 📅
- Muestra día actual
- Selector con 7 días

#### d) Tema
- Icono: 🎨
- Muestra tema actual
- Opciones:
  - ☀️ Claro
  - 🌙 Oscuro
  - 🎨 Personalizado

### **4. Cuenta y Seguridad**
**4 Opciones:**
- 🔒 Seguridad
- 🔐 Modo Seguro (Premium)
- 👤 Mi Cuenta
- 💳 Suscripción

**Modo Seguro:**
- Toggle switch
- Badge "Premium"
- Gradiente en badge

### **5. Comunidad y Feedback**
**3 Opciones:**
- 💬 Danos tu Opinión
- ⭐ Calificar la Aplicación
- 💡 Sugerencias

**Redes Sociales:**
- Subtítulo: "Redes Sociales"
- 5 iconos con colores:
  - YouTube (rojo)
  - Facebook (azul)
  - Instagram (rosa)
  - Reddit (naranja)
  - TikTok (negro)

**Diseño:**
- Iconos en fila
- Fondo con opacidad
- Bordes redondeados

### **6. Gestión de Datos**
**3 Opciones (Peligrosas):**
- 🔄 Reiniciar Mis Datos (naranja)
- 🗑️ Eliminar Datos (rojo)
- ♻️ Empezar de Nuevo (rojo)

**Características:**
- Colores de advertencia
- Diálogos de confirmación
- Mensajes claros

---

## 🔧 Modales y Selectores

### **1. Selector de Moneda**
**Diseño:**
- Bottom sheet
- Lista de 8 monedas
- Cada item muestra:
  - Símbolo grande
  - Nombre completo
  - Código (USD, EUR, etc.)
  - Check verde si está seleccionada

### **2. Selector de Inicio de Semana**
**Diseño:**
- Bottom sheet
- Lista de 7 días
- Check verde en seleccionado

### **3. Selector de Tema**
**Diseño:**
- Bottom sheet
- 3 opciones con iconos
- Check verde en seleccionado

### **4. Diálogo de Confirmación**
**Para acciones peligrosas:**
- Título: "¿[Acción] datos?"
- Mensaje: "Esta acción no se puede deshacer"
- Botones:
  - Cancelar (gris)
  - Confirmar (rojo)

---

## 📊 Datos y Estado

### Variables de Estado:
```dart
_useDecimals: true
_safeMode: false
_selectedCurrency: 'USD'
_selectedTheme: 'Oscuro'
_weekStart: 'Lunes'
```

### Monedas Disponibles:
```dart
USD, EUR, GBP, JPY, MXN, COP, ARS, BRL
```

### Temas Disponibles:
```dart
Claro, Oscuro, Personalizado
```

---

## 🎯 Funcionalidades Implementadas

### ✅ Header Personalizado
- Logo de la app
- Email del usuario
- Diseño centrado

### ✅ Tarjeta Premium
- Gradiente atractivo
- Call-to-action claro
- Navegación

### ✅ Organización Jerárquica
- 6 secciones claras
- Headers con color verde
- Separadores visuales

### ✅ Selectores Interactivos
- Moneda (8 opciones)
- Tema (3 opciones)
- Inicio de semana (7 opciones)

### ✅ Toggles Funcionales
- Usar decimales
- Modo seguro (premium)

### ✅ Redes Sociales
- 5 plataformas
- Iconos con colores
- Enlaces preparados

### ✅ Gestión de Datos
- 3 opciones peligrosas
- Diálogos de confirmación
- Colores de advertencia

### ✅ Versión de la App
- Texto en footer
- Color gris terciario

---

## 🎨 Características de Diseño

### Colores Utilizados:
- **Azul** (`primaryBlue`): Iconos de opciones
- **Verde** (`primaryGreen`): Headers, checks, switches
- **Púrpura-Naranja**: Gradiente premium
- **Naranja** (`accentOrange`): Reiniciar datos
- **Rojo** (`accentRed`): Eliminar datos

### Componentes:
- **ListTile personalizado**: Con iconos y flechas
- **SwitchListTile**: Para toggles
- **Bottom sheets**: Para selectores
- **AlertDialog**: Para confirmaciones

### Tipografía:
- Headers: Verde, bold
- Títulos: Normal
- Subtítulos: Gris secundario
- Versión: Gris terciario

---

## 📱 Responsive Design

### Adaptaciones:
- Lista scrollable
- Bottom sheets adaptables
- Iconos de redes en fila
- Padding consistente

---

## 🔄 Estado Actual

### Implementado ✅
- Pantalla completa de ajustes
- Header con logo y email
- Tarjeta premium
- 6 secciones organizadas
- 20+ opciones de configuración
- 3 selectores (moneda, tema, semana)
- 2 toggles (decimales, modo seguro)
- Redes sociales (5 plataformas)
- Gestión de datos (3 opciones)
- Diálogos de confirmación
- Versión de la app

### Pendiente ⏳
- Integración con Supabase
- Guardar preferencias
- Autenticación de usuario
- Funcionalidad de exportar/importar
- Enlaces a redes sociales
- Sistema de suscripción premium
- Implementar cambio de tema
- Seguridad (PIN, biometría)

---

## 💾 Integración con Supabase (Futuro)

### Tabla de Preferencias:

```sql
CREATE TABLE user_preferences (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  currency VARCHAR(3) DEFAULT 'USD',
  use_decimals BOOLEAN DEFAULT TRUE,
  week_start VARCHAR(10) DEFAULT 'Lunes',
  theme VARCHAR(20) DEFAULT 'Oscuro',
  safe_mode BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- RLS
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own preferences"
  ON user_preferences FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own preferences"
  ON user_preferences FOR UPDATE
  USING (auth.uid() = user_id);
```

### Queries:

```sql
-- Obtener preferencias
SELECT * FROM user_preferences
WHERE user_id = $userId;

-- Actualizar moneda
UPDATE user_preferences
SET currency = $currency, updated_at = NOW()
WHERE user_id = $userId;

-- Actualizar tema
UPDATE user_preferences
SET theme = $theme, updated_at = NOW()
WHERE user_id = $userId;

-- Toggle decimales
UPDATE user_preferences
SET use_decimals = $useDecimals, updated_at = NOW()
WHERE user_id = $userId;
```

---

## 🎯 Próximos Pasos

1. **Conectar con Supabase**
   - Cargar preferencias del usuario
   - Guardar cambios en tiempo real
   - Sincronizar entre dispositivos

2. **Implementar Funcionalidades**
   - Exportar datos (CSV, PDF)
   - Importar datos
   - Cambio de tema real
   - Seguridad (PIN, Touch ID)

3. **Sistema Premium**
   - Pantalla de suscripción
   - Integración con pagos
   - Desbloqueo de features

4. **Redes Sociales**
   - Enlaces reales
   - Compartir en redes
   - Invitar amigos

5. **Gestión de Cuenta**
   - Editar perfil
   - Cambiar email
   - Cambiar contraseña
   - Eliminar cuenta

---

## 📁 Archivo Creado

```
lib/screens/
└── settings_screen.dart  ✅ 650+ líneas
```

---

**Estado**: ✅ Pantalla de Ajustes Completa  
**Líneas de Código**: ~650  
**Siguiente Fase**: 🔄 Integración con Backend y Preferencias de Usuario
