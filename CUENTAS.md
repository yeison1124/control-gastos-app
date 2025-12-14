# 💳 Pantalla de Cuentas - Documentación

## ✅ Implementación Completa

Se ha creado la **pantalla de Cuentas** con navegación por pestañas, gestión de cuentas débito y una sección premium completa para análisis de tarjetas de crédito.

---

## 🎨 Estructura General

### Navegación por Pestañas:
- **Pestaña 1**: Cuentas Débito
- **Pestaña 2**: Tarjeta de Crédito (Premium)
- Indicador verde en pestaña activa
- Swipe para cambiar entre pestañas

---

## 📊 Pestaña 1: Cuentas Débito

### Componentes:

#### 1. **Tarjeta de Cheque**
**Contenido:**
- Icono de banco (azul)
- Nombre: "Cheque"
- Balance actual: $3,200.00
- Botón de editar (✏️)
- Lista de transacciones recientes

**Funcionalidad:**
- Tap en editar → Modal para actualizar balance
- Modal con campo numérico y botón "Actualizar Balance"

#### 2. **Tarjeta de Efectivo**
**Contenido:**
- Icono de dinero (verde)
- Nombre: "Efectivo"
- Balance actual: $1,300.00
- Botón de editar (✏️)
- Lista de transacciones recientes

**Funcionalidad:**
- Tap en editar → Modal para actualizar balance
- Mismo comportamiento que Cheque

### Transacciones Recientes:
Cada tarjeta muestra 3 transacciones:
- Icono de dirección (↓ verde para ingresos, ↑ rojo para gastos)
- Descripción
- Fecha
- Monto con color

**Ejemplos:**
- Depósito: +$500.00 (10 Dic)
- Retiro: -$200.00 (08 Dic)
- Transferencia: -$150.00 (05 Dic)

---

## 💎 Pestaña 2: Tarjeta de Crédito (Premium)

### Diseño Premium:
- Gradiente sutil púrpura de fondo
- Badge "Sección Premium" con gradiente
- Icono de estrella ⭐

### 1. **Resumen de Deuda**
**Contenido:**
- Título: "Resumen de Deuda"
- Dos columnas:
  - **Balance Total**: $2,000.00 (rojo)
  - **Límite Total**: $8,000.00 (verde)

**Cálculo:**
```
Balance Total = Suma de balances de todas las tarjetas
Límite Total = Suma de límites de todas las tarjetas
```

### 2. **Lista de Tarjetas**
Cada tarjeta muestra:
- Icono con gradiente púrpura/azul
- Nombre de la tarjeta
- Balance actual (rojo)
- Tasa de utilización con barra de progreso
- Icono de flecha → (indica que es clickeable)

**Tarjetas de Ejemplo:**
1. **Visa Gold**
   - Balance: $1,200.00
   - Límite: $5,000.00
   - Utilización: 24% (verde)

2. **Mastercard Platinum**
   - Balance: $800.00
   - Límite: $3,000.00
   - Utilización: 27% (verde)

**Colores de Utilización:**
- 0-30%: Verde ✅
- 31-70%: Naranja ⚠️
- 71-100%: Rojo ❌

### 3. **Botón Sincronizar**
- Outlined button con icono de sync
- Texto: "Sincronizar Tarjetas (Premium)"
- Color: Púrpura
- Acción: Sincronizar con bancos (futuro)

---

## 🔍 Sub-Pantalla: Detalle y Análisis de Tarjeta (Premium)

### Acceso:
- Tap en cualquier tarjeta de la lista
- Navegación completa a nueva pantalla
- Badge "Premium" en AppBar

### Secciones:

#### 1. **Resumen del Ciclo**
**Campos:**
- **Balance Actual**: $1,200.00 (rojo, editable)
- **Límite de Crédito**: $5,000.00 (verde, editable)
- **Tasa de Utilización**: Barra de progreso con porcentaje
  - Color dinámico según porcentaje
- **Día de Corte**: Día 15
- **Día Límite**: Día 25

**Características:**
- Todos los campos son editables
- Barra de utilización se actualiza automáticamente
- Colores semánticos

