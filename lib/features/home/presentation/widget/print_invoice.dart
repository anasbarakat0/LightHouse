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
      final translation = await translator.translate(text, from: 'ar', to: 'en');
      return translation.text;
    }
    return text;
  } catch (e) {
    debugPrint("Translation Error: $e");
    return text; // Return original text if translation fails
  }
}

Future<void> printInvoice(
    bool isPremium, String printerAddress, String printerName, dynamic invoice) async {
  // Get saved printer from settings, or use provided printerName as fallback
  final prefs = memory.get<SharedPreferences>();
  final savedPrinter = prefs.getString('selected_printer') ?? printerName;
  final actualPrinterName = savedPrinter.isNotEmpty ? savedPrinter : printerName;
  
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
      'Premium Client',
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
          text: 'Session Price: ${(invoice.sessionInvoice.hoursAmount * invoice.sessionInvoice.hourlyPrice).toStringAsFixed(0)} S.P',
          width: 7,
          styles: PosStyles(bold: true, align: PosAlign.right)),
    ]);
    bytes += generator.hr(ch: '-');

    // Buffet Invoice Section
    bytes += generator.text(' Buffet Invoices: ',
        styles: PosStyles(reverse: true, bold: true));
    if (invoice.buffetInvoices != null && invoice.buffetInvoices.isNotEmpty) {
      for (var buffet in invoice.buffetInvoices) {
        // Handle both Map and BuffetInvoice object
        final invoiceTime = buffet is Map 
            ? (buffet['invoiceTime'] as String? ?? '')
            : buffet.invoiceTime;
        final orders = buffet is Map 
            ? (buffet['orders'] as List<dynamic>? ?? [])
            : buffet.orders;
        final totalPrice = buffet is Map 
            ? ((buffet['totalPrice'] is double) 
                ? buffet['totalPrice'] 
                : (buffet['totalPrice'] as num?)?.toDouble() ?? 0.0)
            : buffet.totalPrice;
        
        bytes += generator.feed(1);
        bytes += generator.text('Buffet Invoice', styles: PosStyles(bold: true));
        bytes += generator.text('Time: $invoiceTime');

        // Table Header
        bytes += generator.hr(ch: '-');
        bytes += generator.row([
          PosColumn(text: 'Item', width: 6, styles: PosStyles(bold: true)),
          PosColumn(text: 'Qty', width: 2, styles: PosStyles(bold: true, align: PosAlign.right)),
          PosColumn(text: 'Price', width: 4, styles: PosStyles(bold: true, align: PosAlign.right)),
        ]);
        bytes += generator.hr(ch: '-');

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
            
            // Translate product name from Arabic to English
            final translatedProductName = await _translateText(productName);
            bytes += generator.row([
              PosColumn(text: translatedProductName, width: 6),
              PosColumn(text: '$quantity', width: 2, styles: PosStyles(align: PosAlign.right)),
              PosColumn(
                  text: '${price.toStringAsFixed(0)} S.P',
                  width: 4,
                  styles: PosStyles(align: PosAlign.right)),
            ]);
          }
        }

        // Buffet Total
        bytes += generator.hr(ch: '-');
        bytes += generator.text(
          'Total: ${totalPrice.toStringAsFixed(0)} S.P',
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
    debugPrint("🖨️ Sending invoice to printer...");
    final service = PlatformService();
    if (mode == PrintMode.NETWORK) {
      debugPrint("NETWORK PRINTING - Invoice");
      await service.printSocket(host: printerAddress, port: 9100, bytes: bytes);
    } else {
      debugPrint("USB PRINTING - Invoice");
      debugPrint("Using printer: $actualPrinterName");
      await service.printDirectWindows(printerName: actualPrinterName, bytes: bytes);
    }
    debugPrint("✅ Invoice printed successfully!");
  } catch (e) {
    debugPrint("❌ Print Invoice Error: $e");
    debugPrint("Error stack trace: ${StackTrace.current}");
    rethrow; // Re-throw to allow caller to handle
  }
}

