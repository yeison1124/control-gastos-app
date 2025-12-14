import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../widgets/neumorphic_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedMonth = DateTime.now();
  String _selectedView = 'Balance';
  String _selectedSegment = 'Total';
  bool _isBalanceExpanded = false;

  // Mock data
  final double monthlyIncome = 5420.00;
  final double monthlyExpenses = 3250.00;
  final double accountBalance = 4500.00;
  final double cardBalance = -1200.00;

  // Days with transactions (mock)
  final List<int> transactionDays = [1, 5, 8, 12, 15, 18, 22, 25, 28];

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildFiltersModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Calendario'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Monthly summary card
            _buildMonthlySummaryCard(),
            const SizedBox(height: 20),

            // Date navigation
            _buildDateNavigation(),
            const SizedBox(height: 16),

            // View options and segmentation
            _buildViewOptions(),
            const SizedBox(height: 12),
            _buildSegmentation(),
            const SizedBox(height: 20),

            // Calendar grid
            _buildCalendarGrid(),
            const SizedBox(height: 20),

            // Balance bar
            _buildBalanceBar(),
            const SizedBox(height: 20),

            // Transactions list
            _buildTransactionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlySummaryCard() {
    final balance = monthlyIncome - monthlyExpenses;
    final isPositive = balance >= 0;

    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resumen del Mes',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? AppTheme.primaryGreen : AppTheme.accentRed,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresos',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(
                        symbol: '\$',
                        decimalDigits: 2,
                      ).format(monthlyIncome),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gastos',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(
                        symbol: '\$',
                        decimalDigits: 2,
                      ).format(monthlyExpenses),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.accentRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPositive
                  ? AppTheme.primaryGreen.withOpacity(0.1)
                  : AppTheme.accentRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 2,
                  ).format(balance),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isPositive
                        ? AppTheme.primaryGreen
                        : AppTheme.accentRed,
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

  Widget _buildDateNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _previousMonth,
        ),
        Text(
          DateFormat('MMMM yyyy', 'es').format(_selectedMonth),
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  Widget _buildViewOptions() {
    return Row(
      children: [
        _buildViewChip('Balance'),
        const SizedBox(width: 12),
        _buildViewChip('Flujo de Efectivo'),
      ],
    );
  }

  Widget _buildViewChip(String label) {
    final isSelected = _selectedView == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedView = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : AppTheme.darkCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSegmentChip('Total'),
          const SizedBox(width: 8),
          _buildSegmentChip('Efectivo'),
          const SizedBox(width: 8),
          _buildSegmentChip('Banco'),
          const SizedBox(width: 8),
          _buildSegmentChip('Tarjeta'),
        ],
      ),
    );
  }

  Widget _buildSegmentChip(String label) {
    final isSelected = _selectedSegment == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSegment = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryGreen.withOpacity(0.2)
              : AppTheme.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday % 7;

    return NeumorphicCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['D', 'L', 'M', 'M', 'J', 'V', 'S']
                .map(
                  (day) => SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        day,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          // Calendar days
          ...List.generate((daysInMonth + firstWeekday) ~/ 7 + 1, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (dayIndex) {
                  final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;
                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox(width: 40, height: 40);
                  }
                  return _buildCalendarDay(dayNumber);
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(int day) {
    final hasTransaction = transactionDays.contains(day);
    final isToday =
        day == DateTime.now().day &&
        _selectedMonth.month == DateTime.now().month &&
        _selectedMonth.year == DateTime.now().year;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isToday ? AppTheme.primaryBlue.withOpacity(0.2) : null,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: AppTheme.primaryBlue, width: 2)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            day.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isToday ? AppTheme.primaryBlue : AppTheme.textPrimary,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (hasTransaction)
            Positioned(
              bottom: 4,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBalanceBar() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance al ${DateFormat('d \'de\' MMMM', 'es').format(DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0))}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  _isBalanceExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceExpanded = !_isBalanceExpanded;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  'Cuenta',
                  accountBalance,
                  AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildBalanceItem(
                  'Tarjeta',
                  cardBalance,
                  AppTheme.accentRed,
                ),
              ),
            ],
          ),
          if (_isBalanceExpanded) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.darkCardLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildSubBalanceItem('Cuenta Débito', 3200.00),
                  const SizedBox(height: 8),
                  _buildSubBalanceItem('Efectivo', 1300.00),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, double amount, Color color) {
    return Column(
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
          NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSubBalanceItem(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(
          NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(amount),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTransactionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transacciones del Mes',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildTransactionItem('Salario', 3500.00, '01 Nov', true),
        _buildTransactionItem('Supermercado', -150.00, '05 Nov', false),
        _buildTransactionItem('Gasolina', -45.00, '08 Nov', false),
        _buildTransactionItem('Freelance', 1200.00, '12 Nov', true),
        _buildTransactionItem('Restaurante', -80.00, '15 Nov', false),
      ],
    );
  }

  Widget _buildTransactionItem(
    String description,
    double amount,
    String date,
    bool isIncome,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isIncome
                  ? AppTheme.primaryGreen.withOpacity(0.2)
                  : AppTheme.accentRed.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? AppTheme.primaryGreen : AppTheme.accentRed,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            NumberFormat.currency(
              symbol: '\$',
              decimalDigits: 2,
            ).format(amount.abs()),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isIncome ? AppTheme.primaryGreen : AppTheme.accentRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
                  'Filtros',
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

          // Filters content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cuentas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterChip('Cuenta Débito', true),
                      _buildFilterChip('Cheque', false),
                      _buildFilterChip('Efectivo', true),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Transacciones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterChip('Todo', true),
                      _buildFilterChip('Ingresos', false),
                      _buildFilterChip('Pagos', false),
                      _buildFilterChip('Transferencias', false),
                      _buildFilterChip('Pago de Tarjeta', false),
                      _buildFilterChip('Compras a Meses', false),
                      _buildFilterChip('Gastos', false),
                      _buildFilterChip('Reembolso', false),
                      _buildFilterChip('Tax Cachas', false),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryBlue.withOpacity(0.2)
            : AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
          width: 2,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
