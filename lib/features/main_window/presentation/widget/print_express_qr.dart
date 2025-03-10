
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:lighthouse/core/utils/printing_commands.dart';
import 'package:translator/translator.dart';
import '../../../../core/utils/platform_service/platform_service.dart';

Future<void> printExpressQr( String printerAddress,
    String printerName, dynamic client) async {
  final translator = GoogleTranslator();
  var clientName = await translator.translate(client.fullName, from: 'ar', to: 'en');
  PrintMode mode = PrintMode.USB;
  try {
    final ByteData data = await rootBundle.load('assets/images/logo_print.png');
    final Uint8List pngBytes = data.buffer.asUint8List();
    final img.Image logo = img.decodeImage(pngBytes)!;
    final img.Image resizedLogo = img.copyResize(logo, width: 400);
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    
    // Generate Print Data
    bytes += generator.image(resizedLogo, align: PosAlign.center);
    bytes += generator.feed(1);
    bytes += generator.text(
      'Express Client',
      styles: PosStyles(bold: true, fontType: PosFontType.fontA, underline: true),
    );
    bytes += generator.text('Client Id: ${client.id}');
    bytes += generator.text('Client Name: ${clientName.text}');
    bytes += generator.feed(1);
    bytes += generator.qrcode(client.qrCode, size: QRSize.size8);
    bytes += generator.feed(3);
    bytes += generator.cut(mode: PosCutMode.full);

    // Print Logic
    final service = PlatformService();
    if (mode == PrintMode.NETWORK) {
      print("NETWORK PRINTING");
      service.printSocket(host: printerAddress, port: 9100, bytes: bytes);
    } else {
      print("USB PRINTING");
      service.printDirectWindows(printerName: printerName, bytes: bytes);
    }
  } catch (e) {
    debugPrint("Print Error: $e");
  }
}
