import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';

void qrCodeDialog(BuildContext context, String data) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            CustomPaint(
              painter: QrPainter(
                data: data,
                options: const QrOptions(),
              ),
              size: const Size(200, 200),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
