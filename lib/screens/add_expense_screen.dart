import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../widgets/neumorphic_card.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedAccount;
  String? _selectedCategory;

  final List<String> _accounts = [
    'Efectivo',
    'Cuenta Corriente',
    'Cuenta de Ahorros',
    'Tarjeta de Débito',
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Supermercado',
      'icon': Icons.shopping_cart,
      'color': AppTheme.primaryGreen,
    },
    {
      'name': 'Gasolina',
      'icon': Icons.local_gas_station,
      'color': AppTheme.accentOrange,
    },
    {
      'name': 'Restaurante',
      'icon': Icons.restaurant,
      'color': AppTheme.accentRed,
    },
    {
      'name': 'Transporte',
      'icon': Icons.directions_bus,
      'color': AppTheme.primaryBlue,
    },
    {
      'name': 'Entretenimiento',
      'icon': Icons.movie,
      'color': AppTheme.accentPurple,
    },
    {
      'name': 'Salud',
      'icon': Icons.local_hospital,
      'color': AppTheme.accentRed,
    },
    {'name': 'Servicios', 'icon': Icons.bolt, 'color': AppTheme.accentOrange},
    {
      'name': 'Otros',
      'icon': Icons.more_horiz,
      'color': AppTheme.textSecondary,
    },
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
      lastDate: DateTime.now(),
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

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      if (_selectedAccount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una cuenta'),
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
            'Gasto guardado: \$${_amountController.text} - ${_descriptionController.text}',
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
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Registrar Gasto'),
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
                        hint: 'Ej: Compra en supermercado',
                        icon: Icons.description,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una descripción';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Date field
                      _buildDateField(),
                      const SizedBox(height: 20),

                      // Account selector
                      _buildAccountSelector(),
                      const SizedBox(height: 20),

                      // Category selector
                      _buildCategorySelector(),
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
              Icon(Icons.attach_money, color: AppTheme.accentOrange, size: 20),
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
              color: AppTheme.accentOrange,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: AppTheme.textTertiary),
              prefixText: '\$ ',
              prefixStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.accentOrange,
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
                  'Fecha de Transacción',
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

  Widget _buildAccountSelector() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: AppTheme.accentPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Cuenta Seleccionada',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedAccount,
            dropdownColor: AppTheme.darkCard,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Selecciona una cuenta',
            ),
            items: _accounts.map((account) {
              return DropdownMenuItem(value: account, child: Text(account));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAccount = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(Icons.category, color: AppTheme.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Categoría',
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
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category['name'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category['name'];
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category['color'].withOpacity(0.2)
                      : AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? category['color'] : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(category['icon'], color: category['color'], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      category['name'],
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
          onPressed: _saveExpense,
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
