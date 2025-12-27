# Guía de Configuración de Supabase

Esta guía te ayudará a configurar Supabase para la aplicación Control de Gastos.

---

## Paso 1: Crear Proyecto en Supabase

1. Ve a [https://supabase.com](https://supabase.com)
2. Click en "Start your project" o "Sign in"
3. Si es tu primera vez, crea una cuenta (recomendado: usar GitHub)
4. Click en "+ New project"
5. Completa:
   - **Name**: `control-gastos-app`
   - **Database Password**: (crea una contraseña segura y guárdala)
   - **Region**: Selecciona la más cercana a ti
   - **Pricing Plan**: Free
6. Click en "Create new project"
7. **Espera 2-3 minutos** mientras se crea el proyecto

---

## Paso 2: Obtener Credenciales

1. En tu proyecto, ve a **Settings** (⚙️ en la barra lateral)
2. Click en **API**
3. Copia los siguientes valores:

   **Project URL**
   ```
   https://xxxxx.supabase.co
   ```

   **anon public key**
   ```
   eyJhbGc...
   ```

4. Guarda estos valores en un lugar seguro

---

## Paso 3: Ejecutar Script SQL

1. En tu proyecto de Supabase, ve a **SQL Editor** en la barra lateral
2. Click en "+ New query"
3. **Copia y pega el siguiente script completo:**

```sql
-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==================== TABLA DE PERFILES ====================
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS para profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Políticas para profiles
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- ==================== FUNCIÓN Y TRIGGER PARA AUTO-CREAR PERFIL ====================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para crear perfil automáticamente al registrarse
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ==================== TABLA DE CATEGORÍAS ====================
CREATE TABLE IF NOT EXISTS categories (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  icon TEXT,
  color TEXT,
  type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS para categories
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Políticas para categories
CREATE POLICY "Users can view own categories" ON categories
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own categories" ON categories
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own categories" ON categories
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own categories" ON categories
  FOR DELETE USING (auth.uid() = user_id);

-- ==================== TABLA DE TRANSACCIONES ====================
CREATE TABLE IF NOT EXISTS transactions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  amount DECIMAL(12, 2) NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
  description TEXT,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS para transactions
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- Políticas para transactions
CREATE POLICY "Users can view own transactions" ON transactions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own transactions" ON transactions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own transactions" ON transactions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own transactions" ON transactions
  FOR DELETE USING (auth.uid() = user_id);

-- ==================== TABLA DE PRESUPUESTOS ====================
CREATE TABLE IF NOT EXISTS budgets (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  category_id UUID REFERENCES categories(id) ON DELETE CASCADE,
  amount DECIMAL(12, 2) NOT NULL,
  period TEXT NOT NULL CHECK (period IN ('daily', 'weekly', 'monthly', 'yearly')),
  start_date DATE NOT NULL,
  end_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS para budgets
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;

-- Políticas para budgets
CREATE POLICY "Users can view own budgets" ON budgets
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own budgets" ON budgets
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own budgets" ON budgets
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own budgets" ON budgets
  FOR DELETE USING (auth.uid() = user_id);

-- ==================== TABLA DE TRANSACCIONES RECURRENTES ====================
CREATE TABLE IF NOT EXISTS recurring_transactions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  amount DECIMAL(12, 2) NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
  description TEXT,
  frequency TEXT NOT NULL CHECK (frequency IN ('daily', 'weekly', 'monthly', 'yearly')),
  start_date DATE NOT NULL,
  end_date DATE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS para recurring_transactions
ALTER TABLE recurring_transactions ENABLE ROW LEVEL SECURITY;

-- Políticas para recurring_transactions
CREATE POLICY "Users can view own recurring transactions" ON recurring_transactions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own recurring transactions" ON recurring_transactions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own recurring transactions" ON recurring_transactions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own recurring transactions" ON recurring_transactions
  FOR DELETE USING (auth.uid() = user_id);

-- ==================== ÍNDICES PARA MEJOR RENDIMIENTO ====================
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(date);
CREATE INDEX IF NOT EXISTS idx_categories_user_id ON categories(user_id);
CREATE INDEX IF NOT EXISTS idx_budgets_user_id ON budgets(user_id);
CREATE INDEX IF NOT EXISTS idx_recurring_transactions_user_id ON recurring_transactions(user_id);
```

4. Click en **RUN** o presiona `Ctrl+Enter` / `Cmd+Enter`
5. Verifica que veas "Success. No rows returned" (esto es normal)

---

## Paso 4: Verificar Configuración

1. Ve a **Table Editor** en la barra lateral
2. Deberías ver las siguientes tablas:
   - ✅ `profiles`
   - ✅ `categories`
   - ✅ `transactions`
   - ✅ `budgets`
   - ✅ `recurring_transactions`

---

## Paso 5: Configurar Credenciales en la App

1. Abre el archivo `lib/config/supabase_config.dart`
2. Reemplaza:
   ```dart
   static const String supabaseUrl = 'YOUR_SUPABASE_URL';
   static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```
   
   Con tus credenciales reales:
   ```dart
   static const String supabaseUrl = 'https://xxxxx.supabase.co';
   static const String supabaseAnonKey = 'eyJhbGc...';
   ```

---

## ¡Listo! 🎉

Tu backend de Supabase está configurado y listo para usar.

### Próximos Pasos

El desarrollador integrará la autenticación de Supabase en las pantallas de login y registro.

---

## Solución de Problemas

### Error: "relation 'profiles' does not exist"
- Verifica que ejecutaste el script SQL completo
- Ve a Table Editor y confirma que existen las tablas

### Error: "JWT expired" o "Invalid JWT"
- Verifica que copiaste correctamente el `anon public key` (NO uses el `service_role key`)
- Asegúrate de no haber copiado espacios extra al inicio o final

### ¿Olvidaste tu contraseña de base de datos?
- Ve a Settings > Database > Reset database password
- Esto NO afectará tus datos, solo la contraseña administrativa
