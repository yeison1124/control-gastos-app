import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../config/theme.dart';
import '../widgets/neumorphic_card.dart';

class AddCardPaymentScreen extends StatefulWidget {
  const AddCardPaymentScreen({super.key});

  @override
  State<AddCardPaymentScreen> createState() => _AddCardPaymentScreenState();
}

class _AddCardPaymentScreenState extends State<AddCardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _merchantController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _transactionDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  String? _selectedCard;
  String? _selectedCategory;
  String _paymentStatus = 'Pendiente';
  bool _hasReminder = false;
  bool _convertToInstallments = false;

  final List<Map<String, dynamic>> _creditCards = [
    {
      'name': 'Visa Platinum',
      'last4': '1234',
      'icon': FontAwesomeIcons.ccVisa,
      'color': AppTheme.primaryBlue,
    },
    {
      'name': 'Mastercard Gold',
      'last4': '5678',
      'icon': FontAwesomeIcons.ccMastercard,
      'color': AppTheme.accentOrange,
    },
    {
      'name': 'American Express',
      'last4': '9012',
      'icon': FontAwesomeIcons.ccAmex,
      'color': AppTheme.primaryGreen,
    },
  ];

  final List<String> _categories = [
    'Compras',
    'Restaurantes',
    'Servicios',
    'Entretenimiento',
    'Viajes',
    'Gasolina',
    'Supermercado',
    'Otros',
  ];

  final List<String> _paymentStatuses = ['Pendiente', 'Pagado', 'Programado'];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _merchantController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isDueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDueDate ? _dueDate : _transactionDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
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
    if (picked != null) {
      setState(() {
        if (isDueDate) {
          _dueDate = picked;
        } else {
          _transactionDate = picked;
        }
      });
    }
  }

  void _saveCardPayment() {
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
            'Pago con tarjeta guardado: \$${_amountController.text}',
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
        title: Row(
          children: [
            const Text('Pago con Tarjeta'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.accentPurple, AppTheme.primaryBlue],
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
                      // Amount field
                      _buildAmountField(),
                      const SizedBox(height: 20),

                      // Card selection
                      _buildCardSelector(),
                      const SizedBox(height: 20),

                      // Description field
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Descripción',
                        hint: 'Ej: Compra en tienda',
                        icon: Icons.description,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una descripción';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Merchant field
                      _buildTextField(
                        controller: _merchantController,
                        label: 'Comercio/Tienda',
                        hint: 'Ej: Amazon, Walmart',
                        icon: Icons.store,
                      ),
                      const SizedBox(height: 20),

                      // Transaction date
                      _buildDateField(
                        label: 'Fecha de Transacción',
                        date: _transactionDate,
                        onTap: () => _selectDate(context, false),
                        color: AppTheme.primaryBlue,
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

                      // Payment status
                      _buildPaymentStatusSelector(),
                      const SizedBox(height: 20),

                      // Due date
                      _buildDateField(
                        label: 'Fecha de Vencimiento',
                        date: _dueDate,
                        onTap: () => _selectDate(context, true),
                        color: AppTheme.accentOrange,
                        isHighlighted: true,
                      ),
                      const SizedBox(height: 20),

                      // Convert to installments toggle
                      _buildToggleField(
                        label: 'Convertir a Meses',
                        icon: Icons.credit_score,
                        value: _convertToInstallments,
                        onChanged: (value) {
                          setState(() {
                            _convertToInstallments = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Reminder toggle (Premium)
                      _buildToggleField(
                        label: 'Recordatorio de Pago',
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
            AppTheme.primaryBlue.withOpacity(0.1),
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
                  'Monto',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
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

  Widget _buildCardSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(Icons.credit_card, color: AppTheme.accentPurple, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tarjeta de Crédito',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
        Column(
          children: _creditCards.map((card) {
            final isSelected = _selectedCard == card['name'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCard = card['name'];
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            card['color'].withOpacity(0.3),
                            card['color'].withOpacity(0.1),
                          ],
                        )
                      : null,
                  color: isSelected ? null : AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? card['color'] : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: card['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(card['icon'], color: card['color'], size: 24),
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
                            '**** **** **** ${card['last4']}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: card['color'], size: 24),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(Icons.payment, color: AppTheme.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                'Estado de Pago',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 12,
          children: _paymentStatuses.map((status) {
            final isSelected = _paymentStatus == status;
            Color statusColor;
            if (status == 'Pagado') {
              statusColor = AppTheme.primaryGreen;
            } else if (status == 'Pendiente') {
              statusColor = AppTheme.accentOrange;
            } else {
              statusColor = AppTheme.primaryBlue;
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  _paymentStatus = status;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? statusColor.withOpacity(0.2)
                      : AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? statusColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? statusColor : AppTheme.textSecondary,
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

  Widget _buildDateField({
    required String label,
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
                Icon(Icons.calendar_today, color: color, size: 20),
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
          Icon(icon, color: AppTheme.accentOrange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyLarge),
                if (isPremium) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.accentPurple, AppTheme.primaryBlue],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 10, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Premium',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
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
          onPressed: _saveCardPayment,
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
                colors: [AppTheme.accentPurple, AppTheme.primaryBlue],
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
