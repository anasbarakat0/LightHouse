import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:lighthouse/core/utils/platform_service/platform_service_none.dart';

enum PrintMode { USB, NETWORK }

class PrinterService {
  final String printerName;
  final String printerAddress;
  final PrintMode mode;

  PrinterService({
    required this.printerName,
    required this.printerAddress,
    required this.mode,
  });

  /// Send raw bytes to printer
  Future<void> sendToPrinter(List<int> bytes) async {
    final service = PlatformService();
    try {
      if (mode == PrintMode.NETWORK) {
        await service.printSocket(
            host: printerAddress, port: 9100, bytes: bytes);
      } else {
        await service.printDirectWindows(
            printerName: printerName, bytes: bytes);
      }
    } catch (e) {
      debugPrint("Print Error: $e");
    }
  }

  /// Print simple text
  Future<void> printText(String text) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = [];
    bytes += generator.text(text, styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(2);
    bytes += generator.cut();

    await sendToPrinter(bytes);
  }

  /// Print columns
  Future<void> printColumns(
      String col1, String col2, String col3) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = [];
    bytes += generator.row([
      PosColumn(text: col1, width: 3, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: col2, width: 6, styles: PosStyles(align: PosAlign.center)),
      PosColumn(text: col3, width: 3, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.feed(2);
    bytes += generator.cut();

    await sendToPrinter(bytes);
  }

  /// Print an image
  Future<void> printImage(String imagePath) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = [];
    final ByteData data = await rootBundle.load(imagePath);
    final Uint8List imgBytes = data.buffer.asUint8List();
    final img.Image image = img.decodeImage(imgBytes)!;

    var ratio = image.width / image.height;
    bytes += generator.imageRaster(img.copyResize(image,
        width: (297 * 2), height: (image.height * ratio).toInt()));

    bytes += generator.feed(2);
    bytes += generator.cut();

    await sendToPrinter(bytes);
  }
}
