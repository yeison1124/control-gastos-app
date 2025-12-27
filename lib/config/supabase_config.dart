import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // TODO: Reemplaza estos valores con tus credenciales reales de Supabase
  // Puedes obtenerlas en: https://supabase.com/dashboard/project/_/settings/api

  static const String supabaseUrl = 'https://zldqqyhhtmgtmejrycrg.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpsZHFxeWhodG1ndG1lanJ5Y3JnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY3OTQ1ODIsImV4cCI6MjA4MjM3MDU4Mn0.FSb-k9FW3stvXQVhu7qBUNx9-hMZdQDJpzHyEPkghvc';

  // Validar que las credenciales estén configuradas
  static bool get isConfigured {
    return supabaseUrl != 'https://zldqqyhhtmgtmejrycrg.supabase.co' &&
        supabaseAnonKey !=
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpsZHFxeWhodG1ndG1lanJ5Y3JnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY3OTQ1ODIsImV4cCI6MjA4MjM3MDU4Mn0.FSb-k9FW3stvXQVhu7qBUNx9-hMZdQDJpzHyEPkghvc' &&
        supabaseUrl.isNotEmpty &&
        supabaseAnonKey.isNotEmpty;
  }

  // Mensaje de error si no está configurado
  static String get configurationError {
    return 'Supabase no está configurado correctamente.\n\n'
        'Por favor:\n'
        '1. Crea un proyecto en https://supabase.com\n'
        '2. Copia tus credenciales desde Settings > API\n'
        '3. Actualiza lib/config/supabase_config.dart con tus credenciales reales';
  }
}
