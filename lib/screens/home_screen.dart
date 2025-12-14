import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../widgets/neumorphic_card.dart';
import '../config/theme.dart';
import 'add_transaction_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final NumberFormat currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  // Mock data - will be replaced with Supabase data
  final double currentBalance = 5420.50;
  final double projectedBalance = 6200.00;
  final double projectedExpenses = 1850.00;
  final double remainingPercentage = 65.0;
  final double generalExpenses = 1250.00;
  final double cardExpenses = 450.00;
  final double incomeReceived = 3500.00;
  final double cashFlowIncome = 4200.00;
  final double cashFlowExpenses = 2100.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            _buildTopBar(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Header section
                    _buildHeader(),

                    const SizedBox(height: 24),

                    // Financial summary card
                    _buildFinancialSummaryCard(),

                    const SizedBox(height: 24),

                    // Swipeable expense cards
                    _buildExpenseCards(),

                    const SizedBox(height: 24),

                    // Cash flow card
                    _buildCashFlowCard(),

                    const SizedBox(height: 24),

                    // Upcoming payments
                    _buildUpcomingPayments(),

                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const AddTransactionModal(),
              opaque: false,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),

      // Bottom navigation bar
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cloud icon (premium feature - now unlocked)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              FontAwesomeIcons.cloud,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
          ),

          // Hamburger menu
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.menu,
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Inicio', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Disponible', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 16),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppTheme.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Text('A pagar', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialSummaryCard() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Balances
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceItem(
                'Saldo Actual',
                currentBalance,
                AppTheme.primaryGreen,
              ),
              _buildBalanceItem(
                'Saldo Proyectado',
                projectedBalance,
                AppTheme.primaryBlue,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Projected expenses
          Row(
            children: [
              Text(
                'Gastos Proyectados',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              Text(
                currencyFormat.format(projectedExpenses),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: AppTheme.accentOrange),
              ),
            ],
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
                    centerSpaceRadius: 60,
                    sections: [
                      PieChartSectionData(
                        value: remainingPercentage,
                        color: AppTheme.primaryGreen,
                        radius: 30,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 100 - remainingPercentage,
                        color: AppTheme.darkCardDark,
                        radius: 30,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${remainingPercentage.toInt()}%',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    Text(
                      'Parte Restante',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Text('Este Mes', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          currencyFormat.format(amount),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseCards() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildExpenseCard(
            'Gastos Generales',
            generalExpenses,
            Icons.shopping_cart,
            AppTheme.primaryGreen,
            isLocked: false,
          ),
          const SizedBox(width: 16),
          _buildExpenseCard(
            'Gasto de Tarjetas',
            cardExpenses,
            Icons.credit_card,
            AppTheme.accentOrange,
            isLocked: false,
          ),
          const SizedBox(width: 16),
          _buildExpenseCard(
            'Ingresos Recibidos',
            incomeReceived,
            Icons.trending_up,
            AppTheme.primaryBlue,
            isLocked: false,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(
    String title,
    double amount,
    IconData icon,
    Color color, {
    bool isLocked = false,
  }) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.zero,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                if (isLocked)
                  Icon(Icons.lock, color: AppTheme.textTertiary, size: 16),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormat.format(amount),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashFlowCard() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flujo de Efectivo',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),

          // Simple bar chart representation
          Row(
            children: [
              Expanded(
                flex:
                    (cashFlowIncome / (cashFlowIncome + cashFlowExpenses) * 100)
                        .toInt(),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    currencyFormat.format(cashFlowIncome),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex:
                    (cashFlowExpenses /
                            (cashFlowIncome + cashFlowExpenses) *
                            100)
                        .toInt(),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.accentRed,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    currencyFormat.format(cashFlowExpenses),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCashFlowLegend('Ingresos', AppTheme.primaryGreen),
              _buildCashFlowLegend('Egresos', AppTheme.accentRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildUpcomingPayments() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Próximos Pagos', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          // Placeholder items
          _buildPaymentItem('Renta', '\$800.00', '15 Dic'),
          const SizedBox(height: 12),
          _buildPaymentItem('Internet', '\$50.00', '20 Dic'),
          const SizedBox(height: 12),
          _buildPaymentItem('Electricidad', '\$75.00', '22 Dic'),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(String title, String amount, String date) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.darkCardLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.calendar_today,
            color: AppTheme.primaryBlue,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              Text(date, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Text(
          amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.accentOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
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
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Gráficos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Cuentas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Recientes',
          ),
        ],
      ),
    );
  }
}
