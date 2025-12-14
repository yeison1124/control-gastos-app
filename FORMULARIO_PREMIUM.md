# 💎 Formulario Premium: Compras a Meses

## ✨ Características Premium

Este formulario representa la **joya de la corona** de las funciones premium, diseñado específicamente para gestión avanzada de crédito y compras a plazos.

---

## 🎨 Diseño Premium

### Indicadores Visuales Premium:
1. **Badge Premium en el Título**
   - Gradiente púrpura → naranja
   - Icono de estrella ⭐
   - Texto "Premium" en blanco

2. **Gradientes Sutiles**
   - Campo de monto: Gradiente púrpura/naranja de fondo
   - Cálculo de cuota: Gradiente verde/azul
   - Botón guardar: Gradiente púrpura/naranja completo

3. **Elementos Destacados**
   - Bordes con gradientes
   - Sombras más pronunciadas
   - Animaciones suaves

---

## 📋 Campos del Formulario

### 1. 💰 Monto Total de Compra
- **Diseño**: Campo grande con gradiente de fondo
- **Color**: Púrpura
- **Validación**: Requerido, número válido
- **Formato**: Máximo 2 decimales
- **Característica**: Actualiza automáticamente el cálculo de cuota

### 2. 📅 Plazo (Meses)
- **Tipo**: Chips seleccionables
- **Opciones**: 3, 6, 9, 12, 18, 24 meses
- **Diseño Seleccionado**: Gradiente púrpura → naranja
- **Diseño No Seleccionado**: Tarjeta oscura con borde sutil
- **Característica**: Actualiza automáticamente el cálculo de cuota

### 3. 🧮 Cuota Mensual Estimada (DESTACADO)
**Este es el elemento estrella del formulario**

#### Características:
- **Cálculo Automático**: Se actualiza en tiempo real
- **Diseño Premium**:
  - Gradiente verde/azul de fondo
  - Borde verde brillante (2px)
  - Icono de calculadora
  - Tamaño de fuente grande (displaySmall)

#### Información Mostrada:
- **Cuota mensual** en grande (verde)
- **Número de cuotas** en chip (ej: "x 12")
- **Indicador de interés**:
  - Si TIA > 0: Muestra "TIA: X%"
  - Si TIA = 0: Muestra "✓ Sin intereses" en verde

#### Fórmula de Cálculo:
```dart
// Sin intereses:
cuota = monto / plazo

// Con intereses (interés compuesto):
tasaMensual = TIA / 100 / 12
cuota = monto * (tasaMensual * (1 + tasaMensual)^plazo) / ((1 + tasaMensual)^plazo - 1)
```

### 4. 💳 Tarjeta Utilizada
- **Tipo**: Dropdown
- **Opciones**:
  - Visa **** 1234
  - Mastercard **** 5678
  - American Express **** 9012
  - Otra Tarjeta
- **Color**: Púrpura
- **Validación**: Requerido

### 5. 📆 Fecha de Inicio de Pago
- **Tipo**: DatePicker
- **Color**: Púrpura
- **Rango**: Hoy → Hoy + 365 días
- **Formato**: dd/MM/yyyy
- **Descripción**: Fecha exacta del primer cargo

### 6. 📊 Tasa de Interés Anual (TIA)
- **Tipo**: Campo numérico
- **Opcional**: Sí (marcado como "Opcional")
- **Color**: Naranja
- **Formato**: Número con hasta 2 decimales + símbolo %
- **Uso**: 
  - Dejar vacío = Sin intereses
  - Ingresar valor = Calcula con interés compuesto

### 7. 📝 Descripción
- **Tipo**: Campo de texto
- **Placeholder**: "Ej: Laptop nueva"
- **Validación**: Requerido
- **Color del icono**: Azul

### 8. 🏷️ Categoría
- **Tipo**: Dropdown
- **Opciones**:
  - Electrónica
  - Electrodomésticos
  - Muebles
  - Ropa
  - Viajes
  - Educación
  - Otros
- **Color**: Azul
- **Validación**: Requerido

### 9. 📄 Nota
- **Tipo**: Campo multilínea (3 líneas)
- **Opcional**: Sí
- **Placeholder**: "Agrega detalles adicionales..."

---

## 🎯 Botón de Acción

