import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:lighthouse/core/utils/printing_commands.dart';
import 'package:translator/translator.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/platform_service/platform_service.dart';

Future<void> printPremiumQr(String? value, String printerAddress,
    String printerName, dynamic client) async {
  debugPrint("🖨️ printPremiumQr called - Starting Premium QR printing...");

  // Get saved printer from settings, or use provided printerName as fallback
  final prefs = memory.get<SharedPreferences>();
  final savedPrinter = prefs.getString('selected_printer') ?? printerName;
  final actualPrinterName =
      savedPrinter.isNotEmpty ? savedPrinter : printerName;

  debugPrint("🖨️ Using printer: $actualPrinterName");
  debugPrint("🖨️ Client: ${client.firstName} ${client.lastName}");
  debugPrint("🖨️ QR Code: ${client.qrCode?.qrCode ?? 'NULL'}");

  final translator = GoogleTranslator();
  var name = await translator.translate(
      "${client.firstName} ${client.lastName}",
      from: 'ar',
      to: 'en');
  PrintMode mode = value == "USB" ? PrintMode.USB : PrintMode.NETWORK;

  try {
    debugPrint("🖨️ Processing Premium QR data...");
    // Load Image
    final ByteData data = await rootBundle.load('assets/images/logo_print.png');
    final Uint8List pngBytes = data.buffer.asUint8List();
    final img.Image logo = img.decodeImage(pngBytes)!;
    final img.Image resizedLogo = img.copyResize(logo, width: 400);

    // Initialize Printer Generator
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // Generate Print Data
    bytes += generator.image(resizedLogo, align: PosAlign.center);
    bytes += generator.feed(1);
    bytes += generator.text(
      'Premium Client',
      styles:
          PosStyles(bold: true, fontType: PosFontType.fontA, underline: true),
    );
    bytes += generator.text('Id: ${client.uuid}');
    bytes += generator.row([
      PosColumn(
        text: 'Name: ',
        width: 3,
        styles: PosStyles(bold: false),
      ),
      PosColumn(
        text: name.text,
        width: 9,
        styles: PosStyles(bold: true),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Password:',
        width: 3,
        styles: PosStyles(bold: false),
      ),
      PosColumn(
        text: client.generatedPassword,
        width: 9  ,
        styles: PosStyles(bold: true),
      ),
    ]);

    bytes += generator.feed(1);
    bytes += generator.qrcode(client.qrCode.qrCode, size: QRSize.size8);
    bytes += generator.feed(3);
    bytes += generator.cut(mode: PosCutMode.full);

    // Print Logic
    debugPrint("🖨️ Sending Premium QR to printer...");
    final service = PlatformService();
    if (mode == PrintMode.NETWORK) {
      debugPrint("NETWORK PRINTING - Premium QR");
      await service.printSocket(host: printerAddress, port: 9100, bytes: bytes);
    } else {
      debugPrint("USB PRINTING - Premium QR");
      debugPrint("Using printer: $actualPrinterName");
      await service.printDirectWindows(
          printerName: actualPrinterName, bytes: bytes);
    }
    debugPrint("✅ Premium QR printed successfully!");
  } catch (e) {
    debugPrint("❌ Print Premium QR Error: $e");
    debugPrint("Error stack trace: ${StackTrace.current}");
    rethrow; // Re-throw to allow caller to handle
  }
}
