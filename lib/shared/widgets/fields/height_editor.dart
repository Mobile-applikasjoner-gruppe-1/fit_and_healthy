import 'package:flutter/material.dart';

class HeightEditor extends StatelessWidget {
  final double initialHeight;
  final Function(double) onHeightChanged;

  const HeightEditor({
    Key? key,
    required this.initialHeight,
    required this.onHeightChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: initialHeight.toInt().toString());

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Height (cm)',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        final double? height = double.tryParse(value);
        if (height != null) {
          onHeightChanged(height);
        }
      },
    );
  }

  static Future<double?> showDialogForHeight(
      BuildContext context, double initialHeight) async {
    double? newHeight = initialHeight;

    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Height'),
          content: HeightEditor(
            initialHeight: initialHeight,
            onHeightChanged: (value) {
              newHeight = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(newHeight),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
