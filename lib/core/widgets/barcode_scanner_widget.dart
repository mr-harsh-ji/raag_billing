import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raag_billing/core/services/scan_feedback_service.dart';
import 'package:raag_billing/features/settings/presentation/providers/settings_providers.dart';

class BarcodeScannerWidget extends ConsumerStatefulWidget {
  final Function(String) onDetect;

  const BarcodeScannerWidget({super.key, required this.onDetect});

  @override
  ConsumerState<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends ConsumerState<BarcodeScannerWidget> {
  final MobileScannerController controller = MobileScannerController();
  bool _isScanCompleted = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan Barcode')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Camera permission is required to scan barcodes'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkPermission,
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.camera_rear),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isScanCompleted) return;
              
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  _isScanCompleted = true;
                  
                  final settings = ref.read(appSettingsProvider).value;
                  if (settings?.barcodeBeepEnabled ?? true) {
                    ScanFeedbackService().playSuccessFeedback(barcode: code);
                  }
                  
                  widget.onDetect(code);
                  if (mounted) {
                    Future.microtask(() async {
                      await controller.stop();
                      if (mounted) Navigator.pop(context);
                    });
                  }
                  break;
                }
              }
            },
          ),
          // Scanner Overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Align barcode inside the frame',
                style: TextStyle(color: Colors.white, backgroundColor: Colors.black54, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
