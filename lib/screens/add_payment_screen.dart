import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../widgets/neumorphic_card.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedPaidDate = DateTime.now();
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 7));
  String? _selectedAccount;
  String? _selectedCategory;
  bool _isRecurring = false;
  bool _hasReminder = false;
  bool _isAutoPay = false;

  final List<String> _accounts = [
    'Débito',
    'Tarjeta de Crédito',
    'Efectivo',
    'Cuenta Corriente',
  ];

  final List<String> _categories = [
    'Servicios',
    'Renta',
    'Internet',
    'Electricidad',
    'Agua',
    'Gas',
    'Teléfono',
    'Otros',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isDueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDueDate ? _selectedDueDate : _selectedPaidDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.accentOrange,
              onPrimary: Colors.white,
              surface: AppTheme.darkCard,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isDueDate) {
          _selectedDueDate = picked;
        } else {
          _selectedPaidDate = picked;
        }
      });
    }
  }

  void _savePayment() {
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
            'Pago guardado: \$${_amountController.text} - ${_descriptionController.text}',
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
        title: const Text('Registrar Pago'),
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
                        hint: 'Ej: Pago de electricidad',
                        icon: Icons.description,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una descripción';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Pay from selector
                      _buildDropdownField(
                        label: 'Pagar Desde',
                        icon: Icons.account_balance_wallet,
                        value: _selectedAccount,
                        items: _accounts,
                        onChanged: (value) {
                          setState(() {
                            _selectedAccount = value;
                          });
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
                      ),
                      const SizedBox(height: 20),

                      // Date paid (optional)
                      _buildDateField(
                        label: 'Fecha Pagada (Opcional)',
                        icon: Icons.calendar_today,
                        date: _selectedPaidDate,
                        onTap: () => _selectDate(context, false),
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(height: 20),

                      // Due date (highlighted)
                      _buildDateField(
                        label: 'Fecha Para Pagar (Vencimiento)',
                        icon: Icons.event_available,
                        date: _selectedDueDate,
                        onTap: () => _selectDate(context, true),
                        color: AppTheme.accentOrange,
                        isHighlighted: true,
                      ),
                      const SizedBox(height: 20),

                      // Recurring payment toggle
                      _buildToggleField(
                        label: 'Pago Recurrente',
                        icon: Icons.repeat,
                        value: _isRecurring,
                        onChanged: (value) {
                          setState(() {
                            _isRecurring = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Reminder toggle (Premium)
                      _buildToggleField(
                        label: 'Recordar',
                        icon: Icons.notifications,
                        value: _hasReminder,
                        onChanged: (value) {
                          setState(() {
                            _hasReminder = value;
                          });
                        },
                        isPremium: true,
                      ),
                      const SizedBox(height: 20),

                      // Auto payment toggle
                      _buildToggleField(
                        label: 'Pago Automático',
                        icon: Icons.autorenew,
                        value: _isAutoPay,
                        onChanged: (value) {
                          setState(() {
                            _isAutoPay = value;
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
              Icon(Icons.attach_money, color: AppTheme.accentRed, size: 20),
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
              color: AppTheme.accentRed,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: AppTheme.textTertiary),
              prefixText: '\$ ',
              prefixStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.accentRed,
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
              Icon(icon, color: AppTheme.accentPurple, size: 20),
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

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime date,
    required VoidCallback onTap,
    required Color color,
    bool isHighlighted = false,
  }) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isHighlighted ? color : AppTheme.textSecondary,
                    fontWeight: isHighlighted
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(date),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isHighlighted ? color : AppTheme.textPrimary,
                    fontWeight: isHighlighted
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
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
    bool isPremium = false,
  }) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyLarge),
                if (isPremium) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.accentOrange,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock,
                          size: 12,
                          color: AppTheme.accentOrange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Premium',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.accentOrange,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
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
          onPressed: _savePayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentOrange,
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
