# 💰 Control de Gastos - Expense Tracker App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.38.5-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.4-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow)

**Aplicación móvil completa de control de gastos con diseño premium y análisis financiero inteligente**

[Características](#-características) • [Capturas](#-capturas) • [Instalación](#-instalación) • [Documentación](#-documentación) • [Roadmap](#-roadmap)

</div>

---

## 📱 Descripción

**Control de Gastos** es una aplicación móvil moderna y completa para la gestión de finanzas personales. Diseñada con Flutter, ofrece una experiencia premium con análisis inteligente, proyecciones de deuda, tracking de recompensas y mucho más.

### ✨ Características Principales

- 💰 **Gestión Completa de Transacciones**: Gastos, ingresos, pagos y reembolsos
- 📊 **Análisis Financiero Inteligente**: Gráficos, proyecciones y sugerencias
- 💳 **Gestión de Tarjetas de Crédito**: Análisis de deuda, tasa de utilización, proyección de pagos
- 📅 **Calendario Financiero**: Vista mensual con filtros avanzados
- 🎯 **Presupuestos Personalizados**: Límites por categoría y alertas
- ⭐ **Funcionalidades Premium**: Compras a meses, cashback tracking, análisis avanzado
- 🎨 **Diseño Neumórfico**: Modo oscuro con estética moderna y premium

---

## 🏗️ Arquitectura

### Tecnologías

- **Framework**: Flutter 3.38.5
- **Lenguaje**: Dart 3.10.4
- **Backend**: Supabase (Pendiente)
- **Gráficos**: fl_chart
- **Iconos**: Font Awesome Flutter

### Estructura del Proyecto

```
lib/
├── main.dart                       # Punto de entrada
├── config/
│   └── theme.dart                  # Tema y colores
├── widgets/
│   └── neumorphic_card.dart       # Componente reutilizable
└── screens/
    ├── home_screen.dart           # Pantalla principal
    ├── add_transaction_modal.dart # Modal de transacciones
    ├── add_expense_screen.dart    # Formulario de gastos
    ├── add_payment_screen.dart    # Formulario de pagos
    ├── add_income_screen.dart     # Formulario de ingresos
    ├── add_installment_screen.dart    # Compras a meses (Premium)
    ├── add_card_payment_screen.dart   # Pago con tarjeta (Premium)
    ├── add_cashback_screen.dart       # Cashback (Premium)
    ├── calendar_screen.dart       # Calendario
    ├── graphs_screen.dart         # Gráficos y análisis
    └── accounts_screen.dart       # Gestión de cuentas
```

---

## 🎨 Pantallas Implementadas

### 1. 🏠 Home Screen
- Balance total con gradiente
- Resumen de gastos e ingresos del mes
- Lista de transacciones recientes
- Navegación inferior

### 2. ➕ Add Transaction Modal
- 7 tipos de transacciones
- 3 opciones premium
- Navegación a formularios específicos

### 3. 💰 Formularios (7 pantallas)
- **Gastos**: 8 categorías con chips coloridos
- **Pagos**: Recordatorios y pago automático
- **Ingresos/Reembolsos**: Formulario dinámico
- **Compras a Meses** (Premium): Cálculo automático de cuotas
- **Pago con Tarjeta** (Premium): Selector visual de tarjetas
- **Devoluciones** (Premium): Tracking de cashback con animaciones

### 4. 📅 Calendar Screen
- Grid de calendario con indicadores
- Navegación mensual
- Filtros avanzados
- Balance expandible

### 5. 📊 Graphs Screen
- Gráfico donut de presupuesto
- Tarjetas de análisis
- Sugerencias financieras
- Configuración de presupuesto

### 6. 💳 Accounts Screen
- Gestión de cuentas débito
- **Sección Premium**: Análisis de tarjetas de crédito
- Proyección de pagos
- Centro de recompensas
- Compras a meses activas

---

## 💎 Funcionalidades Premium

### 1. Compras a Meses
- Cálculo automático de cuotas con interés compuesto
- Selector de plazo (3-24 meses)
- Generación de cuotas individuales
- Tracking de pagos

### 2. Análisis de Tarjetas de Crédito
- Tasa de utilización visual
- Proyección de pagos interactiva
- Cálculo de intereses
- Centro de recompensas (puntos/millas)

### 3. Devoluciones Efectivas
- Tracking de cashback
- 4 tipos de devolución
- Totales acumulados (mensual/anual)
- Animaciones de celebración

### 4. Presupuesto Avanzado
- Límites por categoría
- Sugerencias inteligentes
- Alertas de gastos
- Proyecciones

### 5. Pago con Tarjeta
- Selector visual de tarjetas
- Estados de pago
- Conversión a meses
- Recordatorios premium

---

## 📊 Estadísticas del Proyecto

```
📱 Pantallas: 6
📝 Formularios: 7 (4 estándar + 3 premium)
💎 Features Premium: 5
📄 Líneas de Código: ~6,000+
📚 Documentación: 8 archivos MD
🎨 Imágenes de Referencia: 7
```

---

## 🚀 Instalación

### Prerrequisitos

- Flutter SDK 3.38.5 o superior
- Dart 3.10.4 o superior
- Android Studio / VS Code
- Git

### Pasos

1. **Clonar el repositorio**
```bash
git clone https://github.com/tu-usuario/control-de-gastos.git
cd control-de-gastos
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Ejecutar la aplicación**
```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

---

## 📚 Documentación

El proyecto incluye documentación exhaustiva:

- **[RESUMEN_EJECUTIVO.md](RESUMEN_EJECUTIVO.md)**: Visión general completa del proyecto
- **[FORMULARIOS.md](FORMULARIOS.md)**: Guía de los 7 formularios implementados
- **[FORMULARIO_PREMIUM.md](FORMULARIO_PREMIUM.md)**: Detalles de funcionalidades premium
- **[CALENDARIO.md](CALENDARIO.md)**: Documentación de la pantalla de calendario
- **[GRAFICOS.md](GRAFICOS.md)**: Pantalla de gráficos y análisis
- **[CUENTAS.md](CUENTAS.md)**: Gestión de cuentas y tarjetas
- **[FUNCIONALIDADES.md](FUNCIONALIDADES.md)**: Features generales
- **[FLUTTERFLOW_MIGRATION.md](FLUTTERFLOW_MIGRATION.md)**: Guía de migración a FlutterFlow

---

## 🎨 Sistema de Diseño

### Paleta de Colores

```dart
// Colores principales
primaryBlue: #1E88E5
primaryGreen: #66BB6A
accentPurple: #9C27B0
accentRed: #EF5350
accentOrange: #FF9800

// Fondos (Modo Oscuro)
darkBackground: #121212
darkCard: #1E1E1E
darkCardLight: #2A2A2A

// Texto
textPrimary: #FFFFFF
textSecondary: #B0B0B0
textTertiary: #757575
```

### Componentes

- **NeumorphicCard**: Tarjetas con efecto 3D
- **Chips seleccionables**: Para categorías y filtros
- **Barras de progreso**: Con colores dinámicos
- **Modales**: Pantalla completa y bottom sheet

---

## 🗄️ Base de Datos (Supabase)

### Tablas Principales

- `profiles`: Perfiles de usuario
- `transactions`: Todas las transacciones
- `categories`: Categorías personalizadas
- `accounts`: Cuentas de débito
- `credit_cards`: Tarjetas de crédito
- `installment_purchases`: Compras a meses
- `installments`: Cuotas individuales
- `budgets`: Configuración de presupuestos
- `category_limits`: Límites por categoría
- `cashback_transactions`: Devoluciones y cashback

Ver esquemas completos en la documentación.

---

## 🛣️ Roadmap

### ✅ Fase 1: UI/UX (Completado)
- [x] Diseño de todas las pantallas
- [x] Sistema de diseño neumórfico
- [x] Navegación completa
- [x] Formularios con validación
- [x] Funcionalidades premium

### 🔄 Fase 2: Backend (En Progreso)
- [ ] Configurar Supabase
- [ ] Implementar autenticación
- [ ] CRUD de transacciones
- [ ] Cálculos automáticos
- [ ] Sincronización de datos

### ⏳ Fase 3: Funcionalidades Avanzadas
- [ ] Notificaciones push
- [ ] Recordatorios de pagos
- [ ] Sincronización bancaria
- [ ] Exportar reportes (PDF/Excel)
- [ ] Gráficos avanzados

### ⏳ Fase 4: Premium
- [ ] Sistema de suscripciones
- [ ] Análisis con IA
- [ ] Predicciones financieras
- [ ] Asesoría personalizada

### ⏳ Fase 5: Publicación
- [ ] Testing exhaustivo
- [ ] Optimización de rendimiento
- [ ] Deploy a App Store
- [ ] Deploy a Google Play
- [ ] Marketing y lanzamiento

---

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

---

## 👨‍💻 Autor

**Tu Nombre**
- GitHub: [@tu-usuario](https://github.com/tu-usuario)
- Email: tu-email@ejemplo.com

---

## 🙏 Agradecimientos

- Flutter Team por el increíble framework
- Supabase por el backend
- fl_chart por los gráficos
- Font Awesome por los iconos
- La comunidad de Flutter

---

## 📸 Capturas

> Las capturas de pantalla se agregarán próximamente

---

<div align="center">

**⭐ Si te gusta este proyecto, dale una estrella en GitHub ⭐**

Hecho con ❤️ y Flutter

</div>
