import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:lighthouse/core/utils/printing_commands.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

Future<void> printProductSticker(ProductModel product) async {
  final prefs = memory.get<SharedPreferences>();
  final selectedPrinter =
      prefs.getString('selected_printer') ?? 'XP-80C (copy 1)';

  final printerService = PrinterService(
    printerName: selectedPrinter,
    printerAddress: '',
    mode: PrintMode.USB,
  );

  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  final englishName = await _resolveEnglishProductName(product.name);
  final labelName = _fitLabelName(englishName);

  var bytes = <int>[];

  // Compact 80x40mm-style label: product name on top, barcode beneath it.
  bytes += generator.feed(1);
  bytes += generator.text(
    labelName,
    styles: PosStyles(
      align: PosAlign.center,
      bold: true,
      height: PosTextSize.size2,
      width: PosTextSize.size2,
      codeTable: 'CP1252',
    ),
    linesAfter: 1,
  );
  bytes += generator.barcode(
    _buildEscPosBarcode(product.barCode),
    align: PosAlign.center,
    width: 2,
    height: 96,
    font: BarcodeFont.fontB,
    textPos: BarcodeText.below,
  );
  bytes += generator.feed(1);
  bytes += generator.cut(mode: PosCutMode.full);

  await printerService.sendToPrinter(bytes);
}

Future<String> _resolveEnglishProductName(String name) async {
  final normalized = name.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (normalized.isEmpty) return 'Product';

  final hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(normalized);
  if (!hasArabic) return normalized;

  try {
    final translation =
        await GoogleTranslator().translate(normalized, from: 'ar', to: 'en');
    final translated = translation.text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (translated.isNotEmpty) return translated;
  } catch (e) {
    debugPrint('Product name translation failed: $e');
  }

  return _transliterateArabicText(normalized);
}

Barcode _buildEscPosBarcode(String rawBarcode) {
  final cleaned = rawBarcode.trim();
  final digitsOnly = cleaned.replaceAll(RegExp(r'\D'), '');

  if (digitsOnly.length == 12 || digitsOnly.length == 13) {
    return Barcode.ean13(digitsOnly.split(''));
  }

  return Barcode.code128('{B$cleaned'.split(''));
}

String _fitLabelName(String text) {
  final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (normalized.length <= 28) return normalized;

  final words = normalized.split(' ');
  final lines = <String>[];
  var current = '';

  for (final word in words) {
    final candidate = current.isEmpty ? word : '$current $word';
    if (candidate.length <= 18) {
      current = candidate;
      continue;
    }

    if (current.isNotEmpty) {
      lines.add(current);
    }
    current = word;

    if (lines.length == 1) break;
  }

  if (current.isNotEmpty && lines.length < 2) {
    lines.add(current);
  }

  final fitted = lines.take(2).join('\n');
  return fitted.length >= normalized.length ? fitted : '$fitted...';
}

const Map<String, String> _arabicToLatinMap = {
  'ا': 'a',
  'أ': 'a',
  'إ': 'i',
  'آ': 'aa',
  'ب': 'b',
  'ت': 't',
  'ث': 'th',
  'ج': 'j',
  'ح': 'h',
  'خ': 'kh',
  'د': 'd',
  'ذ': 'dh',
  'ر': 'r',
  'ز': 'z',
  'س': 's',
  'ش': 'sh',
  'ص': 's',
  'ض': 'd',
  'ط': 't',
  'ظ': 'z',
  'ع': 'a',
  'غ': 'gh',
  'ف': 'f',
  'ق': 'q',
  'ك': 'k',
  'ل': 'l',
  'م': 'm',
  'ن': 'n',
  'ه': 'h',
  'ة': 'a',
  'و': 'w',
  'ؤ': 'w',
  'ي': 'y',
  'ى': 'a',
  'ئ': 'y',
  'ء': 'a',
};

String _transliterateArabicText(String text) {
  final normalized = text.replaceAll('لا', 'la');
  final buffer = StringBuffer();

  for (final rune in normalized.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_arabicToLatinMap[char] ?? char);
  }

  final transliterated =
      buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  if (transliterated.isEmpty) return 'Product';

  return transliterated
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}
