import 'package:flutter/material.dart';
import '../config/theme.dart';

class ImportExportScreen extends StatefulWidget {
  const ImportExportScreen({super.key});

  @override
  State<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends State<ImportExportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Importar y Exportar Datos'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryGreen,
          tabs: const [
            Tab(text: 'Importar'),
            Tab(text: 'Exportar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ImportTransactionsTab(), ExportDataTab()],
      ),
    );
  }
}

// Import Transactions Tab
class ImportTransactionsTab extends StatefulWidget {
  const ImportTransactionsTab({super.key});

  @override
  State<ImportTransactionsTab> createState() => _ImportTransactionsTabState();
}

class _ImportTransactionsTabState extends State<ImportTransactionsTab> {
  String _selectedAccount = 'Cheque';
  String? _selectedFileName;

  final List<String> _accounts = [
    'Cheque',
    'Efectivo',
    'Ahorros',
    'Visa Gold',
    'Mastercard Platinum',
  ];

  void _selectFile() {
    // Simulate file selection
    setState(() {
      _selectedFileName = 'estado_cuenta_enero_2024.csv';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Archivo seleccionado'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _importFile() {
    if (_selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor selecciona un archivo primero'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Importando a $_selectedAccount...'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step indicator
          _buildStepIndicator('Paso 1 de 4'),
          const SizedBox(height: 24),

          // Step 1: Account selector
          _buildSectionTitle('Importar a la Cuenta'),
          const SizedBox(height: 12),
          _buildAccountSelector(),
          const SizedBox(height: 32),

          // Step 2: Description
          _buildStepIndicator('Paso 2 de 4'),
          const SizedBox(height: 24),
          _buildDescriptionCard(
            'Sube un estado de cuenta, hoja de cálculo o archivo CSV/XLS de tu banco.',
            Icons.info_outline,
            AppTheme.primaryBlue,
          ),
          const SizedBox(height: 32),

          // Step 3: File selector
          _buildStepIndicator('Paso 3 de 4'),
          const SizedBox(height: 24),
          _buildFileSelector(),
          const SizedBox(height: 32),

          // Step 4: Import button
          _buildStepIndicator('Paso 4 de 4'),
          const SizedBox(height: 24),
          _buildImportButton(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(String step) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryGreen),
      ),
      child: Text(
        step,
        style: TextStyle(
          color: AppTheme.primaryGreen,
          fontWeight: FontWeight.bold,
          fontSize: 12,
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

  Widget _buildAccountSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
      ),
      child: DropdownButton<String>(
        value: _selectedAccount,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: AppTheme.darkCard,
        icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryGreen),
        items: _accounts.map((account) {
          return DropdownMenuItem(
            value: account,
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(account),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedAccount = value!;
          });
        },
      ),
    );
  }

  Widget _buildDescriptionCard(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileSelector() {
    return GestureDetector(
      onTap: _selectFile,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryGreen.withOpacity(0.2),
              AppTheme.primaryBlue.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryGreen,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.upload_file,
                size: 64,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Seleccionar Archivo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toca para elegir un archivo',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            if (_selectedFileName != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      color: AppTheme.primaryGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _selectedFileName!,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImportButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _importFile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_upload, size: 24),
            const SizedBox(width: 12),
            Text(
              'Importar Archivo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Export Data Tab
class ExportDataTab extends StatefulWidget {
  const ExportDataTab({super.key});

  @override
  State<ExportDataTab> createState() => _ExportDataTabState();
}

class _ExportDataTabState extends State<ExportDataTab> {
  List<String> _selectedAccounts = ['Todas'];
  String _selectedFormat = 'CSV';

  final List<String> _accounts = [
    'Todas',
    'Cheque',
    'Efectivo',
    'Ahorros',
    'Visa Gold',
    'Mastercard Platinum',
  ];

  final List<String> _formats = ['CSV', 'XLS', 'PDF'];

  void _selectFormat() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Seleccionar Formato',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ..._formats.map((format) {
              final isSelected = format == _selectedFormat;
              return ListTile(
                leading: Icon(
                  format == 'PDF' ? Icons.picture_as_pdf : Icons.table_chart,
                  color: isSelected
                      ? AppTheme.primaryGreen
                      : AppTheme.textSecondary,
                ),
                title: Text(format),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppTheme.primaryGreen)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedFormat = format;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _exportFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exportando en formato $_selectedFormat...'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step indicator
          _buildStepIndicator('Paso 1 de 4'),
          const SizedBox(height: 24),

          // Step 1: Account selector
          _buildSectionTitle('Seleccionar Cuentas a Exportar'),
          const SizedBox(height: 12),
          _buildAccountsSelector(),
          const SizedBox(height: 32),

          // Step 2: Description
          _buildStepIndicator('Paso 2 de 4'),
          const SizedBox(height: 24),
          _buildDescriptionCard(
            'Descarga tus datos históricos en formato CSV, XLS o PDF a tu dispositivo.',
            Icons.info_outline,
            AppTheme.primaryBlue,
          ),
          const SizedBox(height: 32),

          // Step 3: Format selector
          _buildStepIndicator('Paso 3 de 4'),
          const SizedBox(height: 24),
          _buildFormatSelector(),
          const SizedBox(height: 32),

          // Step 4: Export button
          _buildStepIndicator('Paso 4 de 4'),
          const SizedBox(height: 24),
          _buildExportButton(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(String step) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryBlue),
      ),
      child: Text(
        step,
        style: TextStyle(
          color: AppTheme.primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 12,
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

  Widget _buildAccountsSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
      ),
      child: Column(
        children: _accounts.map((account) {
          final isSelected = _selectedAccounts.contains(account);
          return CheckboxListTile(
            title: Text(account),
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (account == 'Todas') {
                  if (value == true) {
                    _selectedAccounts = ['Todas'];
                  } else {
                    _selectedAccounts = [];
                  }
                } else {
                  _selectedAccounts.remove('Todas');
                  if (value == true) {
                    _selectedAccounts.add(account);
                  } else {
                    _selectedAccounts.remove(account);
                  }
                }
              });
            },
            activeColor: AppTheme.primaryBlue,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDescriptionCard(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatSelector() {
    return GestureDetector(
      onTap: _selectFormat,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryBlue.withOpacity(0.2),
              AppTheme.accentPurple.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryBlue,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.download,
                size: 64,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Elegir Formato y Archivo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toca para seleccionar formato',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _selectedFormat == 'PDF'
                        ? Icons.picture_as_pdf
                        : Icons.table_chart,
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Formato: $_selectedFormat',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _exportFile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_download, size: 24),
            const SizedBox(width: 12),
            Text(
              'Exportar Archivo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
