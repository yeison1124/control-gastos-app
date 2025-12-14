import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../widgets/neumorphic_card.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Debit accounts data
  double _checkingBalance = 3200.00;
  double _cashBalance = 1300.00;

  // Credit cards data
  final List<Map<String, dynamic>> _creditCards = [
    {
      'name': 'Visa Gold',
      'balance': 1200.00,
      'limit': 5000.00,
      'apr': 24.0,
      'cutoffDay': 15,
      'dueDay': 25,
      'points': 15000,
      'pointsValue': 150.00,
    },
    {
      'name': 'Mastercard Platinum',
      'balance': 800.00,
      'limit': 3000.00,
      'apr': 18.0,
      'cutoffDay': 20,
      'dueDay': 30,
      'points': 8000,
      'pointsValue': 80.00,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showUpdateBalanceModal(String accountType, double currentBalance) {
    final controller = TextEditingController(text: currentBalance.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: Text('Actualizar Balance - $accountType'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Nuevo Balance',
            prefixText: '\$ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final newBalance =
                  double.tryParse(controller.text) ?? currentBalance;
              setState(() {
                if (accountType == 'Cheque') {
                  _checkingBalance = newBalance;
                } else if (accountType == 'Efectivo') {
                  _cashBalance = newBalance;
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
            ),
            child: const Text('Actualizar Balance'),
          ),
        ],
      ),
    );
  }

  void _showCardDetailModal(Map<String, dynamic> card) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CardDetailScreen(cardData: card)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalDebt = _creditCards.fold<double>(
      0,
      (sum, card) => sum + card['balance'],
    );
    final totalLimit = _creditCards.fold<double>(
      0,
      (sum, card) => sum + card['limit'],
    );

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Cuentas'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryGreen,
          tabs: const [
            Tab(text: 'Cuentas Débito'),
            Tab(text: 'Tarjeta de Crédito'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Debit accounts tab
          _buildDebitAccountsView(),

          // Credit cards tab (Premium)
          _buildCreditCardsView(totalDebt, totalLimit),
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

  Widget _buildDebitAccountsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Checking account
          _buildDebitAccountCard(
            'Cheque',
            _checkingBalance,
            Icons.account_balance,
            AppTheme.primaryBlue,
          ),
          const SizedBox(height: 16),

          // Cash account
          _buildDebitAccountCard(
            'Efectivo',
            _cashBalance,
            Icons.money,
            AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildDebitAccountCard(
    String accountName,
    double balance,
    IconData icon,
    Color color,
  ) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accountName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(
                        symbol: '\$',
                        decimalDigits: 2,
                      ).format(balance),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showUpdateBalanceModal(accountName, balance),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Transacciones Recientes',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildRecentTransaction('Depósito', 500.00, '10 Dic', true),
          _buildRecentTransaction('Retiro', -200.00, '08 Dic', false),
          _buildRecentTransaction('Transferencia', -150.00, '05 Dic', false),
        ],
      ),
    );
  }

  Widget _buildRecentTransaction(
    String description,
    double amount,
    String date,
    bool isIncome,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkCardLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? AppTheme.primaryGreen : AppTheme.accentRed,
            size: 16,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(description)),
          Text(
            date,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 12),
          Text(
            NumberFormat.currency(
              symbol: '\$',
              decimalDigits: 2,
            ).format(amount.abs()),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isIncome ? AppTheme.primaryGreen : AppTheme.accentRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardsView(double totalDebt, double totalLimit) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.accentPurple.withOpacity(0.05),
            AppTheme.darkBackground,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Premium badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.accentPurple, AppTheme.accentOrange],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Sección Premium',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Total summary
            NeumorphicCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Resumen de Deuda',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Balance Total',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              NumberFormat.currency(
                                symbol: '\$',
                                decimalDigits: 2,
                              ).format(totalDebt),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppTheme.accentRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppTheme.textTertiary,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Límite Total',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              NumberFormat.currency(
                                symbol: '\$',
                                decimalDigits: 2,
                              ).format(totalLimit),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Credit cards list
            ..._creditCards.map(
              (card) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCreditCardItem(card),
              ),
            ),

            const SizedBox(height: 12),

            // Sync button
            OutlinedButton.icon(
              onPressed: () {
                // Sync cards
              },
              icon: const Icon(Icons.sync),
              label: const Text('Sincronizar Tarjetas (Premium)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.accentPurple,
                side: BorderSide(color: AppTheme.accentPurple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardItem(Map<String, dynamic> card) {
    final utilizationRate = (card['balance'] / card['limit'] * 100).round();

    return GestureDetector(
      onTap: () => _showCardDetailModal(card),
      child: NeumorphicCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.accentPurple, AppTheme.primaryBlue],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.credit_card,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card['name'],
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        NumberFormat.currency(
                          symbol: '\$',
                          decimalDigits: 2,
                        ).format(card['balance']),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.accentRed,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Tasa de Utilización',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '$utilizationRate%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: utilizationRate > 70
                        ? AppTheme.accentRed
                        : utilizationRate > 30
                        ? AppTheme.accentOrange
                        : AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: utilizationRate / 100,
                backgroundColor: AppTheme.darkCardLight,
                valueColor: AlwaysStoppedAnimation(
                  utilizationRate > 70
                      ? AppTheme.accentRed
                      : utilizationRate > 30
                      ? AppTheme.accentOrange
                      : AppTheme.primaryGreen,
                ),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Card Detail Screen (Premium)
class CardDetailScreen extends StatefulWidget {
  final Map<String, dynamic> cardData;

  const CardDetailScreen({super.key, required this.cardData});

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  late TextEditingController _limitController;
  late TextEditingController _aprController;
  late TextEditingController _pointsController;
  late TextEditingController _paymentController;

  int _cutoffDay = 15;
  int _dueDay = 25;
  double _projectedMonths = 0;
  double _projectedInterest = 0;

  @override
  void initState() {
    super.initState();
    _limitController = TextEditingController(
      text: widget.cardData['limit'].toString(),
    );
    _aprController = TextEditingController(
      text: widget.cardData['apr'].toString(),
    );
    _pointsController = TextEditingController(
      text: widget.cardData['points'].toString(),
    );
    _paymentController = TextEditingController(text: '500');
    _cutoffDay = widget.cardData['cutoffDay'];
    _dueDay = widget.cardData['dueDay'];
  }

  @override
  void dispose() {
    _limitController.dispose();
    _aprController.dispose();
    _pointsController.dispose();
    _paymentController.dispose();
    super.dispose();
  }

  void _calculateProjection() {
    final balance = widget.cardData['balance'];
    final payment = double.tryParse(_paymentController.text) ?? 0;
    final apr = double.tryParse(_aprController.text) ?? 0;

    if (payment > 0 && apr > 0) {
      final monthlyRate = apr / 100 / 12;
      var remainingBalance = balance;
      var months = 0;
      var totalInterest = 0.0;

      while (remainingBalance > 0 && months < 360) {
        final interest = remainingBalance * monthlyRate;
        totalInterest += interest;
        remainingBalance = remainingBalance + interest - payment;
        months++;

        if (remainingBalance < 0) remainingBalance = 0;
      }

      setState(() {
        _projectedMonths = months.toDouble();
        _projectedInterest = totalInterest;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final utilizationRate =
        (widget.cardData['balance'] / double.parse(_limitController.text) * 100)
            .round();

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Text('Detalle - ${widget.cardData['name']}'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accentPurple, AppTheme.accentOrange],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Premium',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cycle summary
            _buildCycleSummary(utilizationRate),
            const SizedBox(height: 20),

            // Debt analysis
            _buildDebtAnalysis(),
            const SizedBox(height: 20),

            // Payment projection
            _buildPaymentProjection(),
            const SizedBox(height: 20),

            // Rewards center
            _buildRewardsCenter(),
            const SizedBox(height: 20),

            // Actions
            _buildActions(),
            const SizedBox(height: 20),

            // Installment purchases
            _buildInstallmentPurchases(),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleSummary(int utilizationRate) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen del Ciclo',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Balance Actual',
                  NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 2,
                  ).format(widget.cardData['balance']),
                  AppTheme.accentRed,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Límite de Crédito',
                  NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 2,
                  ).format(double.parse(_limitController.text)),
                  AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            'Tasa de Utilización',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: utilizationRate / 100,
                    backgroundColor: AppTheme.darkCardLight,
                    valueColor: AlwaysStoppedAnimation(
                      utilizationRate > 70
                          ? AppTheme.accentRed
                          : utilizationRate > 30
                          ? AppTheme.accentOrange
                          : AppTheme.primaryGreen,
                    ),
                    minHeight: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$utilizationRate%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: utilizationRate > 70
                      ? AppTheme.accentRed
                      : utilizationRate > 30
                      ? AppTheme.accentOrange
                      : AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _buildDateField('Día de Corte', _cutoffDay)),
              const SizedBox(width: 12),
              Expanded(child: _buildDateField('Día Límite', _dueDay)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
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
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, int day) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkCardLight,
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
            'Día $day',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDebtAnalysis() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Análisis de Deuda',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _aprController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Tasa de Interés Anual (TIA)',
              suffixText: '%',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.accentOrange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.accentOrange),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Intereses Pagados Este Ciclo: \$45.00',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentProjection() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calculate, color: AppTheme.primaryGreen),
              const SizedBox(width: 8),
              Text(
                'Proyección de Pago',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _paymentController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Quiero pagar mensualmente',
              prefixText: '\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) => _calculateProjection(),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: _calculateProjection,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Calcular Proyección'),
          ),

          if (_projectedMonths > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.2),
                    AppTheme.primaryBlue.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Saldarás en:'),
                      Text(
                        '${_projectedMonths.toInt()} meses',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pagarás en intereses:'),
                      Text(
                        NumberFormat.currency(
                          symbol: '\$',
                          decimalDigits: 2,
                        ).format(_projectedInterest),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppTheme.accentOrange,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRewardsCenter() {
    final pointsValue = widget.cardData['pointsValue'];

    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: AppTheme.accentOrange),
              const SizedBox(width: 8),
              Text(
                'Centro de Recompensas',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _pointsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Saldo de Puntos/Millas',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Valor Estimado:'),
                Text(
                  NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 2,
                  ).format(pointsValue),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Esta tarjeta te da más puntos en Viajes',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              // Register payment
            },
            icon: const Icon(Icons.payment),
            label: const Text('Registrar Pago a Tarjeta'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstallmentPurchases() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compras a Meses',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _buildInstallmentItem('Laptop', 12, 6, 250.00),
          _buildInstallmentItem('Refrigerador', 18, 12, 150.00),
        ],
      ),
    );
  }

  Widget _buildInstallmentItem(
    String item,
    int totalMonths,
    int remaining,
    double monthlyPayment,
  ) {
    final progress = (totalMonths - remaining) / totalMonths;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkCardLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                NumberFormat.currency(
                  symbol: '\$',
                  decimalDigits: 2,
                ).format(monthlyPayment),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.accentOrange),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.darkBackground,
                    valueColor: AlwaysStoppedAnimation(AppTheme.primaryGreen),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$remaining/$totalMonths',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
