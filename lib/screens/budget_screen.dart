import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'categories_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  int _periodStartDay = 1;
  bool _includeScheduled = true;
  bool _monthlyBudgetEnabled = true;
  final TextEditingController _totalBudgetController = TextEditingController(
    text: '1500.00',
  );

  // Mock category limits
  final Map<String, Map<String, dynamic>> _categoryLimits = {
    'Alojamiento': {
      'icon': Icons.home,
      'color': Colors.purple,
      'limit': 800.00,
    },
    'Supermercado': {
      'icon': Icons.shopping_cart,
      'color': Colors.orange,
      'limit': 400.00,
    },
    'Transporte': {
      'icon': Icons.directions_bus,
      'color': Colors.indigo,
      'limit': 150.00,
    },
    'Restaurantes': {
      'icon': Icons.restaurant,
      'color': Colors.red,
      'limit': 200.00,
    },
    'Entretenimiento': {
      'icon': Icons.movie,
      'color': Colors.pink,
      'limit': 100.00,
    },
    'Servicios': {'icon': Icons.build, 'color': Colors.blue, 'limit': 150.00},
  };

  @override
  void dispose() {
    _totalBudgetController.dispose();
    super.dispose();
  }

  void _showDayPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 400,
        child: Column(
          children: [
            Text(
              'Día de Inicio del Periodo',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 31,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final isSelected = day == _periodStartDay;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _periodStartDay = day;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryGreen
                            : AppTheme.darkCardLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(title: const Text('Presupuesto'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period configuration
            _buildSectionTitle('Configuración del Periodo'),
            const SizedBox(height: 16),
            _buildPeriodStartDay(),
            const SizedBox(height: 16),
            _buildIncludeScheduledToggle(),
            const SizedBox(height: 32),

            // Monthly budget
            _buildSectionTitle('Límite Total Mensual'),
            const SizedBox(height: 16),
            _buildMonthlyBudgetToggle(),
            if (_monthlyBudgetEnabled) ...[
              const SizedBox(height: 16),
              _buildTotalBudgetField(),
            ],
            const SizedBox(height: 32),

            // Category limits
            _buildSectionTitle('Límites por Categoría'),
            const SizedBox(height: 16),
            _buildCategoryLimitsList(),
            const SizedBox(height: 16),
            _buildNewCategoryButton(),
            const SizedBox(height: 40),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Configuración guardada'),
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
                  'Guardar Configuración',
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
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPeriodStartDay() {
    return InkWell(
      onTap: _showDayPicker,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.calendar_today,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Día de Inicio del Periodo',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Día $_periodStartDay de cada mes',
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

  Widget _buildIncludeScheduledToggle() {
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
                  'Incluir Transacciones Programadas',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cuenta los gastos futuros programados para un presupuesto más preciso',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: _includeScheduled,
            onChanged: (value) {
              setState(() {
                _includeScheduled = value;
              });
            },
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyBudgetToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Presupuesto Mensual',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Switch(
            value: _monthlyBudgetEnabled,
            onChanged: (value) {
              setState(() {
                _monthlyBudgetEnabled = value;
              });
            },
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBudgetField() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen.withOpacity(0.2),
            AppTheme.primaryBlue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cantidad Máxima a Gastar',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _totalBudgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: '\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppTheme.darkCard,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLimitsList() {
    return Column(
      children: _categoryLimits.entries.map((entry) {
        final categoryName = entry.key;
        final categoryData = entry.value;
        return _buildCategoryLimitItem(
          categoryName,
          categoryData['icon'],
          categoryData['color'],
          categoryData['limit'],
        );
      }).toList(),
    );
  }

  Widget _buildCategoryLimitItem(
    String name,
    IconData icon,
    Color color,
    double limit,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),

          // Name
          Expanded(
            child: Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // Limit input
          SizedBox(
            width: 120,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                filled: true,
                fillColor: AppTheme.darkCardLight,
              ),
              controller: TextEditingController(text: limit.toStringAsFixed(2)),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewCategoryButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewCategoryScreen()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryGreen.withOpacity(0.5),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: AppTheme.primaryGreen, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'Nueva Categoría',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
