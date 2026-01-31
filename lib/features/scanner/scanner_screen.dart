import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared_widgets/shared_widgets.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  String? _scannedCode;
  bool _isScanning = true;

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue != null) {
      setState(() {
        _scannedCode = barcode!.rawValue;
        _isScanning = false;
      });
    }
  }

  void _resetScan() {
    setState(() {
      _scannedCode = null;
      _isScanning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OpsScaffold(
      title: 'Scanner',
      subtitle: 'Battery Inventory',
      alertBanner: const AlertBanner(
        message: 'Scan queue ready. Sync location updates every 2 mins.',
        status: StatusType.healthy,
      ),
      body: Column(
        children: [
          // Scanner area
          Expanded(
            flex: 2,
            child: _isScanning
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    child: MobileScanner(onDetect: _onDetect),
                  )
                : _ScannedResult(code: _scannedCode!, onScanAgain: _resetScan),
          ),

          // Battery info panel
          if (_scannedCode != null)
            Expanded(
              flex: 3,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  const SectionHeader(title: 'Battery Info'),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.cardRadius,
                      ),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.battery_charging_full, size: 24),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NS-4482-AX',
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                  Text(
                                    'Scanned just now',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const StatusBadge(
                              label: 'Ready',
                              status: StatusType.healthy,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const DataPanelRow(
                          panels: [
                            DataPanel(
                              label: 'Health',
                              value: '94%',
                              status: StatusType.healthy,
                            ),
                            DataPanel(label: 'Cycles', value: '127'),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const DataPanelRow(
                          panels: [
                            DataPanel(label: 'Location', value: 'Central'),
                            DataPanel(label: 'Last Scan', value: '4 min ago'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const SectionHeader(title: 'Update Status'),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Set Ready'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.build),
                          label: const Text('Set Repair'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.location_on),
                          label: const Text('Update Location'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.critical,
                            side: const BorderSide(color: AppColors.critical),
                          ),
                          icon: const Icon(Icons.report),
                          label: const Text('Report Issue'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ScannedResult extends StatelessWidget {
  const _ScannedResult({required this.code, required this.onScanAgain});

  final String code;
  final VoidCallback onScanAgain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.healthy.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.healthy.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 48, color: AppColors.healthy),
          const SizedBox(height: AppSpacing.lg),
          Text('Scanned Successfully', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(code, style: theme.textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xl),
          TextButton.icon(
            onPressed: onScanAgain,
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Scan Another'),
          ),
        ],
      ),
    );
  }
}
