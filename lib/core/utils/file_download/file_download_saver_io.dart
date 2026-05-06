import 'dart:io';

Future<String?> saveCsvFile({
  required List<int> bytes,
  required String fileName,
}) async {
  final directory = await _resolveDownloadDirectory();
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  final safeFileName = _sanitizeFileName(fileName);
  final file = await _uniqueFile(directory, safeFileName);
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

Future<Directory> _resolveDownloadDirectory() async {
  final home =
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];

  if (home != null && home.isNotEmpty) {
    final downloads = Directory(
      '$home${Platform.pathSeparator}Downloads',
    );
    if (await downloads.exists()) {
      return downloads;
    }
  }

  return Directory.systemTemp;
}

Future<File> _uniqueFile(Directory directory, String fileName) async {
  final separator = Platform.pathSeparator;
  final dotIndex = fileName.lastIndexOf('.');
  final baseName = dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName;
  final extension = dotIndex > 0 ? fileName.substring(dotIndex) : '';

  var candidate = File('${directory.path}$separator$fileName');
  var counter = 1;

  while (await candidate.exists()) {
    candidate = File(
      '${directory.path}$separator$baseName ($counter)$extension',
    );
    counter++;
  }

  return candidate;
}

String _sanitizeFileName(String fileName) {
  final sanitized = fileName.replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_');
  return sanitized.trim().isEmpty ? 'customer-report.csv' : sanitized;
}
