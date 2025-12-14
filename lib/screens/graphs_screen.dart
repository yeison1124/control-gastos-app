import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/theme.dart';
import '../widgets/neumorphic_card.dart';

class GraphsScreen extends StatefulWidget {
  const GraphsScreen({super.key});

  @override
  State<GraphsScreen> createState() => _GraphsScreenState();
}

class _GraphsScreenState extends State<GraphsScreen> {
  DateTime _selectedMonth = DateTime.now();
  bool _sortAscending = true;

  // Mock data
  final double monthlyBudget = 5000.00;
  final double totalExpenses = 3250.00;
  final double totalIncome = 5420.00;

  final Map<String, double> expensesByCategory = {
    'Supermercado': 850.00,
    'Restaurantes': 650.00,
    'Transporte': 450.00,
    'Entretenimiento': 400.00,
    'Servicios': 350.00,
    'Otros': 550.00,
  };

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

  void _toggleSort() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }

  void _showBudgetSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildBudgetSettingsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining = monthlyBudget - totalExpenses;
    final percentageRemaining = (remaining / monthlyBudget * 100).round();

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation bar
            _buildTopNavigationBar(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Main donut chart
                    _buildMainChart(remaining, percentageRemaining),
                    const SizedBox(height: 24),

                    // Summary cards
                    _buildExpensesVsIncomeCard(),
                    const SizedBox(height: 12),
                    _buildTopCategoryCard(),
                    const SizedBox(height: 12),
                    _buildTopIncomeSourceCard(),
                    const SizedBox(height: 24),

                    // Finance suggestions
                    _buildFinanceSuggestions(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildTopNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          // Previous month
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
          ),

          // Month and year
          Expanded(
            child: Center(
              child: Text(
                DateFormat('MMMM yyyy', 'es').format(_selectedMonth),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Next month
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
          ),

          const SizedBox(width: 8),

          // Sort button
          IconButton(
            icon: Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            onPressed: _toggleSort,
          ),

          // Budget settings button
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showBudgetSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildMainChart(double remaining, int percentageRemaining) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Presupuesto Mensual',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),

          // Donut chart
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    sections: [
                      PieChartSectionData(
                        value: totalExpenses,
                        color: AppTheme.accentRed,
                        title: '',
                        radius: 30,
                      ),
                      PieChartSectionData(
                        value: remaining,
                        color: AppTheme.primaryGreen,
                        title: '',
                        radius: 30,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percentageRemaining%',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    Text(
                      'Restante',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Gastado', totalExpenses, AppTheme.accentRed),
              _buildLegendItem('Restante', remaining, AppTheme.primaryGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, double amount, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),
            Text(
              NumberFormat.currency(
                symbol: '\$',
                decimalDigits: 2,
              ).format(amount),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpensesVsIncomeCard() {
    final isPositive = totalIncome > totalExpenses;
    final difference = totalIncome - totalExpenses;

    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPositive
                  ? AppTheme.primaryGreen.withOpacity(0.2)
                  : AppTheme.accentRed.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              color: isPositive ? AppTheme.primaryGreen : AppTheme.accentRed,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gastos vs Ingresos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isPositive
                      ? 'Superávit de ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(difference)}'
                      : 'Déficit de ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(difference.abs())}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isPositive
                        ? AppTheme.primaryGreen
                        : AppTheme.accentRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCategoryCard() {
    final topCategory = expensesByCategory.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentOrange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.shopping_cart,
              color: AppTheme.accentOrange,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categoría de Mayor Gasto',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${topCategory.key}: ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(topCategory.value)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.accentOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopIncomeSourceCard() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: AppTheme.primaryBlue,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fuente de Mayor Ingreso',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Salario: ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(3500.00)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceSuggestions() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppTheme.accentOrange, size: 24),
              const SizedBox(width: 12),
              Text(
                'Sugerencias para Mejorar las Finanzas',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSuggestionItem(
            '💰',
            'Estás gastando mucho en Supermercado. Considera reducir un 15% este mes.',
          ),
          const SizedBox(height: 12),
          _buildSuggestionItem(
            '🎯',
            'Vas por buen camino. Te quedan ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(monthlyBudget - totalExpenses)} del presupuesto.',
          ),
          const SizedBox(height: 12),
          _buildSuggestionItem(
            '📊',
            'Tus ingresos superan tus gastos. ¡Buen trabajo! Considera ahorrar el excedente.',
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetSettingsModal() {
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
                  'Presupuesto y Configuración',
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

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Monthly budget
                  _buildBudgetInputField(
                    'Límite de Gastos',
                    'Presupuesto mensual total',
                    Icons.account_balance_wallet,
                    monthlyBudget.toString(),
                  ),
                  const SizedBox(height: 20),

                  // Period start day
                  _buildDaySelector(),
                  const SizedBox(height: 20),

                  // Include scheduled transactions
                  _buildToggleSetting(
                    'Incluir Transacciones Programadas',
                    'Incluir en el cálculo del gasto actual',
                    true,
                  ),
                  const SizedBox(height: 24),

                  // Category limits
                  Text(
                    'Límites de Gastos por Categoría',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...expensesByCategory.keys.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildCategoryLimitField(category, 500.00),
                    );
                  }),

                  const SizedBox(height: 16),

                  // New category button
                  OutlinedButton.icon(
                    onPressed: () {
                      // Add new category
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nueva Categoría'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                      side: BorderSide(color: AppTheme.primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save button
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
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Save settings
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Guardar Configuración',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetInputField(
    String label,
    String hint,
    IconData icon,
    String value,
  ) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: value,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hint,
              prefixText: '\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.textTertiary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: AppTheme.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Día de Inicio del Periodo',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: 1,
            dropdownColor: AppTheme.darkCard,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.textTertiary),
              ),
            ),
            items: List.generate(28, (index) => index + 1)
                .map(
                  (day) => DropdownMenuItem(
                    value: day,
                    child: Text('Día $day del mes'),
                  ),
                )
                .toList(),
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSetting(String title, String subtitle, bool value) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {},
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLimitField(String category, double limit) {
    return NeumorphicCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              category,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(
            width: 120,
            child: TextFormField(
              initialValue: limit.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                prefixText: '\$ ',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
