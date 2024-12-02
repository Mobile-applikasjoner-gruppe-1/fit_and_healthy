import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerDialog extends StatefulWidget {
  @override
  _BarcodeScannerDialogState createState() => _BarcodeScannerDialogState();
}

class _BarcodeScannerDialogState extends State<BarcodeScannerDialog> {
  late MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Scan Barcode'),
      content: SizedBox(
        height: 400,
        width: 300,
        child: MobileScanner(
          controller: _scannerController,
          onDetect: (BarcodeCapture barcodeCapture) {
            final String barcodeValue = barcodeCapture.barcodes.isNotEmpty
                ? barcodeCapture.barcodes.first.rawValue ?? ''
                : '';
            if (barcodeValue.isNotEmpty) {
              Navigator.pop(context, barcodeValue);
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog if canceled
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
