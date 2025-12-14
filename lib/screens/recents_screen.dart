import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../widgets/neumorphic_card.dart';

class RecentsScreen extends StatefulWidget {
  const RecentsScreen({super.key});

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

class _RecentsScreenState extends State<RecentsScreen> {
  // Filter state
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  List<String> _selectedAccounts = ['Todas'];
  List<String> _selectedTypes = ['Todas'];
  List<String> _selectedCategories = ['Todas'];
  String? _recurringFilter;
  String? _autoPayFilter;

  // Mock data
  final double totalExpenses = 3250.00;
  final double totalIncome = 5420.00;
  final int frequentPayments = 8;

  final List<Map<String, dynamic>> _transactions = [
    {
      'date': DateTime.now(),
      'category': 'Salario',
      'description': 'Pago mensual',
      'amount': 3500.00,
      'type': 'income',
      'account': 'Cheque',
      'icon': Icons.account_balance_wallet,
      'color': AppTheme.primaryGreen,
    },
    {
      'date': DateTime.now(),
      'category': 'Supermercado',
      'description': 'Compras semanales',
      'amount': -150.00,
      'type': 'expense',
      'account': 'Tarjeta',
      'icon': Icons.shopping_cart,
      'color': AppTheme.accentOrange,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'category': 'Gasolina',
      'description': 'Tanque lleno',
      'amount': -45.00,
      'type': 'expense',
      'account': 'Efectivo',
      'icon': Icons.local_gas_station,
      'color': AppTheme.accentRed,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'category': 'Freelance',
      'description': 'Proyecto web',
      'amount': 1200.00,
      'type': 'income',
      'account': 'Cheque',
      'icon': Icons.computer,
      'color': AppTheme.primaryBlue,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'category': 'Restaurante',
      'description': 'Cena familiar',
      'amount': -80.00,
      'type': 'expense',
      'account': 'Tarjeta',
      'icon': Icons.restaurant,
      'color': AppTheme.accentOrange,
    },
  ];

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildFiltersModal(),
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: TransactionSearchDelegate(_transactions),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupTransactionsByDate() {
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (var transaction in _transactions) {
      final date = transaction['date'] as DateTime;
      String key;

      if (DateUtils.isSameDay(date, DateTime.now())) {
        key = 'Hoy';
      } else if (DateUtils.isSameDay(
        date,
        DateTime.now().subtract(const Duration(days: 1)),
      )) {
        key = 'Ayer';
      } else {
        key = DateFormat('d \'de\' MMMM', 'es').format(date);
      }

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(transaction);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedTransactions = _groupTransactionsByDate();

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Transacciones'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _showSearch),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick summaries
          _buildQuickSummaries(),

          // Transaction counter
          _buildTransactionCounter(),

          // Transactions list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final dateKey = groupedTransactions.keys.elementAt(index);
                final transactions = groupedTransactions[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 12,
                        top: index == 0 ? 0 : 20,
                      ),
                      child: Text(
                        dateKey,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ),

                    // Transactions for this date
                    ...transactions.map(
                      (transaction) => _buildTransactionItem(transaction),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open add transaction modal
        },
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  Widget _buildQuickSummaries() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              'Total Gastos',
              totalExpenses,
              AppTheme.accentRed,
              Icons.arrow_upward,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.textTertiary.withOpacity(0.3),
          ),
          Expanded(
            child: _buildSummaryItem(
              'Total Ingresos',
              totalIncome,
              AppTheme.primaryGreen,
              Icons.arrow_downward,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.textTertiary.withOpacity(0.3),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Pagos Frecuentes',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  frequentPayments.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              NumberFormat.currency(
                symbol: '\$',
                decimalDigits: 0,
              ).format(amount),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.receipt_long, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          Text(
            'Mostrando ${_transactions.length} transacciones',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isIncome = transaction['type'] == 'income';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NeumorphicCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: transaction['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                transaction['icon'],
                color: transaction['color'],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['description'],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        transaction['category'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.textTertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        transaction['account'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount
            Text(
              NumberFormat.currency(
                symbol: '\$',
                decimalDigits: 2,
              ).format(transaction['amount'].abs()),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isIncome ? AppTheme.primaryGreen : AppTheme.accentRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersModal() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
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
                      'Filtros de Transacción',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Filters content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Period filter
                      _buildPeriodFilter(setModalState),
                      const SizedBox(height: 24),

                      // Accounts filter
                      _buildAccountsFilter(setModalState),
                      const SizedBox(height: 24),

                      // Transaction types filter
                      _buildTypesFilter(setModalState),
                      const SizedBox(height: 24),

                      // Categories filter
                      _buildCategoriesFilter(setModalState),
                      const SizedBox(height: 24),

                      // Recurrence and automation
                      _buildRecurrenceFilter(setModalState),
                    ],
                  ),
                ),
              ),

              // Action buttons
              _buildFilterActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPeriodFilter(StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Periodo',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Quick options
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPeriodChip('Personalizado', setModalState),
            _buildPeriodChip('Mes Pasado', setModalState),
            _buildPeriodChip('Este Mes', setModalState),
            _buildPeriodChip('Este Año', setModalState),
          ],
        ),
        const SizedBox(height: 16),

        // Date range
        Row(
          children: [
            Expanded(
              child: _buildDateSelector('Desde', _startDate, setModalState),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateSelector('Hasta', _endDate, setModalState),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodChip(String label, StateSetter setModalState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
      ),
      child: Text(label),
    );
  }

  Widget _buildDateSelector(
    String label,
    DateTime date,
    StateSetter setModalState,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd/MM/yyyy').format(date),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsFilter(StateSetter setModalState) {
    final accounts = [
      'Todas',
      'Cheque',
      'Efectivo',
      'Tarjeta de Crédito',
      'Visa',
      'Mastercard',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuentas',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...accounts.map(
          (account) => CheckboxListTile(
            title: Text(account),
            value: _selectedAccounts.contains(account),
            onChanged: (value) {
              setModalState(() {
                if (value == true) {
                  _selectedAccounts.add(account);
                } else {
                  _selectedAccounts.remove(account);
                }
              });
            },
            activeColor: AppTheme.primaryGreen,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildTypesFilter(StateSetter setModalState) {
    final types = [
      'Todas',
      'Gastos',
      'Pagos',
      'Ingresos',
      'Transferencias',
      'Reembolso',
      'Compras a Meses',
      'Cashback',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Transacción',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...types.map(
          (type) => CheckboxListTile(
            title: Text(type),
            value: _selectedTypes.contains(type),
            onChanged: (value) {
              setModalState(() {
                if (value == true) {
                  _selectedTypes.add(type);
                } else {
                  _selectedTypes.remove(type);
                }
              });
            },
            activeColor: AppTheme.primaryBlue,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesFilter(StateSetter setModalState) {
    final categories = [
      'Todas',
      'Alojamiento',
      'Beneficios del Gobierno',
      'Entretenimiento',
      'Educación',
      'Salario',
      'Servicios',
      'Suscripciones',
      'Transporte',
      'Supermercado',
      'Restaurantes',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categorías',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          constraints: const BoxConstraints(maxHeight: 300),
          child: ListView(
            shrinkWrap: true,
            children: categories
                .map(
                  (category) => CheckboxListTile(
                    title: Text(category),
                    value: _selectedCategories.contains(category),
                    onChanged: (value) {
                      setModalState(() {
                        if (value == true) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                    activeColor: AppTheme.accentOrange,
                    contentPadding: EdgeInsets.zero,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurrenceFilter(StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recurrencia y Automatización',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        _buildToggleOption(
          'Recurrentes',
          _recurringFilter,
          (value) => setModalState(() => _recurringFilter = value),
        ),
        const SizedBox(height: 12),

        _buildToggleOption(
          'Pagos Automáticos',
          _autoPayFilter,
          (value) => setModalState(() => _autoPayFilter = value),
        ),
      ],
    );
  }

  Widget _buildToggleOption(
    String label,
    String? value,
    void Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildToggleButton('Sí', value == 'Sí', () => onChanged('Sí')),
              const SizedBox(width: 8),
              _buildToggleButton('No', value == 'No', () => onChanged('No')),
              const SizedBox(width: 8),
              _buildToggleButton(
                'Todo',
                value == 'Todo',
                () => onChanged('Todo'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.darkCardLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Reset filters
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.textSecondary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Restablecer'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Apply filters
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Aplicar Filtros'),
            ),
          ),
        ],
      ),
    );
  }
}

// Search delegate
class TransactionSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> transactions;

  TransactionSearchDelegate(this.transactions);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppTheme.darkCard,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: AppTheme.textSecondary),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = transactions.where((transaction) {
      final description = transaction['description'].toString().toLowerCase();
      final category = transaction['category'].toString().toLowerCase();
      return description.contains(query.toLowerCase()) ||
          category.contains(query.toLowerCase());
    }).toList();

    return Container(
      color: AppTheme.darkBackground,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final transaction = results[index];
          final isIncome = transaction['type'] == 'income';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(transaction['icon'], color: transaction['color']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction['description'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        transaction['category'],
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 2,
                  ).format(transaction['amount'].abs()),
                  style: TextStyle(
                    color: isIncome
                        ? AppTheme.primaryGreen
                        : AppTheme.accentRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
