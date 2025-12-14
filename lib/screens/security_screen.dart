import 'package:flutter/material.dart';
import '../config/theme.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _safeModeEnabled = false;

  void _showPinSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PinSetupScreen(),
        fullscreenDialog: true,
      ),
    ).then((pinCreated) {
      if (pinCreated == true) {
        setState(() {
          _safeModeEnabled = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Modo Seguro activado'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    });
  }

  void _disableSafeMode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: const Text('Desactivar Modo Seguro'),
        content: const Text(
          '¿Estás seguro de que deseas desactivar el Modo Seguro?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _safeModeEnabled = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Modo Seguro desactivado'),
                  backgroundColor: AppTheme.accentOrange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(title: const Text('Seguridad'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Safe Mode Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentPurple.withOpacity(0.2),
                  AppTheme.primaryBlue.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _safeModeEnabled
                    ? AppTheme.primaryGreen
                    : AppTheme.accentPurple.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _safeModeEnabled
                            ? AppTheme.primaryGreen.withOpacity(0.2)
                            : AppTheme.accentPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _safeModeEnabled ? Icons.lock : Icons.lock_open,
                        color: _safeModeEnabled
                            ? AppTheme.primaryGreen
                            : AppTheme.accentPurple,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Modo Seguro',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _safeModeEnabled
                                  ? AppTheme.primaryGreen.withOpacity(0.2)
                                  : AppTheme.textTertiary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _safeModeEnabled ? 'Activado' : 'Desactivado',
                              style: TextStyle(
                                color: _safeModeEnabled
                                    ? AppTheme.primaryGreen
                                    : AppTheme.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'El Modo Seguro requiere PIN o Biometría (Face ID / Huella Digital) para desbloquear la app y proteger tu información.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _safeModeEnabled
                        ? _disableSafeMode
                        : _showPinSetup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _safeModeEnabled
                          ? AppTheme.accentRed
                          : AppTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _safeModeEnabled ? Icons.lock_open : Icons.lock,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _safeModeEnabled
                              ? 'Desactivar Modo Seguro'
                              : 'Activar Código PIN',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Additional security options
          _buildSecurityOption(
            icon: Icons.fingerprint,
            title: 'Biometría',
            subtitle: 'Usar huella digital o Face ID',
            enabled: _safeModeEnabled,
          ),
          const SizedBox(height: 12),
          _buildSecurityOption(
            icon: Icons.vpn_key,
            title: 'Cambiar PIN',
            subtitle: 'Actualizar tu código de acceso',
            enabled: _safeModeEnabled,
          ),
          const SizedBox(height: 12),
          _buildSecurityOption(
            icon: Icons.timer,
            title: 'Tiempo de Bloqueo',
            subtitle: 'Inmediato',
            enabled: _safeModeEnabled,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: enabled ? AppTheme.primaryBlue : AppTheme.textTertiary,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
}

// PIN Setup Screen
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _useBiometrics = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (!_isConfirming) {
        if (_pin.length < 4) {
          _pin += number;
          if (_pin.length == 4) {
            // Move to confirmation
            Future.delayed(const Duration(milliseconds: 300), () {
              setState(() {
                _isConfirming = true;
              });
            });
          }
        }
      } else {
        if (_confirmPin.length < 4) {
          _confirmPin += number;
          if (_confirmPin.length == 4) {
            // Verify PIN
            _verifyPin();
          }
        }
      }
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (!_isConfirming) {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        }
      }
    });
  }

  void _verifyPin() {
    if (_pin == _confirmPin) {
      // PIN matches
      Navigator.pop(context, true);
    } else {
      // PIN doesn't match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Los PINs no coinciden. Intenta de nuevo.'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
      setState(() {
        _pin = '';
        _confirmPin = '';
        _isConfirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(title: const Text('Crear PIN'), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 40),

          // Title
          Text(
            _isConfirming ? 'Confirma tu PIN' : 'Crear un PIN de Acceso',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Instruction
          Text(
            _isConfirming
                ? 'Ingresa nuevamente tu PIN de 4 dígitos'
                : 'Crea un PIN de 4 dígitos para desbloquear la aplicación',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),

          // PIN Display
          _buildPinDisplay(),

          const Spacer(),

          // Biometrics option
          if (!_isConfirming)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _useBiometrics = !_useBiometrics;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fingerprint,
                      color: _useBiometrics
                          ? AppTheme.primaryGreen
                          : AppTheme.textSecondary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Usar Biometría en el futuro',
                      style: TextStyle(
                        color: _useBiometrics
                            ? AppTheme.primaryGreen
                            : AppTheme.textSecondary,
                        fontWeight: _useBiometrics
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 40),

          // Numeric Keypad
          _buildNumericKeypad(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPinDisplay() {
    final currentPin = _isConfirming ? _confirmPin : _pin;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isFilled = index < currentPin.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isFilled ? AppTheme.primaryGreen : AppTheme.darkCard,
            shape: BoxShape.circle,
            border: Border.all(
              color: isFilled
                  ? AppTheme.primaryGreen
                  : AppTheme.textTertiary.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: isFilled
                ? const Icon(Icons.circle, color: Colors.white, size: 16)
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildNumericKeypad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildKeypadRow(['1', '2', '3']),
          const SizedBox(height: 20),
          _buildKeypadRow(['4', '5', '6']),
          const SizedBox(height: 20),
          _buildKeypadRow(['7', '8', '9']),
          const SizedBox(height: 20),
          _buildKeypadRow(['', '0', 'delete']),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        if (number.isEmpty) {
          return const SizedBox(width: 70, height: 70);
        }

        if (number == 'delete') {
          return _buildKeypadButton(
            child: const Icon(Icons.backspace_outlined, size: 28),
            onPressed: _onDeletePressed,
          );
        }

        return _buildKeypadButton(
          child: Text(
            number,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onNumberPressed(number),
        );
      }).toList(),
    );
  }

  Widget _buildKeypadButton({
    required Widget child,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.textTertiary.withOpacity(0.2)),
        ),
        child: Center(child: child),
      ),
    );
  }
}
