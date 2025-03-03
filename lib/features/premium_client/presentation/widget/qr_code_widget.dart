import 'package:custom_qr_generator/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:custom_qr_generator/qr_painter.dart';
import 'package:custom_qr_generator/options/options.dart';
import 'package:custom_qr_generator/options/colors.dart';
import 'package:lighthouse/core/resources/colors.dart';

class QrCodeWidget extends StatelessWidget {
  final String qrData;

  const QrCodeWidget({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: QrPainter(
        data: qrData,
        options: const QrOptions(
          colors: QrColors(
            dark: QrColorSolid(navy),
            background: QrColorSolid(Colors.transparent),
          ),
        ),
      ),
      size: const Size(200, 200),
    );
  }
}