/// Print detailed invoice (second invoice) with all data except discount note
Future<void> printDetailedInvoice(
    bool isPremium, String printerAddress, String printerName, dynamic invoice) async {
  debugPrint("🖨️ printDetailedInvoice called - Starting detailed invoice printing...");
  
  // Get saved printer from settings, or use provided printerName as fallback
  final prefs = memory.get<SharedPreferences>();
  final savedPrinter = prefs.getString('selected_printer') ?? printerName;
  final actualPrinterName = savedPrinter.isNotEmpty ? savedPrinter : printerName;
  
  PrintMode mode = PrintMode.USB;

  try {
    debugPrint("🖨️ Processing detailed invoice data...");
    // Translate client name
    final clientName = await _translateText('${invoice.firstName} ${invoice.lastName}');
    
    final ByteData data = await rootBundle.load('assets/images/logo_print.png');
    final Uint8List pngBytes = data.buffer.asUint8List();
    final img.Image logo = img.decodeImage(pngBytes)!;
    final img.Image resizedLogo = img.copyResize(logo, width: 400);
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // ========== MODERN DESIGN HEADER ==========
    bytes += generator.feed(1);
    bytes += generator.image(resizedLogo, align: PosAlign.center);
    bytes += generator.feed(1);
    
    // Business Info with modern styling
    bytes += generator.hr(ch: '=');
    bytes += generator.text('Mashroa Dummar',
        styles: PosStyles(bold: true, align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size1));
    bytes += generator.text('Island 15, Damascus',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Contact: +963-938-406-717',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr(ch: '=');
    bytes += generator.feed(1);

    // ========== INVOICE TYPE HEADER ==========
    bytes += generator.text('PREMIUM CLIENT INVOICE',
        styles: PosStyles(
            bold: true,
            fontType: PosFontType.fontB,
            underline: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size1));
    bytes += generator.feed(1);

    // ========== CLIENT INFORMATION ==========
    bytes += generator.text('---- CLIENT INFO ----',
        styles: PosStyles(bold: true, align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1));
    bytes += generator.feed(1);
    bytes += generator.row([
      PosColumn(text: 'Name:', width: 3, styles: PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: clientName, width: 9, styles: PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'ID:', width: 3, styles: PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: invoice.userId, width: 9, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    bytes += generator.feed(1);

    // ========== SESSION INFORMATION ==========
    bytes += generator.text('---- SESSION INFO ----',
        styles: PosStyles(bold: true, align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1));
    bytes += generator.feed(1);
    bytes += generator.row([
      PosColumn(text: 'Invoice ID:', width: 4, styles: PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: invoice.id, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Date:', width: 4, styles: PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: invoice.date, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Start:', width: 4, styles: PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: invoice.startTime, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'End:', width: 4, styles: PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: invoice.endTime, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    bytes += generator.feed(1);
    bytes += generator.hr(ch: '=');

    // ========== SESSION INVOICE DETAILS ==========
    bytes += generator.text('  SESSION INVOICE  ',
        styles: PosStyles(reverse: true, bold: true, align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1));
    bytes += generator.feed(1);
    
    // Hours and Price - تكبير الخط
    bytes += generator.row([
      PosColumn(
          text: 'Hours: ${invoice.sessionInvoice.hoursAmount.toString()}',
          width: 6,
          styles: PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          text: '${(invoice.sessionInvoice.hoursAmount * invoice.sessionInvoice.hourlyPrice).toString()} S.P',
          width: 6,
          styles: PosStyles(bold: true, align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    bytes += generator.feed(1);
    
    // تحديد نوع الحسم من summaryInvoice
    final summaryInvoice = invoice.summaryInvoice;
    final hasCouponDiscount = summaryInvoice?.discountAmount != null && 
                              summaryInvoice!.discountAmount! > 0;
    final hasManualDiscount = summaryInvoice?.manualDiscountAmount != null && 
                              summaryInvoice!.manualDiscountAmount! > 0;
    
    // حساب sessionPrice
    final sessionPrice = invoice.sessionInvoice.hoursAmount * invoice.sessionInvoice.hourlyPrice;
    
    // الحالة 1: لا يوجد حسم إطلاقاً
    if (!hasCouponDiscount && !hasManualDiscount) {
      // فقط السعر النهائي
      bytes += generator.text(
        'Session Price: ${sessionPrice.toStringAsFixed(0)} S.P',
        styles: PosStyles(bold: true, align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
      );
    }
    // الحالة 2: حسم كوبون فقط
    else if (hasCouponDiscount && !hasManualDiscount) {
      if (summaryInvoice?.totalInvoiceBeforeDiscount != null) {
        bytes += generator.text(
          'Before Discount: ${summaryInvoice!.totalInvoiceBeforeDiscount!.toString()} S.P',
          styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
        );
      }
      bytes += generator.text(
        'Coupon Discount: -${summaryInvoice!.discountAmount!.toString()} S.P',
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
      );
      if (summaryInvoice.totalInvoiceAfterDiscount != null) {
        bytes += generator.text(
          'After Discount: ${summaryInvoice.totalInvoiceAfterDiscount!.toString()} S.P',
          styles: PosStyles(bold: true, align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
        );
      }
    }
    // الحالة 3: حسم يدوي فقط
    else if (!hasCouponDiscount && hasManualDiscount) {
      // السعر قبل الحسم اليدوي (قد يكون sessionPrice أو totalInvoiceAfterDiscount)
      final priceBeforeManual = summaryInvoice?.totalInvoiceAfterDiscount ?? sessionPrice;
      bytes += generator.text(
        'Session Price: ${priceBeforeManual.toString()} S.P',
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
      );
      bytes += generator.text(
        'Manual Discount: -${summaryInvoice!.manualDiscountAmount!.toString()} S.P',
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
      );
      if (summaryInvoice.finalTotalAfterAllDiscounts != null) {
        bytes += generator.text(
          'Final Price: ${summaryInvoice.finalTotalAfterAllDiscounts!.toString()} S.P',
          styles: PosStyles(bold: true, align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
        );
      }
    }
    // الحالة 4: حسم كوبون ويدوي معاً
    else if (hasCouponDiscount && hasManualDiscount) {
      if (summaryInvoice?.totalInvoiceBeforeDiscount != null) {
        bytes += generator.text(
          'Before Discount: ${summaryInvoice!.totalInvoiceBeforeDiscount!.toString()} S.P',
          styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
        );
      }
      bytes += generator.text(
        'Coupon Discount: -${summaryInvoice!.discountAmount!.toString()} S.P',
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
      );
      if (summaryInvoice.totalInvoiceAfterDiscount != null) {
        bytes += generator.text(
          'After Coupon: ${summaryInvoice.totalInvoiceAfterDiscount!.toString()} S.P',
          styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
        );
      }
      bytes += generator.text(
        'Manual Discount: -${summaryInvoice.manualDiscountAmount!.toString()} S.P',
        styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
      );
      if (summaryInvoice.finalTotalAfterAllDiscounts != null) {
        bytes += generator.text(
          'Final Price: ${summaryInvoice.finalTotalAfterAllDiscounts!.toString()} S.P',
          styles: PosStyles(bold: true, align: PosAlign.right, height: PosTextSize.size1, width: PosTextSize.size1),
        );
      }
    }
    
    bytes += generator.feed(1);
    bytes += generator.hr(ch: '=');

    // ========== BUFFET INVOICES ==========
    if (invoice.buffetInvoices != null && invoice.buffetInvoices.isNotEmpty) {
      bytes += generator.text('  BUFFET INVOICES  ',
          styles: PosStyles(reverse: true, bold: true, align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1));
      bytes += generator.feed(1);
      
      for (var buffet in invoice.buffetInvoices) {
        // Handle both Map and BuffetInvoice object
        final invoiceTime = buffet is Map 
            ? (buffet['invoiceTime'] as String? ?? '')
            : buffet.invoiceTime;
        final orders = buffet is Map 
            ? (buffet['orders'] as List<dynamic>? ?? [])
            : buffet.orders;
        final totalPrice = buffet is Map 
            ? ((buffet['totalPrice'] is double) 
                ? buffet['totalPrice'] 
                : (buffet['totalPrice'] as num?)?.toDouble() ?? 0.0)
            : buffet.totalPrice;
        
        bytes += generator.text('-----------------------',
            styles: PosStyles(align: PosAlign.center));
        bytes += generator.feed(1);
        
        // Translate buffet invoice time
        final buffetTime = await _translateText(invoiceTime);
        bytes += generator.text('Buffet Invoice',
            styles: PosStyles(bold: true, align: PosAlign.center));
        bytes += generator.text('Time: $buffetTime',
            styles: PosStyles(align: PosAlign.center));
        bytes += generator.feed(1);

        // Table Header
        bytes += generator.hr(ch: '-');
        bytes += generator.row([
          PosColumn(text: 'Item', width: 6, styles: PosStyles(bold: true)),
          PosColumn(text: 'Qty', width: 2, styles: PosStyles(bold: true, align: PosAlign.right)),
          PosColumn(text: 'Price', width: 4, styles: PosStyles(bold: true, align: PosAlign.right)),
        ]);
        bytes += generator.hr(ch: '-');

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
              PosColumn(text: '$quantity', width: 2, styles: PosStyles(align: PosAlign.right)),
              PosColumn(
                  text: '${price.toString()} S.P',
                  width: 4,
                  styles: PosStyles(align: PosAlign.right)),
            ]);
          }
        }

        // Buffet Total
        bytes += generator.hr(ch: '-');
        bytes += generator.text(
          'Subtotal: ${totalPrice.toString()} S.P',
          styles: PosStyles(bold: true, align: PosAlign.right),
        );
        bytes += generator.feed(1);
      }
      bytes += generator.hr(ch: '=');
    } else {
      bytes += generator.text('No buffet orders',
          styles: PosStyles(align: PosAlign.center));
      bytes += generator.feed(1);
    }

    // ========== GRAND TOTAL ==========
    bytes += generator.feed(1);
    bytes += generator.hr(ch: '=');
    bytes += generator.text(
      'GRAND TOTAL',
      styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2),
    );
    bytes += generator.text(
      '${invoice.totalPrice.toString()} S.P',
      styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2),
    );
    bytes += generator.hr(ch: '=');
    bytes += generator.feed(2);

    // ========== QR CODE ==========
    bytes += generator.text('Digital Copy Available',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(1);
    bytes += generator.qrcode('https://lighthouse-hub.com/', size: QRSize.size6);
    bytes += generator.feed(1);

    // ========== FOOTER ==========
    bytes += generator.hr(ch: '=');
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
    bytes += generator.hr(ch: '=');
    bytes += generator.feed(3);
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
      await service.printDirectWindows(printerName: actualPrinterName, bytes: bytes);
    }
    debugPrint("✅ Detailed invoice printed successfully!");
  } catch (e) {
    debugPrint("❌ Print Detailed Invoice Error: $e");
    debugPrint("Error stack trace: ${StackTrace.current}");
  }
}
