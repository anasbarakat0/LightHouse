// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:typed_data';

Future<String?> saveCsvFile({
  required List<int> bytes,
  required String fileName,
}) async {
  final safeFileName = _sanitizeFileName(fileName);
  final blob = html.Blob(
    [Uint8List.fromList(bytes)],
    'text/csv;charset=UTF-8',
  );
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..download = safeFileName
    ..style.display = 'none';

  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);

  return null;
}

String _sanitizeFileName(String fileName) {
  final sanitized = fileName.replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_');
  return sanitized.trim().isEmpty ? 'customer-report.csv' : sanitized;
}
