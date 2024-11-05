import 'package:flutter/material.dart';
import 'package:lighthouse_/features/premium_client/presentation/widget/qr_dialog.dart';

class QrGenerator extends StatelessWidget {
  final String data;
  const QrGenerator({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton(
        child: const Icon(Icons.qr_code_2),
        onPressed: () async {
          // premiumClientInfo(context, data);
        },
      ),
    );
  }
}
