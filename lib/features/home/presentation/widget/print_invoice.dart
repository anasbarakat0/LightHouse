import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:lighthouse/core/utils/printing_commands.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import '../../../../core/utils/platform_service/platform_service.dart';

/// Helper function to translate text from Arabic to English
Future<String> _translateText(String text) async {
  try {
    // Check if text contains Arabic characters
    final bool containsArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    if (containsArabic) {
      final translator = GoogleTranslator();
      final translation =
          await translator.translate(text, from: 'ar', to: 'en');
      return translation.text;
    }
    return text;
  } catch (e) {
    debugPrint("Translation Error: $e");
    return text; // Return original text if translation fails
  }
}

/// Helper function to format time string to HH:mm:ss format
/// Removes microseconds and milliseconds if present
String _formatTime(String timeString) {
  try {
    // If time contains a dot, take only the part before it (HH:mm:ss)
    if (timeString.contains('.')) {
      return timeString.split('.').first;
    }
    // If time is already in HH:mm:ss format, return as is
    return timeString;
  } catch (e) {
    debugPrint("Time Format Error: $e");
    return timeString; // Return original if formatting fails
  }
}



/// Print detailed invoice (second invoice) with all data except discount note
Future<void> printDetailedInvoice(bool isPremium, String printerAddress,
    String printerName, dynamic invoice) async {
  debugPrint(
      "🖨️ printDetailedInvoice called - Starting detailed invoice printing...");

  // Get saved printer from settings, or use provided printerName as fallback
  final prefs = memory.get<SharedPreferences>();
  final savedPrinter = prefs.getString('selected_printer') ?? printerName;
  final actualPrinterName =
      savedPrinter.isNotEmpty ? savedPrinter : printerName;

  PrintMode mode = PrintMode.USB;
/// Helper function to format hours (decimal) to hours:minutes format
/// Example: 1.283333 -> "1:17", 0.083333 -> "0:05"
String _formatHoursToMinutes(double hours) {
  try {
    final totalMinutes = (hours * 60).round();
    final hoursPart = totalMinutes ~/ 60;
    final minutesPart = totalMinutes % 60;
    return '$hoursPart:${minutesPart.toString().padLeft(2, '0')}';
  } catch (e) {
    debugPrint("Hours Format Error: $e");
    return hours.toStringAsFixed(2); // Fallback to decimal format
  }
} 
  try {
    debugPrint("🖨️ Processing detailed invoice data...");
    // Translate client name
    final clientName =
        await _translateText('${invoice.firstName} ${invoice.lastName}');

    final ByteData data = await rootBundle.load('assets/images/logo_print.png');
    final Uint8List pngBytes = data.buffer.asUint8List();
    final img.Image logo = img.decodeImage(pngBytes)!;
    final img.Image resizedLogo = img.copyResize(logo, width: 400);
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // ========== MODERN DESIGN HEADER ==========
    bytes += generator.image(resizedLogo, align: PosAlign.center);
    bytes += generator.feed(1);

    // Business Info with modern styling
    bytes += generator.text('Mashroa Dummar, Island 15',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Contact: +963-952-466-084',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(1);


    // ========== CLIENT INFORMATION ==========
    bytes += generator.text('---- CLIENT INFO ----',
        styles: PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    bytes += generator.feed(1);
    bytes += generator.row([
      PosColumn(
          text: 'Name:',
          width: 2,
          styles: PosStyles(
              bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          text: clientName,
          width: 10,
          styles: PosStyles(
              bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'ID:',
          width: 2,
          styles: PosStyles(
              bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          text: invoice.userId,
          width: 10,
          styles:
              PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Date:',
          width: 2,
          styles: PosStyles(
              bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          text: invoice.date,
          width: 10,
          styles:
              PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Start:',
          width: 2,
          styles: PosStyles(
              bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          text: _formatTime(invoice.startTime),
          width: 4,
          styles:
              PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          text: 'End:',
          width: 2,
          styles: PosStyles(
              bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          text: _formatTime(invoice.endTime),
          width: 4,
          styles:
              PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    bytes += generator.feed(1);
bytes += generator.text('=' * 64, styles: PosStyles(align: PosAlign.center));

    // ========== SESSION INVOICE DETAILS ==========
    bytes += generator.text('  SESSION INVOICE  ',
        styles: PosStyles(
            reverse: true,
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    bytes += generator.feed(1);

    // Hours and Price - تكبير الخط
    bytes += generator.row([
      PosColumn(
          text: 'Hours: ${_formatHoursToMinutes(invoice.sessionInvoice.hoursAmount)}',
          width: 6,
          styles: PosStyles(
              bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          text:
              '${(invoice.sessionInvoice.hoursAmount * invoice.sessionInvoice.hourlyPrice).toString()} S.P',
          width: 6,
          styles: PosStyles(
              bold: true,
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1)),
    ]);
    bytes += generator.feed(1);

    // ========== BUFFET INVOICES ==========
    if (invoice.buffetInvoices != null && invoice.buffetInvoices.isNotEmpty) {
      bytes += generator.text('  BUFFET INVOICES  ',
          styles: PosStyles(
              reverse: true,
              bold: true,
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1));
      bytes += generator.feed(1);
      var totalBuffet = 0.0;
bytes += generator.text('-' * 64, styles: PosStyles(align: PosAlign.center));
      bytes += generator.row([
        PosColumn(text: 'Item', width: 6, styles: PosStyles(bold: true)),
        PosColumn(
            text: 'Qty',
            width: 2,
            styles: PosStyles(bold: true, align: PosAlign.right)),
        PosColumn(
            text: 'Price',
            width: 4,
            styles: PosStyles(bold: true, align: PosAlign.right)),
      ]);
bytes += generator.text('-' * 64, styles: PosStyles(align: PosAlign.center));
      for (var buffet in invoice.buffetInvoices) {
        // Handle both Map and BuffetInvoice object
        final orders = buffet is Map
            ? (buffet['orders'] as List<dynamic>? ?? [])
            : buffet.orders;
        final totalPrice = buffet is Map
            ? ((buffet['totalPrice'] is double)
                ? buffet['totalPrice']
                : (buffet['totalPrice'] as num?)?.toDouble() ?? 0.0)
            : buffet.totalPrice;

        // Orders List
        if (orders.isNotEmpty) {
          for (var order in orders) {
            // Handle both Map and Order object
            final productName = order is Map
                ? (order['productName'] as String? ?? '')
                : order.productName;
            final quantity = order is Map
                ? (order['quantity'] as int? ?? 0)
                : order.quantity;
            final price = order is Map
                ? ((order['price'] is double)
                    ? order['price']
                    : (order['price'] as num?)?.toDouble() ?? 0.0)
                : order.price;

            // Translate product name
            final translatedProductName = await _translateText(productName);
            bytes += generator.row([
              PosColumn(text: translatedProductName, width: 6),
              PosColumn(
                  text: '$quantity',
                  width: 2,
                  styles: PosStyles(align: PosAlign.right)),
              PosColumn(
                  text: '${price.toString()} S.P',
                  width: 4,
                  styles: PosStyles(align: PosAlign.right)),
            ]);
          }
        }

        totalBuffet += totalPrice;
      }
      // Buffet Total
bytes += generator.text('-' * 64, styles: PosStyles(align: PosAlign.center));
      bytes += generator.text(
        'Subtotal: ${totalBuffet.toString()} S.P',
        styles: PosStyles(bold: true, align: PosAlign.right),
      );
      bytes += generator.feed(1);
bytes += generator.text('=' * 64, styles: PosStyles(align: PosAlign.center));
    } else {
      bytes += generator.text('No buffet orders',
          styles: PosStyles(align: PosAlign.center));
      bytes += generator.feed(1);
    }

    // ========== GRAND TOTAL ==========

    // تحديد نوع الحسم من summaryInvoice
    final summaryInvoice = invoice.summaryInvoice;
    final hasCouponDiscount = summaryInvoice != null &&
        summaryInvoice.discountAmount != null &&
        summaryInvoice.discountAmount! > 0;
    final hasManualDiscount = summaryInvoice != null &&
        summaryInvoice.manualDiscountAmount != null &&
        summaryInvoice.manualDiscountAmount! > 0;

    // حساب sessionPrice
    final sessionPrice =
        invoice.sessionInvoice.hoursAmount * invoice.sessionInvoice.hourlyPrice;

    // الحالة 1: لا يوجد حسم إطلاقاً
    if (!hasCouponDiscount && !hasManualDiscount) {
      // فقط السعر النهائي
      bytes += generator.feed(1);
      bytes += generator.text(  
        'Total Price: ${invoice.totalPrice.toStringAsFixed(0)} S.P',
        styles: PosStyles(
            bold: true,
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2),
      );
    }
    // الحالة 2: حسم كوبون فقط
    else if (hasCouponDiscount && !hasManualDiscount && summaryInvoice != null) {
      if (summaryInvoice.totalInvoiceBeforeDiscount != null) {
        bytes += generator.text(
          'Before Discount: ${summaryInvoice.totalInvoiceBeforeDiscount!.toString()} S.P',
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1),
        );
      }
      bytes += generator.text(
        'Coupon Discount: -${summaryInvoice.discountAmount!.toString()} S.P',
        styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1),
      );
      if (summaryInvoice.totalInvoiceAfterDiscount != null) {
        bytes += generator.feed(1);
        bytes += generator.text(
          'After Discount: ${summaryInvoice.totalInvoiceAfterDiscount!.toString()} S.P',
          styles: PosStyles(
              bold: true,
              align: PosAlign.right,
              height: PosTextSize.size2,
              width: PosTextSize.size2),
        );
      }
    }
    // الحالة 3: حسم يدوي فقط
    else if (!hasCouponDiscount && hasManualDiscount && summaryInvoice != null) {
      // السعر قبل الحسم اليدوي (قد يكون sessionPrice أو totalInvoiceAfterDiscount)
      final priceBeforeManual =
          summaryInvoice.totalInvoiceAfterDiscount ?? sessionPrice;
      bytes += generator.text(
        'Session Price: ${priceBeforeManual.toString()} S.P',
        styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1),
      );
      bytes += generator.text(
        'Manual Discount: -${summaryInvoice.manualDiscountAmount!.toString()} S.P',
        styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1),
      );
      if (summaryInvoice.finalTotalAfterAllDiscounts != null) {
        bytes += generator.feed(1);
        bytes += generator.text(
          'Total Price: ${summaryInvoice.finalTotalAfterAllDiscounts!.toString()} S.P',
          styles: PosStyles(
              bold: true,
              align: PosAlign.right,
              height: PosTextSize.size2,
              width: PosTextSize.size2),
        );
      }
    }
    // الحالة 4: حسم كوبون ويدوي معاً
    else if (hasCouponDiscount && hasManualDiscount && summaryInvoice != null) {
      if (summaryInvoice.totalInvoiceBeforeDiscount != null) {
        bytes += generator.text(
          'Before Discount: ${summaryInvoice.totalInvoiceBeforeDiscount!.toString()} S.P',
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1),
        );
      }
      bytes += generator.text(
        'Coupon Discount: -${summaryInvoice.discountAmount!.toString()} S.P',
        styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1),
      );
      if (summaryInvoice.totalInvoiceAfterDiscount != null) {
        bytes += generator.text(
          'After Coupon: ${summaryInvoice.totalInvoiceAfterDiscount!.toString()} S.P',
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1),
        );
      }
      bytes += generator.text(
        'Manual Discount: -${summaryInvoice.manualDiscountAmount!.toString()} S.P',
        styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1),
      );
      if (summaryInvoice.finalTotalAfterAllDiscounts != null) {
        bytes += generator.feed(1);
        bytes += generator.text(
          'Total Price: ${summaryInvoice.finalTotalAfterAllDiscounts!.toString()} S.P',
          styles: PosStyles(
              bold: true,
              align: PosAlign.right,
              height: PosTextSize.size2,
              width: PosTextSize.size2),
        );
      }
    }

    bytes += generator.text('=' * 64, styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(1);

    // ========== QR CODE ==========
    bytes += generator.text('Digital Copy Available',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(1);
    bytes += generator.qrcode(
        'https://app.lighthouse-hub.com/sessions/${invoice.id}',
        size: QRSize.size6);
    bytes += generator.feed(1);

    // ========== FOOTER ==========
    bytes += generator.text('=' * 64, styles: PosStyles(align: PosAlign.center));
    bytes += generator.text(
      'Thank You!',
      styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size1),
    );
    bytes += generator.text('We appreciate your visit',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('See you again soon',
        styles: PosStyles(align: PosAlign.center));   
    bytes += generator.feed(2);
    bytes += generator.cut(mode: PosCutMode.full);

    // Print Logic
    debugPrint("🖨️ Sending detailed invoice to printer...");
    final service = PlatformService();
    if (mode == PrintMode.NETWORK) {
      debugPrint("NETWORK PRINTING - Detailed Invoice");
      await service.printSocket(host: printerAddress, port: 9100, bytes: bytes);
    } else {
      debugPrint("USB PRINTING - Detailed Invoice");
      debugPrint("Using printer: $actualPrinterName");
      await service.printDirectWindows(
          printerName: actualPrinterName, bytes: bytes);
    }
    debugPrint("✅ Detailed invoice printed successfully!");
  } catch (e) {
    debugPrint("❌ Print Detailed Invoice Error: $e");
    debugPrint("Error stack trace: ${StackTrace.current}");
  }
}
