import 'package:flutter/material.dart';
import '../config/theme.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String _selectedCurrency = 'USD';
  String _selectedCurrencyName = 'Dólar Estadounidense';
  bool _useDecimals = true;
  String _weekStart = 'Lunes';
  String _theme = 'Sistema';

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CurrencyPickerModal(
        selectedCurrency: _selectedCurrency,
        onCurrencySelected: (code, name) {
          setState(() {
            _selectedCurrency = code;
            _selectedCurrencyName = name;
          });
        },
      ),
    );
  }

  void _showWeekStartPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Inicio de Semana',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...['Domingo', 'Lunes'].map((day) {
              final isSelected = day == _weekStart;
              return ListTile(
                title: Text(day),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppTheme.primaryGreen)
                    : null,
                onTap: () {
                  setState(() {
                    _weekStart = day;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tema',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...[
              {'name': 'Claro', 'icon': Icons.light_mode},
              {'name': 'Oscuro', 'icon': Icons.dark_mode},
              {'name': 'Sistema', 'icon': Icons.settings_brightness},
            ].map((theme) {
              final isSelected = theme['name'] == _theme;
              return ListTile(
                leading: Icon(
                  theme['icon'] as IconData,
                  color: isSelected
                      ? AppTheme.primaryGreen
                      : AppTheme.textSecondary,
                ),
                title: Text(theme['name'] as String),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppTheme.primaryGreen)
                    : null,
                onTap: () {
                  setState(() {
                    _theme = theme['name'] as String;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(title: const Text('Preferencias'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildListItem(
            title: 'Divisa',
            subtitle: '$_selectedCurrency - $_selectedCurrencyName',
            icon: Icons.attach_money,
            onTap: _showCurrencyPicker,
          ),
          _buildDivider(),
          _buildSwitchItem(
            title: 'Usar Decimales',
            icon: Icons.numbers,
            value: _useDecimals,
            onChanged: (value) {
              setState(() {
                _useDecimals = value;
              });
            },
          ),
          _buildDivider(),
          _buildListItem(
            title: 'Inicio de Semana',
            subtitle: _weekStart,
            icon: Icons.calendar_today,
            onTap: _showWeekStartPicker,
          ),
          _buildDivider(),
          _buildListItem(
            title: 'Tema',
            subtitle: _theme,
            icon: Icons.palette,
            onTap: _showThemePicker,
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
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
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
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

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.textTertiary.withOpacity(0.1),
      indent: 20,
      endIndent: 20,
    );
  }
}

// Currency Picker Modal
class CurrencyPickerModal extends StatefulWidget {
  final String selectedCurrency;
  final Function(String code, String name) onCurrencySelected;

  const CurrencyPickerModal({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  State<CurrencyPickerModal> createState() => _CurrencyPickerModalState();
}

class _CurrencyPickerModalState extends State<CurrencyPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredCurrencies = [];

  // Global currencies list with flags (using emoji flags)
  final List<Map<String, String>> _currencies = [
    {
      'code': 'USD',
      'name': 'Dólar Estadounidense',
      'country': 'Estados Unidos',
      'flag': '🇺🇸',
    },
    {'code': 'EUR', 'name': 'Euro', 'country': 'Unión Europea', 'flag': '🇪🇺'},
    {
      'code': 'GBP',
      'name': 'Libra Esterlina',
      'country': 'Reino Unido',
      'flag': '🇬🇧',
    },
    {'code': 'JPY', 'name': 'Yen Japonés', 'country': 'Japón', 'flag': '🇯🇵'},
    {
      'code': 'MXN',
      'name': 'Peso Mexicano',
      'country': 'México',
      'flag': '🇲🇽',
    },
    {
      'code': 'COP',
      'name': 'Peso Colombiano',
      'country': 'Colombia',
      'flag': '🇨🇴',
    },
    {
      'code': 'ARS',
      'name': 'Peso Argentino',
      'country': 'Argentina',
      'flag': '🇦🇷',
    },
    {
      'code': 'BRL',
      'name': 'Real Brasileño',
      'country': 'Brasil',
      'flag': '🇧🇷',
    },
    {'code': 'CLP', 'name': 'Peso Chileno', 'country': 'Chile', 'flag': '🇨🇱'},
    {'code': 'PEN', 'name': 'Sol Peruano', 'country': 'Perú', 'flag': '🇵🇪'},
    {
      'code': 'VES',
      'name': 'Bolívar Venezolano',
      'country': 'Venezuela',
      'flag': '🇻🇪',
    },
    {
      'code': 'CAD',
      'name': 'Dólar Canadiense',
      'country': 'Canadá',
      'flag': '🇨🇦',
    },
    {
      'code': 'AUD',
      'name': 'Dólar Australiano',
      'country': 'Australia',
      'flag': '🇦🇺',
    },
    {'code': 'CNY', 'name': 'Yuan Chino', 'country': 'China', 'flag': '🇨🇳'},
    {'code': 'INR', 'name': 'Rupia India', 'country': 'India', 'flag': '🇮🇳'},
    {'code': 'CHF', 'name': 'Franco Suizo', 'country': 'Suiza', 'flag': '🇨🇭'},
    {
      'code': 'KRW',
      'name': 'Won Surcoreano',
      'country': 'Corea del Sur',
      'flag': '🇰🇷',
    },
    {'code': 'RUB', 'name': 'Rublo Ruso', 'country': 'Rusia', 'flag': '🇷🇺'},
    {
      'code': 'ZAR',
      'name': 'Rand Sudafricano',
      'country': 'Sudáfrica',
      'flag': '🇿🇦',
    },
    {'code': 'TRY', 'name': 'Lira Turca', 'country': 'Turquía', 'flag': '🇹🇷'},
    {
      'code': 'SEK',
      'name': 'Corona Sueca',
      'country': 'Suecia',
      'flag': '🇸🇪',
    },
    {
      'code': 'NOK',
      'name': 'Corona Noruega',
      'country': 'Noruega',
      'flag': '🇳🇴',
    },
    {
      'code': 'DKK',
      'name': 'Corona Danesa',
      'country': 'Dinamarca',
      'flag': '🇩🇰',
    },
    {
      'code': 'PLN',
      'name': 'Zloty Polaco',
      'country': 'Polonia',
      'flag': '🇵🇱',
    },
    {
      'code': 'THB',
      'name': 'Baht Tailandés',
      'country': 'Tailandia',
      'flag': '🇹🇭',
    },
    {
      'code': 'IDR',
      'name': 'Rupia Indonesia',
      'country': 'Indonesia',
      'flag': '🇮🇩',
    },
    {
      'code': 'MYR',
      'name': 'Ringgit Malayo',
      'country': 'Malasia',
      'flag': '🇲🇾',
    },
    {
      'code': 'PHP',
      'name': 'Peso Filipino',
      'country': 'Filipinas',
      'flag': '🇵🇭',
    },
    {
      'code': 'SGD',
      'name': 'Dólar de Singapur',
      'country': 'Singapur',
      'flag': '🇸🇬',
    },
    {
      'code': 'HKD',
      'name': 'Dólar de Hong Kong',
      'country': 'Hong Kong',
      'flag': '🇭🇰',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = _currencies;
    _searchController.addListener(_filterCurrencies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCurrencies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = _currencies;
      } else {
        _filteredCurrencies = _currencies.where((currency) {
          return currency['code']!.toLowerCase().contains(query) ||
              currency['name']!.toLowerCase().contains(query) ||
              currency['country']!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Seleccionar Divisa',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Search bar
          Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por país o código...',
                prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppTheme.darkCard,
              ),
            ),
          ),

          // Currency list
          Expanded(
            child: _filteredCurrencies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron resultados',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = _filteredCurrencies[index];
                      final isSelected =
                          currency['code'] == widget.selectedCurrency;

                      return InkWell(
                        onTap: () {
                          widget.onCurrencySelected(
                            currency['code']!,
                            currency['name']!,
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppTheme.textTertiary.withOpacity(0.1),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Flag
                              Text(
                                currency['flag']!,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(width: 16),

                              // Country and currency info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currency['country']!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${currency['name']} (${currency['code']})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              // Checkmark
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: AppTheme.primaryGreen,
                                  size: 28,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
