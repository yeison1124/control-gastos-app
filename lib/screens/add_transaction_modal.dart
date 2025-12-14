import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../config/theme.dart';
import '../widgets/neumorphic_card.dart';
import 'add_expense_screen.dart';
import 'add_payment_screen.dart';
import 'add_income_screen.dart';
import 'add_installment_screen.dart';
import 'add_card_payment_screen.dart';
import 'add_cashback_screen.dart';

class AddTransactionModal extends StatelessWidget {
  const AddTransactionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          decoration: BoxDecoration(
            color: AppTheme.darkBackground,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Transaction options list
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Standard options
                      _buildTransactionOption(
                        context,
                        title: 'Gastos',
                        subtitle: 'Registrar una compra o pago...',
                        icon: Icons.shopping_cart,
                        color: AppTheme.accentOrange,
                        isLocked: false,
                      ),
                      const SizedBox(height: 16),

                      _buildTransactionOption(
                        context,
                        title: 'Pago',
                        subtitle: 'Registrar un pago que necesitas hacer...',
                        icon: FontAwesomeIcons.moneyBillWave,
                        color: AppTheme.accentRed,
                        isLocked: false,
                      ),
                      const SizedBox(height: 16),

                      _buildTransactionOption(
                        context,
                        title: 'Ingresos',
                        subtitle: 'Registrar una transferencia o movimiento...',
                        icon: Icons.trending_up,
                        color: AppTheme.primaryGreen,
                        isLocked: false,
                      ),
                      const SizedBox(height: 16),

                      _buildTransactionOption(
                        context,
                        title: 'Reembolso',
                        subtitle: 'Registrar un reembolso que recibiste...',
                        icon: FontAwesomeIcons.arrowRotateLeft,
                        color: AppTheme.primaryBlue,
                        isLocked: false,
                      ),

                      const SizedBox(height: 24),

                      // Premium section divider
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppTheme.textTertiary.withOpacity(0.3),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: AppTheme.accentOrange,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
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
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppTheme.textTertiary.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Premium options
                      _buildTransactionOption(
                        context,
                        title: 'Compras a Meses',
                        subtitle: 'Registrar una compra a meses...',
                        icon: FontAwesomeIcons.creditCard,
                        color: AppTheme.accentPurple,
                        isLocked: false,
                      ),
                      const SizedBox(height: 16),

                      _buildTransactionOption(
                        context,
                        title: 'Pago con Tarjeta',
                        subtitle: 'Registrar compras de tarjeta de crédito...',
                        icon: FontAwesomeIcons.wallet,
                        color: AppTheme.accentPurple,
                        isLocked: false,
                      ),
                      const SizedBox(height: 16),

                      _buildTransactionOption(
                        context,
                        title: 'Devoluciones Efectivas',
                        subtitle: 'Recibir recompensas...',
                        icon: FontAwesomeIcons.gift,
                        color: AppTheme.accentPurple,
                        isLocked: false,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Agregar Transacción',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isLocked,
  }) {
    return GestureDetector(
      onTap: () {
        if (isLocked) {
          // Show premium dialog
          _showPremiumDialog(context);
        } else {
          // Navigate to transaction form
          Navigator.of(context).pop();

          // Navigate to specific transaction form based on title
          Widget? screen;
          if (title == 'Gastos') {
            screen = const AddExpenseScreen();
          } else if (title == 'Pago') {
            screen = const AddPaymentScreen();
          } else if (title == 'Ingresos') {
            screen = const AddIncomeScreen(type: 'income');
          } else if (title == 'Reembolso') {
            screen = const AddIncomeScreen(type: 'refund');
          } else if (title == 'Compras a Meses') {
            screen = const AddInstallmentScreen();
          } else if (title == 'Pago con Tarjeta') {
            screen = const AddCardPaymentScreen();
          } else if (title == 'Devoluciones Efectivas') {
            screen = const AddCashbackScreen();
          }

          if (screen != null) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => screen!));
          }
        }
      },
      child: NeumorphicCard(
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            // Icon container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),

            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (isLocked) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.lock,
                          size: 16,
                          color: AppTheme.textTertiary,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isLocked
                          ? AppTheme.textTertiary
                          : AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isLocked
                  ? AppTheme.textTertiary.withOpacity(0.5)
                  : AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.star, color: AppTheme.accentOrange),
            const SizedBox(width: 12),
            Text(
              'Función Premium',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Esta función está disponible en la versión Premium.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Beneficios Premium:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPremiumFeature(context, 'Compras a meses sin intereses'),
            _buildPremiumFeature(context, 'Seguimiento de tarjetas de crédito'),
            _buildPremiumFeature(context, 'Sincronización en la nube'),
            _buildPremiumFeature(context, 'Reportes avanzados'),
            _buildPremiumFeature(context, 'Sin anuncios'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Más tarde',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to premium upgrade screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Próximamente: Actualización Premium'),
                  backgroundColor: AppTheme.accentOrange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFeature(BuildContext context, String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: AppTheme.primaryGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(feature, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
