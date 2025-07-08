import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:lighthouse/core/utils/printing_commands.dart';
import '../../../../core/utils/platform_service/platform_service.dart';

Future<void> printInvoice(
    bool isPremium, String printerAddress, String printerName, dynamic invoice) async {
  PrintMode mode = PrintMode.USB;

  try {
    print(invoice);
    final ByteData data = await rootBundle.load('assets/images/logo_print.png');
    final Uint8List pngBytes = data.buffer.asUint8List();
    final img.Image logo = img.decodeImage(pngBytes)!;
    final img.Image resizedLogo = img.copyResize(logo, width: 400);
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // Business Header
    bytes += generator.image(resizedLogo, align: PosAlign.center);
    bytes += generator.text('Mashroa Dummar, Island 15',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Contact: +963-938-406-717',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr(ch: '-');

    // Invoice Details
    bytes += generator.text(
      isPremium ? 'Premium Client' : "Express Client",
      styles: PosStyles(
          bold: true,
          fontType: PosFontType.fontA,
          underline: true,
          align: PosAlign.center),
    );
    bytes += generator.feed(1);
    bytes += generator.text('Invoice ID: ${invoice.id}',
        styles: PosStyles(bold: true));
    bytes += generator.text('Date: ${invoice.date}');
    bytes += generator.text('Start: ${invoice.startTime}   End: ${invoice.endTime}');
    bytes += generator.hr(ch: '-');

    // Session Invoice
    bytes += generator.text(' Session Invoice: ',
        styles: PosStyles(reverse: true, bold: true));
    bytes += generator.feed(1);
    bytes += generator.row([
      PosColumn(
          text: 'Hours Amount: ${invoice.sessionInvoice.hoursAmount.toStringAsFixed(1)}',
          width: 5,
          styles: PosStyles(bold: true)),
      PosColumn(
          text: 'Session Price: ${invoice.sessionInvoice.sessionPrice.toStringAsFixed(0)} S.P',
          width: 7,
          styles: PosStyles(bold: true, align: PosAlign.right)),
    ]);
    bytes += generator.hr(ch: '-');

    // Buffet Invoice Section
    bytes += generator.text(' Buffet Invoices: ',
        styles: PosStyles(reverse: true, bold: true));
    if (invoice.buffetInvoices != null && invoice.buffetInvoices.isNotEmpty) {
      for (var buffet in invoice.buffetInvoices) {
        // Assuming buffet is an object with properties invoiceTime, orders, totalPrice, etc.
        print(buffet);
        bytes += generator.feed(1);
        bytes += generator.text('Buffet Invoice', styles: PosStyles(bold: true));
        bytes += generator.text('Time: ${buffet.invoiceTime}');

        // Table Header
        bytes += generator.hr(ch: '-');
        bytes += generator.row([
          PosColumn(text: 'Item', width: 6, styles: PosStyles(bold: true)),
          PosColumn(text: 'Qty', width: 2, styles: PosStyles(bold: true, align: PosAlign.right)),
          PosColumn(text: 'Price', width: 4, styles: PosStyles(bold: true, align: PosAlign.right)),
        ]);
        bytes += generator.hr(ch: '-');

        // Orders List
        if (buffet.orders != null && buffet.orders.isNotEmpty) {
          for (var order in buffet.orders) {
            // Assuming order is an object with properties productName, quantity, and price.
            bytes += generator.row([
              PosColumn(text: order.productName, width: 6),
              PosColumn(text: '${order.quantity}', width: 2, styles: PosStyles(align: PosAlign.right)),
              PosColumn(
                  text: '${order.price.toStringAsFixed(0)} S.P',
                  width: 4,
                  styles: PosStyles(align: PosAlign.right)),
            ]);
          }
        }

        // Buffet Total
        bytes += generator.hr(ch: '-');
        bytes += generator.text(
          'Total: ${buffet.totalPrice.toStringAsFixed(0)} S.P',
          styles: PosStyles(bold: true, align: PosAlign.right),
        );
        bytes += generator.hr(ch: '-');
      }
    } else {
      bytes += generator.text('No buffet invoices available');
    }

    bytes += generator.feed(1);

    // Grand Total
    bytes += generator.text(
      'TOTAL:       ${invoice.totalPrice.toStringAsFixed(0)} S.P',
      styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2),
    );
    bytes += generator.feed(2);

    // QR Code for Digital Copy
    bytes += generator.qrcode('https://lighthouse-hub.com/', size: QRSize.size6);
    bytes += generator.feed(1);

    // Thank You Message
    bytes += generator.text(
      'Thank You for Visiting',
      styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2),
    );
    bytes += generator.text('We value your support',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('See you again soon',
        styles: PosStyles(align: PosAlign.center));
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
