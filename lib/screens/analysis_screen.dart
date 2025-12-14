import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int _selectedReportIndex = 0;

  final List<Map<String, dynamic>> _reports = [
    {
      'title': 'Flujo de Efectivo',
      'icon': Icons.trending_up,
      'color': Colors.blue,
    },
    {
      'title': 'Gastos por Categoría',
      'icon': Icons.pie_chart,
      'color': Colors.red,
    },
    {
      'title': 'Historial de Gastos',
      'icon': Icons.show_chart,
      'color': Colors.orange,
    },
    {
      'title': 'Ingresos por Categoría',
      'icon': Icons.account_balance,
      'color': Colors.green,
    },
    {
      'title': 'Historial de Ingresos',
      'icon': Icons.timeline,
      'color': Colors.teal,
    },
    {
      'title': 'Tarjetas de Crédito',
      'icon': Icons.credit_card,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(title: const Text('Análisis'), centerTitle: true),
      body: Column(
        children: [
          // Reports carousel
          _buildReportsCarousel(),

          // Selected report content
          Expanded(child: _buildReportContent()),
        ],
      ),
    );
  }

  Widget _buildReportsCarousel() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          final isSelected = index == _selectedReportIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedReportIndex = index;
              });
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          report['color'].withOpacity(0.8),
                          report['color'],
                        ],
                      )
                    : null,
                color: isSelected ? null : AppTheme.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? report['color'] : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: report['color'].withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    report['icon'],
                    color: isSelected ? Colors.white : report['color'],
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    report['title'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportContent() {
    // For now, only implement Credit Cards report
    // Others will show "Coming soon"
    if (_selectedReportIndex == 5) {
      return const CreditCardsReportScreen();
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _reports[_selectedReportIndex]['icon'],
              size: 80,
              color: _reports[_selectedReportIndex]['color'],
            ),
            const SizedBox(height: 16),
            Text(
              _reports[_selectedReportIndex]['title'],
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Próximamente',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }
  }
}

// Credit Cards Report Screen
class CreditCardsReportScreen extends StatefulWidget {
  const CreditCardsReportScreen({super.key});

  @override
  State<CreditCardsReportScreen> createState() =>
      _CreditCardsReportScreenState();
}

class _CreditCardsReportScreenState extends State<CreditCardsReportScreen> {
  String _selectedPeriod = 'Mes';

  // Mock data
  final double _totalBalance = 2000.00;
  final double _totalLimit = 8000.00;
  final double _creditUsagePercentage = 25.0;

  final List<Map<String, dynamic>> _cards = [
    {
      'name': 'Visa Gold',
      'balance': 1200.00,
      'limit': 5000.00,
      'color': Colors.blue,
    },
    {
      'name': 'Mastercard Platinum',
      'balance': 800.00,
      'limit': 3000.00,
      'color': Colors.orange,
    },
  ];

  final List<Map<String, dynamic>> _recurringPayments = [
    {'name': 'Netflix', 'amount': 15.99},
    {'name': 'Spotify', 'amount': 9.99},
    {'name': 'Gimnasio', 'amount': 50.00},
  ];

  final Map<String, double> _categoryExpenses = {
    'Restaurantes': 450.00,
    'Suscripciones': 75.98,
    'Ropa': 320.00,
    'Entretenimiento': 180.00,
    'Gasolina': 200.00,
  };

  @override
  Widget build(BuildContext context) {
    final available = _totalLimit - _totalBalance;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Credit usage donut chart
          _buildCreditUsageChart(),
          const SizedBox(height: 24),

          // Financial summary
          _buildFinancialSummary(available),
          const SizedBox(height: 24),

          // Cards detail
          _buildSectionTitle('Detalle por Tarjeta'),
          const SizedBox(height: 16),
          ..._cards.map((card) => _buildCardDetail(card)),
          const SizedBox(height: 24),

          // Recurring payments
          _buildSectionTitle('Pagos Mensuales'),
          const SizedBox(height: 16),
          _buildRecurringPayments(),
          const SizedBox(height: 24),

          // Spending chart
          _buildSectionTitle('Gasto por Tarjeta'),
          const SizedBox(height: 16),
          _buildPeriodSelector(),
          const SizedBox(height: 16),
          _buildSpendingChart(),
          const SizedBox(height: 24),

          // Category breakdown
          _buildSectionTitle('Desglose por Categoría'),
          const SizedBox(height: 16),
          _buildCategoryBreakdown(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCreditUsageChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Uso de Crédito',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
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
                        value: _creditUsagePercentage,
                        color: _creditUsagePercentage > 50
                            ? AppTheme.accentRed
                            : _creditUsagePercentage > 30
                            ? AppTheme.accentOrange
                            : AppTheme.primaryGreen,
                        radius: 40,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 100 - _creditUsagePercentage,
                        color: AppTheme.darkCardDark,
                        radius: 40,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_creditUsagePercentage.toInt()}%',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _creditUsagePercentage > 50
                            ? AppTheme.accentRed
                            : _creditUsagePercentage > 30
                            ? AppTheme.accentOrange
                            : AppTheme.primaryGreen,
                      ),
                    ),
                    Text(
                      'Usado',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary(double available) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balance Total',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 2,
                  ).format(_totalBalance),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentRed,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Límite Total',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 2,
                  ).format(_totalLimit),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardDetail(Map<String, dynamic> card) {
    final usage = (card['balance'] / card['limit'] * 100).toInt();
    final available = card['limit'] - card['balance'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: card['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.credit_card, color: card['color'], size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  card['name'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '$usage%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: usage > 50
                      ? AppTheme.accentRed
                      : AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disponible',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                      symbol: '\$',
                      decimalDigits: 2,
                    ).format(available),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Límite',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                      symbol: '\$',
                      decimalDigits: 2,
                    ).format(card['limit']),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringPayments() {
    final total = _recurringPayments.fold<double>(
      0,
      (sum, payment) => sum + payment['amount'],
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ..._recurringPayments.map(
            (payment) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    payment['name'],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    NumberFormat.currency(
                      symbol: '\$',
                      decimalDigits: 2,
                    ).format(payment['amount']),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance Restante',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                NumberFormat.currency(
                  symbol: '\$',
                  decimalDigits: 2,
                ).format(total),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['Semana', 'Mes', 'Año', 'Rango'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: periods.map((period) {
        final isSelected = period == _selectedPeriod;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPeriod = period;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlue : AppTheme.darkCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : AppTheme.textTertiary.withOpacity(0.3),
              ),
            ),
            child: Text(
              period,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpendingChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1500,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const weeks = ['S1', 'S2', 'S3', 'S4'];
                  if (value.toInt() < weeks.length) {
                    return Text(
                      weeks[value.toInt()],
                      style: TextStyle(color: AppTheme.textSecondary),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 800,
                  color: AppTheme.primaryBlue,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 1200,
                  color: AppTheme.primaryBlue,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 600,
                  color: AppTheme.primaryBlue,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  toY: 1000,
                  color: AppTheme.primaryBlue,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    final total = _categoryExpenses.values.fold<double>(
      0,
      (sum, value) => sum + value,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ..._categoryExpenses.entries.map((entry) {
            final percentage = (entry.value / total * 100).toInt();
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        NumberFormat.currency(
                          symbol: '\$',
                          decimalDigits: 2,
                        ).format(entry.value),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: entry.value / total,
                    backgroundColor: AppTheme.darkCardLight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryBlue,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$percentage%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total General',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                NumberFormat.currency(
                  symbol: '\$',
                  decimalDigits: 2,
                ).format(total),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