#### 2. **Análisis de Deuda**
**Campos:**
- **Tasa de Interés Anual (TIA)**: Campo editable con sufijo %
- **Intereses Pagados Este Ciclo**: $45.00 (calculado)

**Diseño:**
- Campo de entrada para TIA
- Alert box naranja con icono de info
- Muestra intereses acumulados

#### 3. **Proyección de Pago** (Herramienta Interactiva)
**Funcionalidad:**
- Campo: "Quiero pagar mensualmente" ($500.00)
- Botón: "Calcular Proyección"
- Resultado en tarjeta con gradiente:
  - **Saldarás en**: X meses
  - **Pagarás en intereses**: $Y

**Fórmula de Cálculo:**
```dart
tasaMensual = TIA / 100 / 12
while (balance > 0) {
  interes = balance * tasaMensual
  balance = balance + interes - pago
  meses++
}
```

**Ejemplo:**
- Balance: $1,200.00
- Pago mensual: $500.00
- TIA: 24%
- **Resultado**: Saldarás en 3 meses, pagarás $45.00 en intereses

#### 4. **Centro de Recompensas**
**Campos:**
- **Saldo de Puntos/Millas**: 15,000 (editable)
- **Valor Estimado**: $150.00 (calculado)
- **Mejor Uso**: "Esta tarjeta te da más puntos en Viajes"

**Características:**
- Campo numérico para puntos
- Cálculo automático de valor (1 punto = $0.01)
- Sugerencia con icono de bombilla

#### 5. **Acciones**
**Botón Principal:**
- "Registrar Pago a Tarjeta"
- Verde, ancho completo
- Icono de pago
- Altura: 56px

#### 6. **Compras a Meses**
**Lista de Cuotas Activas:**
Cada item muestra:
- Nombre del producto
- Cuota mensual
- Barra de progreso
- Cuotas restantes/totales

**Ejemplos:**
1. **Laptop**
   - 12 meses totales
   - 6 meses restantes
   - $250.00/mes
   - Progreso: 50%

2. **Refrigerador**
   - 18 meses totales
   - 12 meses restantes
   - $150.00/mes
   - Progreso: 33%

---

## 📊 Datos Mock Implementados

### Cuentas Débito:
```dart
Cheque: $3,200.00
Efectivo: $1,300.00
Total: $4,500.00
```

### Tarjetas de Crédito:
```dart
Visa Gold:
  balance: $1,200.00
  limit: $5,000.00
  apr: 24.0%
  cutoffDay: 15
  dueDay: 25
  points: 15,000
  pointsValue: $150.00

Mastercard Platinum:
  balance: $800.00
  limit: $3,000.00
  apr: 18.0%
  cutoffDay: 20
  dueDay: 30
  points: 8,000
  pointsValue: $80.00
```

---

## 🎯 Funcionalidades Implementadas

### ✅ Navegación por Pestañas
- TabController con 2 pestañas
- Swipe entre secciones
- Indicador visual

### ✅ Actualización de Balances
- Modal con campo numérico
- Validación de entrada
- Actualización inmediata

### ✅ Tasa de Utilización
- Cálculo automático
- Barra de progreso visual
- Colores dinámicos

### ✅ Proyección de Pagos
- Calculadora interactiva
- Fórmula de interés compuesto
- Resultado visual

### ✅ Centro de Recompensas
- Gestión de puntos
- Cálculo de valor
- Sugerencias

### ✅ Compras a Meses
- Lista de cuotas activas
- Progreso visual
- Información detallada

---

## 🎨 Características de Diseño

### Colores Utilizados:
- **Azul** (`primaryBlue`): Cuenta de cheque, configuración
- **Verde** (`primaryGreen`): Efectivo, límites, progreso positivo
- **Rojo** (`accentRed`): Balances de tarjetas, deuda
- **Púrpura** (`accentPurple`): Elementos premium, gradientes
- **Naranja** (`accentOrange`): Alertas, utilización media, recompensas

