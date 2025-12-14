import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../widgets/neumorphic_card.dart';

class AddInstallmentScreen extends StatefulWidget {
  const AddInstallmentScreen({super.key});

  @override
  State<AddInstallmentScreen> createState() => _AddInstallmentScreenState();
}

class _AddInstallmentScreenState extends State<AddInstallmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _totalAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _startDate = DateTime.now();
  String? _selectedCard;
  String? _selectedCategory;
  int _selectedTerm = 3; // Default: 3 months
  double _monthlyInstallment = 0.0;

  final List<int> _termOptions = [3, 6, 9, 12, 18, 24];

  final List<String> _creditCards = [
    'Visa **** 1234',
    'Mastercard **** 5678',
    'American Express **** 9012',
    'Otra Tarjeta',
  ];

  final List<String> _categories = [
    'Electrónica',
    'Electrodomésticos',
    'Muebles',
    'Ropa',
    'Viajes',
    'Educación',
    'Otros',
  ];

  @override
  void initState() {
    super.initState();
    _totalAmountController.addListener(_calculateInstallment);
    _interestRateController.addListener(_calculateInstallment);
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _interestRateController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _calculateInstallment() {
    final amount = double.tryParse(_totalAmountController.text) ?? 0.0;
    final interestRate = double.tryParse(_interestRateController.text) ?? 0.0;

    if (amount > 0) {
      if (interestRate > 0) {
        // Calculate with interest (compound interest formula)
        final monthlyRate = interestRate / 100 / 12;
        final installment =
            amount *
            (monthlyRate * pow(1 + monthlyRate, _selectedTerm)) /
            (pow(1 + monthlyRate, _selectedTerm) - 1);
        setState(() {
          _monthlyInstallment = installment;
        });
      } else {
        // Interest-free installments
        setState(() {
          _monthlyInstallment = amount / _selectedTerm;
        });
      }
    } else {
      setState(() {
        _monthlyInstallment = 0.0;
      });
    }
  }

  double pow(double base, int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.accentPurple,
              onPrimary: Colors.white,
              surface: AppTheme.darkCard,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _saveInstallment() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCard == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una tarjeta'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una categoría'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // TODO: Save to Supabase
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Compra a meses guardada: \$${_totalAmountController.text} en $_selectedTerm meses',
          ),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Registrar Compra a Meses'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.accentPurple, AppTheme.accentOrange],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 12, color: Colors.white),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total amount field
                      _buildAmountField(),
                      const SizedBox(height: 20),

                      // Term selector (chips)
                      _buildTermSelector(),
                      const SizedBox(height: 16),

                      // Monthly installment calculation (highlighted)
                      _buildInstallmentCalculation(currencyFormat),
                      const SizedBox(height: 20),

                      // Card selector
                      _buildDropdownField(
                        label: 'Tarjeta Utilizada',
                        icon: Icons.credit_card,
                        value: _selectedCard,
                        items: _creditCards,
                        onChanged: (value) {
                          setState(() {
                            _selectedCard = value;
                          });
                        },
                        color: AppTheme.accentPurple,
                      ),
                      const SizedBox(height: 20),

                      // Start date field
                      _buildDateField(),
                      const SizedBox(height: 20),

                      // Interest rate field (optional)
                      _buildInterestRateField(),
                      const SizedBox(height: 20),

                      // Description field
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Descripción',
                        hint: 'Ej: Laptop nueva',
                        icon: Icons.description,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una descripción';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Category selector
                      _buildDropdownField(
                        label: 'Categoría',
                        icon: Icons.category,
                        value: _selectedCategory,
                        items: _categories,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(height: 20),

                      // Note field
                      _buildTextField(
                        controller: _noteController,
                        label: 'Nota (Opcional)',
                        hint: 'Agrega detalles adicionales...',
                        icon: Icons.note,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // Save button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentPurple.withOpacity(0.1),
            AppTheme.accentOrange.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: NeumorphicCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: AppTheme.accentPurple,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Monto Total de Compra',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _totalAmountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.accentPurple,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
                prefixText: '\$ ',
                prefixStyle: Theme.of(context).textTheme.displayMedium
                    ?.copyWith(
                      color: AppTheme.accentPurple,
                      fontWeight: FontWeight.bold,
                    ),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un monto';
                }
                if (double.tryParse(value) == null) {
                  return 'Ingresa un monto válido';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: AppTheme.accentOrange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Plazo (Meses)',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _termOptions.map((term) {
            final isSelected = _selectedTerm == term;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTerm = term;
                  _calculateInstallment();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppTheme.accentPurple,
                            AppTheme.accentOrange,
                          ],
                        )
                      : null,
                  color: isSelected ? null : AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppTheme.textTertiary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '$term meses',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
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
    );
  }

  Widget _buildInstallmentCalculation(NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen.withOpacity(0.2),
            AppTheme.primaryBlue.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calculate,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Cuota Mensual Estimada',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currencyFormat.format(_monthlyInstallment),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'x $_selectedTerm',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (_interestRateController.text.isNotEmpty &&
              double.tryParse(_interestRateController.text) != null &&
              double.parse(_interestRateController.text) > 0) ...[
            const SizedBox(height: 8),
            Text(
              'TIA: ${_interestRateController.text}%',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 14,
                  color: AppTheme.primaryGreen,
                ),
                const SizedBox(width: 4),
                Text(
                  'Sin intereses',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInterestRateField() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.percent, color: AppTheme.accentOrange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tasa de Interés Anual (TIA)',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
              const SizedBox(width: 8),
              Text(
                '(Opcional)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _interestRateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: Theme.of(context).textTheme.titleLarge,
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.textTertiary),
              suffixText: '%',
              suffixStyle: Theme.of(context).textTheme.titleLarge,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textTertiary),
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required Color color,
  }) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: value,
            dropdownColor: AppTheme.darkCard,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Selecciona una opción',
            ),
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event, color: AppTheme.accentPurple, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Fecha de Inicio de Pago',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(_startDate),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
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
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _saveInstallment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            padding: EdgeInsets.zero,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accentPurple, AppTheme.accentOrange],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Guardar',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
