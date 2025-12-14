import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import 'premium_screen.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  // Mock data - set to empty list to show empty state
  List<Map<String, dynamic>> _subscriptions = [];

  // Uncomment to show subscriptions
  // List<Map<String, dynamic>> _subscriptions = [
  //   {
  //     'name': 'Premium Anual',
  //     'startDate': DateTime(2024, 1, 15),
  //     'renewalDate': DateTime(2025, 1, 15),
  //     'status': 'Activa',
  //     'price': 12.99,
  //     'isActive': true,
  //   },
  //   {
  //     'name': 'Premium Mensual',
  //     'startDate': DateTime(2023, 6, 1),
  //     'renewalDate': DateTime(2023, 12, 1),
  //     'status': 'Expirada',
  //     'price': 1.39,
  //     'isActive': false,
  //   },
  // ];

  void _restorePurchases() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryGreen,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Text('Restaurando...'),
          ],
        ),
        content: const Text('Buscando compras anteriores...'),
      ),
    );

    // Simulate restoration
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);

      // Simulate finding a subscription
      setState(() {
        _subscriptions = [
          {
            'name': 'Premium Anual',
            'startDate': DateTime(2024, 1, 15),
            'renewalDate': DateTime(2025, 1, 15),
            'status': 'Activa',
            'price': 12.99,
            'isActive': true,
          },
        ];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Compras restauradas exitosamente'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
    });
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: const Text('Contactar Soporte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Puedes contactarnos a través de:'),
            const SizedBox(height: 16),
            _buildContactOption(
              icon: Icons.email,
              title: 'Email',
              subtitle: 'soporte@controldegastos.com',
            ),
            const SizedBox(height: 12),
            _buildContactOption(
              icon: Icons.chat,
              title: 'Chat en vivo',
              subtitle: 'Lun-Vie 9:00 AM - 6:00 PM',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Abriendo email...'),
                  backgroundColor: AppTheme.primaryBlue,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
            ),
            child: const Text('Enviar Email'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryBlue),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  void _manageSubscription(Map<String, dynamic> subscription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: Text(subscription['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Estado', subscription['status']),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Inicio',
              DateFormat('d MMM yyyy', 'es').format(subscription['startDate']),
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Renovación',
              DateFormat(
                'd MMM yyyy',
                'es',
              ).format(subscription['renewalDate']),
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Precio',
              '\$${subscription['price'].toStringAsFixed(2)}/${subscription['name'].contains('Anual') ? 'año' : 'mes'}',
            ),
            const SizedBox(height: 16),
            if (subscription['isActive'])
              Text(
                'Esta suscripción se renovará automáticamente.',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          if (subscription['isActive'])
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _cancelSubscription(subscription);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentRed,
              ),
              child: const Text('Cancelar Suscripción'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppTheme.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _cancelSubscription(Map<String, dynamic> subscription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: Row(
          children: [
            Icon(Icons.warning, color: AppTheme.accentOrange),
            const SizedBox(width: 12),
            const Text('Cancelar Suscripción'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas cancelar tu suscripción? Perderás acceso a las funciones premium.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, mantener'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                subscription['isActive'] = false;
                subscription['status'] = 'Cancelada';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Suscripción cancelada'),
                  backgroundColor: AppTheme.accentOrange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(title: const Text('Suscripciones'), centerTitle: true),
      body: _subscriptions.isEmpty
          ? _buildEmptyState()
          : _buildSubscriptionsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.card_membership,
                size: 80,
                color: AppTheme.textTertiary,
              ),
            ),
            const SizedBox(height: 32),

            // Message
            Text(
              'No se encontraron suscripciones',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Explanation
            Text(
              'Puedes revisar si hay alguna compra anterior o contactar soporte.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Restore Purchases Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _restorePurchases,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.restore, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Restaurar Compras Anteriores',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Contact Support Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: _contactSupport,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.primaryBlue, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.support_agent,
                      size: 24,
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Contactar Soporte',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Link to Premium
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PremiumScreen(),
                  ),
                );
              },
              child: Text(
                '¿Quieres suscribirte a Premium?',
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _subscriptions.length + 1,
      itemBuilder: (context, index) {
        if (index == _subscriptions.length) {
          // Add subscription button at the end
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PremiumScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.primaryGreen, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppTheme.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    'Agregar Nueva Suscripción',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final subscription = _subscriptions[index];
        return _buildSubscriptionCard(subscription);
      },
    );
  }

  Widget _buildSubscriptionCard(Map<String, dynamic> subscription) {
    final isActive = subscription['isActive'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _manageSubscription(subscription),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? AppTheme.primaryGreen.withOpacity(0.5)
                  : AppTheme.textTertiary.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      subscription['name'],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.primaryGreen.withOpacity(0.2)
                          : AppTheme.textTertiary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      subscription['status'],
                      style: TextStyle(
                        color: isActive
                            ? AppTheme.primaryGreen
                            : AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Inicio: ${DateFormat('d MMM yyyy', 'es').format(subscription['startDate'])}',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.refresh, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    'Renovación: ${DateFormat('d MMM yyyy', 'es').format(subscription['renewalDate'])}',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${subscription['price'].toStringAsFixed(2)}/${subscription['name'].contains('Anual') ? 'año' : 'mes'}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _manageSubscription(subscription),
                    child: const Text('Gestionar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
