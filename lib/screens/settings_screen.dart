import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';
import 'premium_screen.dart';
import 'categories_screen.dart';
import 'recurring_transactions_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _useDecimals = true;
  bool _safeMode = false;
  String _selectedCurrency = 'USD';
  String _selectedTheme = 'Oscuro';
  String _weekStart = 'Lunes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(title: const Text('Ajustes'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // Header with logo and email
          _buildHeader(),
          const SizedBox(height: 20),

          // Premium section
          _buildPremiumCard(),
          const SizedBox(height: 24),

          // Financial Management
          _buildSectionHeader('Gestión Financiera Central'),
          _buildListItem(icon: Icons.settings, title: 'General', onTap: () {}),
          _buildListItem(
            icon: Icons.category,
            title: 'Categorías',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriesScreen(),
                ),
              );
            },
          ),
          _buildListItem(
            icon: Icons.repeat,
            title: 'Transacciones Recurrentes',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecurringTransactionsScreen(),
                ),
              );
            },
          ),
          _buildListItem(
            icon: Icons.account_balance_wallet,
            title: 'Presupuesto',
            onTap: () {},
          ),
          _buildListItem(
            icon: Icons.analytics,
            title: 'Análisis',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Data Tools
          _buildSectionHeader('Herramientas de Datos'),
          _buildListItem(
            icon: Icons.import_export,
            title: 'Importar y Exportar Datos',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // User Preferences
          _buildSectionHeader('Preferencias de Usuario'),
          _buildListItem(
            icon: Icons.attach_money,
            title: 'Moneda',
            subtitle: _selectedCurrency,
            onTap: () => _showCurrencyPicker(),
          ),
          _buildSwitchItem(
            icon: Icons.numbers,
            title: 'Usar Decimales',
            value: _useDecimals,
            onChanged: (value) {
              setState(() {
                _useDecimals = value;
              });
            },
          ),
          _buildListItem(
            icon: Icons.calendar_today,
            title: 'Inicio de Semana',
            subtitle: _weekStart,
            onTap: () => _showWeekStartPicker(),
          ),
          _buildListItem(
            icon: Icons.palette,
            title: 'Tema',
            subtitle: _selectedTheme,
            onTap: () => _showThemePicker(),
          ),
          const SizedBox(height: 24),

          // Account and Security
          _buildSectionHeader('Cuenta y Seguridad'),
          _buildListItem(
            icon: Icons.security,
            title: 'Seguridad',
            onTap: () {},
          ),
          _buildSwitchItem(
            icon: Icons.lock,
            title: 'Modo Seguro',
            subtitle: 'Premium',
            value: _safeMode,
            onChanged: (value) {
              setState(() {
                _safeMode = value;
              });
            },
            isPremium: true,
          ),
          _buildListItem(icon: Icons.person, title: 'Mi Cuenta', onTap: () {}),
          _buildListItem(
            icon: Icons.card_membership,
            title: 'Suscripción',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Community and Feedback
          _buildSectionHeader('Comunidad y Feedback'),
          _buildListItem(
            icon: Icons.feedback,
            title: 'Danos tu Opinión',
            onTap: () {},
          ),
          _buildListItem(
            icon: Icons.star,
            title: 'Calificar la Aplicación',
            onTap: () {},
          ),
          _buildListItem(
            icon: Icons.lightbulb,
            title: 'Sugerencias',
            onTap: () {},
          ),

          // Social Media
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              'Redes Sociales',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildSocialMediaRow(),
          const SizedBox(height: 24),

          // Data Management
          _buildSectionHeader('Gestión de Datos'),
          _buildListItem(
            icon: Icons.refresh,
            title: 'Reiniciar Mis Datos',
            onTap: () => _showConfirmDialog('Reiniciar'),
            textColor: AppTheme.accentOrange,
          ),
          _buildListItem(
            icon: Icons.delete_forever,
            title: 'Eliminar Datos',
            onTap: () => _showConfirmDialog('Eliminar'),
            textColor: AppTheme.accentRed,
          ),
          _buildListItem(
            icon: Icons.restart_alt,
            title: 'Empezar de Nuevo',
            onTap: () => _showConfirmDialog('Empezar de Nuevo'),
            textColor: AppTheme.accentRed,
          ),
          const SizedBox(height: 40),

          // Version
          Center(
            child: Text(
              'Versión 1.0.0',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.textTertiary),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // App Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.primaryBlue],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // User email (clickeable)
          InkWell(
            onTap: () => _launchEmail(),
            child: Text(
              'usuario@ejemplo.com',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.primaryBlue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PremiumScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.accentPurple, AppTheme.accentOrange],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Obtener Premium',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Desbloquea todas las funciones',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppTheme.primaryGreen,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.textTertiary.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? AppTheme.primaryBlue, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: textColor),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isPremium = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.textTertiary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: Theme.of(context).textTheme.bodyLarge),
                    if (isPremium) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.accentPurple,
                              AppTheme.accentOrange,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Premium',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSocialIcon(FontAwesomeIcons.youtube, Colors.red),
          _buildSocialIcon(FontAwesomeIcons.facebook, Colors.blue),
          _buildSocialIcon(FontAwesomeIcons.instagram, Colors.pink),
          _buildSocialIcon(FontAwesomeIcons.reddit, Colors.orange),
          _buildSocialIcon(FontAwesomeIcons.tiktok, Colors.black),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return InkWell(
      onTap: () {
        // Open social media link
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FaIcon(icon, color: color, size: 24),
      ),
    );
  }

  void _showCurrencyPicker() {
    final currencies = [
      {'code': 'USD', 'name': 'Dólar Estadounidense', 'symbol': '\$'},
      {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
      {'code': 'GBP', 'name': 'Libra Esterlina', 'symbol': '£'},
      {'code': 'JPY', 'name': 'Yen Japonés', 'symbol': '¥'},
      {'code': 'MXN', 'name': 'Peso Mexicano', 'symbol': '\$'},
      {'code': 'COP', 'name': 'Peso Colombiano', 'symbol': '\$'},
      {'code': 'ARS', 'name': 'Peso Argentino', 'symbol': '\$'},
      {'code': 'BRL', 'name': 'Real Brasileño', 'symbol': 'R\$'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Seleccionar Moneda',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ...currencies.map(
              (currency) => ListTile(
                leading: Text(
                  currency['symbol']!,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(currency['name']!),
                subtitle: Text(currency['code']!),
                trailing: _selectedCurrency == currency['code']
                    ? Icon(Icons.check, color: AppTheme.primaryGreen)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedCurrency = currency['code']!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWeekStartPicker() {
    final days = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Inicio de Semana',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ...days.map(
              (day) => ListTile(
                title: Text(day),
                trailing: _weekStart == day
                    ? Icon(Icons.check, color: AppTheme.primaryGreen)
                    : null,
                onTap: () {
                  setState(() {
                    _weekStart = day;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemePicker() {
    final themes = ['Claro', 'Oscuro', 'Personalizado'];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Seleccionar Tema',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ...themes.map(
              (theme) => ListTile(
                leading: Icon(
                  theme == 'Claro'
                      ? Icons.light_mode
                      : theme == 'Oscuro'
                      ? Icons.dark_mode
                      : Icons.palette,
                  color: AppTheme.primaryBlue,
                ),
                title: Text(theme),
                trailing: _selectedTheme == theme
                    ? Icon(Icons.check, color: AppTheme.primaryGreen)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedTheme = theme;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: Text('¿$action datos?'),
        content: Text(
          'Esta acción no se puede deshacer. ¿Estás seguro?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'soporte@controldegastos.com',
      query: 'subject=Soporte - Control de Gastos',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No se pudo abrir el cliente de correo'),
            backgroundColor: AppTheme.accentRed,
          ),
        );
      }
    }
  }
}
