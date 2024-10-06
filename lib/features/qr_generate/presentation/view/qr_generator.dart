import 'package:flutter/material.dart';
import 'package:light_house/features/qr_generate/presentation/widgets/qr_dialog.dart';

class QrGenerator extends StatelessWidget {
  final String data;
  const QrGenerator({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton(
        child: const Icon(Icons.qr_code_2),
        onPressed: () async {
          qrCodeDialog(context, data);
        },
      ),
    );
  }
}
