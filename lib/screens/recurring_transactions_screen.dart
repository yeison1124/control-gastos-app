import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

class RecurringTransactionsScreen extends StatefulWidget {
  const RecurringTransactionsScreen({super.key});

  @override
  State<RecurringTransactionsScreen> createState() =>
      _RecurringTransactionsScreenState();
}

class _RecurringTransactionsScreenState
    extends State<RecurringTransactionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data
  final List<Map<String, dynamic>> _incomeRecurrences = [
    {
      'icon': Icons.account_balance_wallet,
      'title': 'Salario',
      'frequency': 'Mensual',
      'nextDate': DateTime(2024, 11, 30),
      'amount': 3500.00,
      'isActive': true,
      'color': Colors.green,
    },
    {
      'icon': Icons.computer,
      'title': 'Freelance Cliente A',
      'frequency': 'Quincenal',
      'nextDate': DateTime(2024, 11, 15),
      'amount': 800.00,
      'isActive': true,
      'color': Colors.blue,
    },
  ];

  final List<Map<String, dynamic>> _paymentRecurrences = [
    {
      'icon': Icons.movie,
      'title': 'Netflix Premium',
      'frequency': 'Mensual',
      'nextDate': DateTime(2024, 11, 15),
      'amount': 15.99,
      'isActive': true,
      'color': Colors.red,
    },
    {
      'icon': Icons.music_note,
      'title': 'Spotify',
      'frequency': 'Mensual',
      'nextDate': DateTime(2024, 11, 20),
      'amount': 9.99,
      'isActive': true,
      'color': Colors.green,
    },
    {
      'icon': Icons.home,
      'title': 'Renta',
      'frequency': 'Mensual',
      'nextDate': DateTime(2024, 11, 1),
      'amount': 800.00,
      'isActive': true,
      'color': Colors.purple,
    },
    {
      'icon': Icons.wifi,
      'title': 'Internet',
      'frequency': 'Mensual',
      'nextDate': DateTime(2024, 11, 10),
      'amount': 45.00,
      'isActive': false,
      'color': Colors.blue,
    },
  ];

  final List<Map<String, dynamic>> _transferRecurrences = [
    {
      'icon': Icons.savings,
      'title': 'Ahorro Mensual',
      'frequency': 'Mensual',
      'nextDate': DateTime(2024, 11, 5),
      'amount': 500.00,
      'isActive': true,
      'color': Colors.orange,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showNewRecurrenceModal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewRecurrenceScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Transacciones Recurrentes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showNewRecurrenceModal,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryGreen,
          tabs: const [
            Tab(text: 'Ingresos'),
            Tab(text: 'Pagos'),
            Tab(text: 'Transferencias'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecurrenceList(_incomeRecurrences),
          _buildRecurrenceList(_paymentRecurrences),
          _buildRecurrenceList(_transferRecurrences),
        ],
      ),
    );
  }

  Widget _buildRecurrenceList(List<Map<String, dynamic>> recurrences) {
    if (recurrences.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.repeat, size: 80, color: AppTheme.textTertiary),
            const SizedBox(height: 16),
            Text(
              'No hay transacciones recurrentes',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: recurrences.length,
      itemBuilder: (context, index) {
        final recurrence = recurrences[index];
        return _buildRecurrenceCard(recurrence);
      },
    );
  }

  Widget _buildRecurrenceCard(Map<String, dynamic> recurrence) {
    final isActive = recurrence['isActive'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showNewRecurrenceModal(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? AppTheme.primaryGreen.withOpacity(0.3)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: recurrence['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  recurrence['icon'],
                  color: recurrence['color'],
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            recurrence['title'],
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppTheme.primaryGreen.withOpacity(0.2)
                                : AppTheme.textTertiary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppTheme.primaryGreen
                                      : AppTheme.textTertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isActive ? 'Activo' : 'Pausado',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isActive
                                      ? AppTheme.primaryGreen
                                      : AppTheme.textTertiary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${recurrence['frequency']} • Próximo: ${DateFormat('d MMM', 'es').format(recurrence['nextDate'])}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Amount
              Text(
                NumberFormat.currency(
                  symbol: '\$',
                  decimalDigits: 2,
                ).format(recurrence['amount']),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// New Recurrence Screen
class NewRecurrenceScreen extends StatefulWidget {
  const NewRecurrenceScreen({super.key});

  @override
  State<NewRecurrenceScreen> createState() => _NewRecurrenceScreenState();
}

class _NewRecurrenceScreenState extends State<NewRecurrenceScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isVariableAmount = false;
  String _selectedFrequency = 'Mensual';
  DateTime _startDate = DateTime.now();
  bool _autoCreate = true;
  bool _reminder = true;
  int _reminderDays = 3;
  String _weekendLogic = 'Mover al Lunes';

  final List<String> _frequencies = [
    'Diaria',
    'Semanal',
    'Quincenal',
    'Mensual',
    'Bimestral',
    'Trimestral',
    'Semestral',
    'Anual',
  ];

  final List<String> _weekendOptions = [
    'Mover al Lunes',
    'Mover al Viernes',
    'Mantener fecha',
    'Saltar',
  ];

  List<DateTime> _getUpcomingDates() {
    final dates = <DateTime>[];
    var currentDate = _startDate;

    for (int i = 0; i < 3; i++) {
      dates.add(currentDate);
      switch (_selectedFrequency) {
        case 'Diaria':
          currentDate = currentDate.add(const Duration(days: 1));
          break;
        case 'Semanal':
          currentDate = currentDate.add(const Duration(days: 7));
          break;
        case 'Quincenal':
          currentDate = currentDate.add(const Duration(days: 15));
          break;
        case 'Mensual':
          currentDate = DateTime(
            currentDate.year,
            currentDate.month + 1,
            currentDate.day,
          );
          break;
        case 'Bimestral':
          currentDate = DateTime(
            currentDate.year,
            currentDate.month + 2,
            currentDate.day,
          );
          break;
        case 'Trimestral':
          currentDate = DateTime(
            currentDate.year,
            currentDate.month + 3,
            currentDate.day,
          );
          break;
        case 'Semestral':
          currentDate = DateTime(
            currentDate.year,
            currentDate.month + 6,
            currentDate.day,
          );
          break;
        case 'Anual':
          currentDate = DateTime(
            currentDate.year + 1,
            currentDate.month,
            currentDate.day,
          );
          break;
      }
    }

    return dates;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Configurar Recurrencia'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount field
            _buildSectionTitle('Monto'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      hintText: '0.00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: AppTheme.darkCard,
                    ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Checkbox(
                      value: _isVariableAmount,
                      onChanged: (value) {
                        setState(() {
                          _isVariableAmount = value ?? false;
                        });
                      },
                      activeColor: AppTheme.primaryGreen,
                    ),
                    Text(
                      'Variable',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Frequency
            _buildSectionTitle('Frecuencia'),
            const SizedBox(height: 12),
            _buildFrequencySelector(),
            const SizedBox(height: 16),

            // Start date
            _buildDateSelector(),
            const SizedBox(height: 24),

            // Upcoming dates preview
            _buildUpcomingDatesPreview(),
            const SizedBox(height: 24),

            // Automation section
            _buildSectionTitle('Automatización'),
            const SizedBox(height: 12),
            _buildAutomationToggles(),
            const SizedBox(height: 24),

            // Weekend logic
            _buildSectionTitle('Lógica de Fin de Semana'),
            const SizedBox(height: 12),
            _buildWeekendLogicSelector(),
            const SizedBox(height: 40),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Recurrencia guardada'),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Guardar Programación',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFrequencySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
      ),
      child: DropdownButton<String>(
        value: _selectedFrequency,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: AppTheme.darkCard,
        items: _frequencies.map((frequency) {
          return DropdownMenuItem(value: frequency, child: Text(frequency));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedFrequency = value!;
          });
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _startDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            _startDate = date;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppTheme.primaryBlue),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Día de Inicio',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('d MMMM yyyy', 'es').format(_startDate),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingDatesPreview() {
    final upcomingDates = _getUpcomingDates();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_repeat, color: AppTheme.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Próximas fechas',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: upcomingDates.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final date = upcomingDates[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryGreen, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('d', 'es').format(date),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      Text(
                        DateFormat('MMM', 'es').format(date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutomationToggles() {
    return Column(
      children: [
        _buildToggleOption(
          'Crear Automáticamente',
          'Las transacciones se crearán sin confirmación',
          _autoCreate,
          (value) => setState(() => _autoCreate = value),
        ),
        const SizedBox(height: 16),
        _buildToggleOption(
          'Recordarme',
          'Recibir notificación antes de la fecha',
          _reminder,
          (value) => setState(() => _reminder = value),
        ),
        if (_reminder) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkCardLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Recordar con',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.darkCard,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int>(
                    value: _reminderDays,
                    underline: const SizedBox(),
                    dropdownColor: AppTheme.darkCard,
                    items: [1, 2, 3, 5, 7].map((days) {
                      return DropdownMenuItem(
                        value: days,
                        child: Text('$days días antes'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _reminderDays = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildToggleOption(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
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
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
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
            onChanged: onChanged,
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekendLogicSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Si cae en fin de semana:',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _weekendOptions.map((option) {
              final isSelected = _weekendLogic == option;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _weekendLogic = option;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryGreen
                        : AppTheme.darkCardLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGreen
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