### Componentes Premium:
- Badge con gradiente en AppBar
- Gradiente de fondo en sección premium
- Tarjetas con gradiente en iconos
- Barras de progreso con colores dinámicos

### Componentes Neumórficos:
- Todas las tarjetas principales
- Campos de resumen
- Lista de transacciones
- Lista de compras a meses

---

## 📱 Responsive Design

### Adaptaciones:
- Pestañas ocupan ancho completo
- Tarjetas se ajustan al contenedor
- Barras de progreso responsive
- Modal de actualización centrado
- Sub-pantalla con scroll completo

---

## 🔄 Estado Actual

### Implementado ✅
- Pantalla completa con pestañas
- Gestión de cuentas débito
- Vista premium de tarjetas
- Sub-pantalla de análisis detallado
- Calculadora de proyección
- Centro de recompensas
- Lista de compras a meses
- Actualización de balances

### Pendiente ⏳
- Integración con Supabase
- Sincronización con bancos
- Guardar configuración de tarjetas
- Historial de pagos
- Notificaciones de vencimiento
- Gráficos de tendencia de deuda
- Exportar análisis a PDF

---

## 💾 Integración con Supabase (Futuro)

### Tablas Necesarias:

```sql
-- Cuentas de débito
CREATE TABLE debit_accounts (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  account_type VARCHAR(50), -- 'checking', 'cash'
  balance DECIMAL(12, 2),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Tarjetas de crédito
CREATE TABLE credit_cards (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  card_name VARCHAR(100),
  balance DECIMAL(12, 2),
  credit_limit DECIMAL(12, 2),
  apr DECIMAL(5, 2),
  cutoff_day INTEGER,
  due_day INTEGER,
  rewards_points INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Compras a meses
CREATE TABLE installment_purchases (
  id UUID PRIMARY KEY,
  card_id UUID REFERENCES credit_cards(id),
  item_name VARCHAR(200),
  total_months INTEGER,
  remaining_months INTEGER,
  monthly_payment DECIMAL(12, 2),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Pagos de tarjeta
CREATE TABLE card_payments (
  id UUID PRIMARY KEY,
  card_id UUID REFERENCES credit_cards(id),
  amount DECIMAL(12, 2),
  payment_date DATE,
  interest_paid DECIMAL(12, 2),
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Queries:

```sql
-- Obtener todas las cuentas de un usuario
SELECT * FROM debit_accounts
WHERE user_id = $userId;

-- Obtener todas las tarjetas con utilización
SELECT 
  *,
  (balance / credit_limit * 100) as utilization_rate
FROM credit_cards
WHERE user_id = $userId
ORDER BY utilization_rate DESC;

-- Calcular intereses pagados en el ciclo
SELECT SUM(interest_paid) as total_interest
FROM card_payments
WHERE card_id = $cardId
  AND payment_date >= $cycleStart
  AND payment_date <= $cycleEnd;

-- Obtener compras a meses activas
SELECT * FROM installment_purchases
WHERE card_id = $cardId
  AND remaining_months > 0
ORDER BY remaining_months ASC;
```

---

## 🎯 Próximos Pasos

1. **Conectar con Supabase**
   - Cargar cuentas y tarjetas reales
   - Guardar actualizaciones de balance
   - Sincronizar datos

2. **Análisis Avanzado**
   - Gráficos de tendencia de deuda
   - Comparación entre tarjetas
   - Optimización de pagos

3. **Notificaciones**
   - Alertas de vencimiento
   - Recordatorios de pago
   - Avisos de utilización alta

4. **Sincronización Bancaria**
   - API de bancos
   - Actualización automática
   - Verificación de transacciones

---

## 📁 Archivo Creado

```
lib/screens/
└── accounts_screen.dart  ✅ 950+ líneas
    ├── AccountsScreen (main)
    └── CardDetailScreen (sub-screen)

Documentación:
└── CUENTAS.md  ✅
```

---

**Estado**: ✅ Pantalla de Cuentas Completa  
**Líneas de Código**: ~950  
**Siguiente Fase**: 🔄 Integración con Backend y Sincronización Bancaria