### Guardar (Premium)
- **Diseño**: Gradiente púrpura → naranja
- **Ancho**: 100%
- **Altura**: 56px
- **Border Radius**: 16px
- **Texto**: Blanco, negrita, titleLarge
- **Efecto**: Sin elevación (flat con gradiente)

---

## 🧮 Lógica de Cálculo Inteligente

### Actualización en Tiempo Real
El cálculo se actualiza automáticamente cuando:
- Se cambia el monto total
- Se selecciona un plazo diferente
- Se ingresa o modifica la tasa de interés

### Listeners Implementados:
```dart
_totalAmountController.addListener(_calculateInstallment);
_interestRateController.addListener(_calculateInstallment);
```

### Validaciones:
- Monto debe ser > 0
- Si hay TIA, debe ser número válido
- Plazo siempre tiene un valor (default: 3 meses)

---

## 💡 Experiencia de Usuario Premium

### Feedback Visual:
1. **Cálculo Instantáneo**: El usuario ve inmediatamente cuánto pagará cada mes
2. **Indicador de Intereses**: Sabe claramente si hay o no intereses
3. **Selección Visual**: Los chips de plazo tienen feedback inmediato
4. **Validación Clara**: Mensajes de error específicos

### Flujo de Uso:
1. Usuario ingresa monto total
2. Ve cálculo inicial (sin intereses, 3 meses)
3. Selecciona plazo deseado
4. Cálculo se actualiza automáticamente
5. (Opcional) Ingresa TIA si hay intereses
6. Cálculo se actualiza con intereses
7. Completa resto de campos
8. Guarda la compra

---

## 🔗 Integración

### Navegación desde Modal:
```dart
'Compras a Meses' → AddInstallmentScreen()
```

### Estado Actual:
- ✅ UI/UX completa
- ✅ Cálculos funcionando
- ✅ Validación implementada
- ⏳ Pendiente: Guardar en Supabase
- ⏳ Pendiente: Generar cuotas automáticamente
- ⏳ Pendiente: Recordatorios de pago

---

## 📊 Datos a Guardar en Supabase

Cuando se implemente la integración:

```sql
CREATE TABLE installment_purchases (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  card_id UUID REFERENCES credit_cards(id),
  category_id UUID REFERENCES categories(id),
  total_amount DECIMAL(12, 2),
  term_months INTEGER,
  interest_rate DECIMAL(5, 2),
  monthly_installment DECIMAL(12, 2),
  start_date DATE,
  description TEXT,
  note TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE installments (
  id UUID PRIMARY KEY,
  purchase_id UUID REFERENCES installment_purchases(id),
  installment_number INTEGER,
  due_date DATE,
  amount DECIMAL(12, 2),
  is_paid BOOLEAN DEFAULT FALSE,
  paid_date DATE,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## 🎁 Valor Premium

### ¿Por qué es Premium?

1. **Cálculo Automático Inteligente**
   - Ahorra tiempo al usuario
   - Evita errores de cálculo manual
   - Muestra información clara

2. **Gestión de Crédito Avanzada**
   - Seguimiento de compras a meses
   - Control de tarjetas de crédito
   - Planificación financiera

3. **Recordatorios Automáticos** (Futuro)
   - Notificaciones de próximos pagos
   - Alertas de vencimiento
   - Historial de pagos

4. **Reportes Especializados** (Futuro)
   - Análisis de deuda
   - Proyección de pagos
   - Optimización de crédito

---

## 🚀 Próximas Mejoras

1. **Generación Automática de Cuotas**
   - Crear registros de cada cuota
   - Asignar fechas de vencimiento
   - Marcar como pagadas

2. **Integración con Calendario**
   - Mostrar cuotas en vista de calendario
   - Recordatorios visuales

3. **Dashboard de Crédito**
   - Total de deuda en cuotas
   - Próximos vencimientos
   - Gráficos de amortización

4. **Simulador de Escenarios**
   - Comparar diferentes plazos
   - Calcular ahorro sin intereses
   - Optimizar pagos

---

**Estado**: ✅ Formulario Premium Completo  
**Nivel de Sofisticación**: ⭐⭐⭐⭐⭐  
**Siguiente Fase**: 🔄 Integración con Backend y Generación de Cuotas
