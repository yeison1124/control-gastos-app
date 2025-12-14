import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../widgets/neumorphic_card.dart';

class AddIncomeScreen extends StatefulWidget {
  final String type; // 'income' or 'refund'

  const AddIncomeScreen({super.key, this.type = 'income'});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedDepositSource;
  String? _selectedDestinationAccount;
  String? _selectedCategory;
  bool _isRecurring = false;

  final List<Map<String, dynamic>> _depositSources = [
    {'name': 'Cheque', 'icon': Icons.receipt_long},
    {'name': 'Efectivo', 'icon': Icons.money},
    {'name': 'Cuenta Externa', 'icon': Icons.account_balance},
    {'name': 'Tarjeta de Crédito', 'icon': Icons.credit_card},
  ];

  final List<String> _destinationAccounts = [
    'Cuenta Corriente',
    'Cuenta de Ahorros',
    'Efectivo',
    'Tarjeta de Débito',
  ];

  final List<String> _incomeCategories = [
    'Salario',
    'Freelance',
    'Inversiones',
    'Regalo',
    'Bonificación',
    'Otros',
  ];

  final List<String> _refundCategories = [
    'Reembolso',
    'Devolución',
    'Cashback',
    'Recompensa',
    'Otros',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              surface: AppTheme.darkCard,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveIncome() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDepositSource == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una fuente de depósito'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      if (_selectedDestinationAccount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una cuenta destino'),
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
      final typeText = widget.type == 'income' ? 'Ingreso' : 'Reembolso';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$typeText guardado: \$${_amountController.text} - ${_descriptionController.text}',
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
    final title = widget.type == 'income'
        ? 'Registrar Ingreso'
        : 'Registrar Reembolso';
    final categories = widget.type == 'income'
        ? _incomeCategories
        : _refundCategories;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Text(title),
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
                      // Amount field
                      _buildAmountField(),
                      const SizedBox(height: 20),

                      // Description field
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Descripción',
                        hint: widget.type == 'income'
                            ? 'Ej: Pago de salario'
                            : 'Ej: Reembolso de compra',
                        icon: Icons.description,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una descripción';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Deposit source selector (chips)
                      _buildDepositSourceSelector(),
                      const SizedBox(height: 20),

                      // Destination account selector
                      _buildDropdownField(
                        label: 'Cuenta Destino',
                        icon: Icons.account_balance_wallet,
                        value: _selectedDestinationAccount,
                        items: _destinationAccounts,
                        onChanged: (value) {
                          setState(() {
                            _selectedDestinationAccount = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Date field
                      _buildDateField(),
                      const SizedBox(height: 20),

                      // Is recurring toggle
                      _buildToggleField(
                        label: 'Es Recurrente',
                        icon: Icons.repeat,
                        value: _isRecurring,
                        onChanged: (value) {
                          setState(() {
                            _isRecurring = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Category selector
                      _buildDropdownField(
                        label: 'Categoría',
                        icon: Icons.category,
                        value: _selectedCategory,
                        items: categories,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
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
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money, color: AppTheme.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                'Monto',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: AppTheme.textTertiary),
              prefixText: '\$ ',
              prefixStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.primaryGreen,
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

  Widget _buildDepositSourceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(Icons.input, color: AppTheme.accentPurple, size: 20),
              const SizedBox(width: 8),
              Text(
                'Fuente de Depósito',
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
          children: _depositSources.map((source) {
            final isSelected = _selectedDepositSource == source['name'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDepositSource = source['name'];
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.accentPurple.withOpacity(0.2)
                      : AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.accentPurple
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      source['icon'],
                      color: isSelected
                          ? AppTheme.accentPurple
                          : AppTheme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      source['name'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
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
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.type == 'income'
                      ? 'Fecha de Pago'
                      : 'Fecha de Transacción',
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
                  DateFormat('dd/MM/yyyy').format(_selectedDate),
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

  Widget _buildToggleField({
    required String label,
    required IconData icon,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accentOrange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryGreen,
            activeTrackColor: AppTheme.primaryGreen.withOpacity(0.5),
          ),
        ],
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
          onPressed: _saveIncome,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            'Guardar',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
