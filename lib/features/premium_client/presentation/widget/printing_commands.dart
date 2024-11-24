import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart';

class WindowsPrintScreen extends StatefulWidget {
  const WindowsPrintScreen({super.key});

  @override
  _WindowsPrintScreenState createState() => _WindowsPrintScreenState();
}

class _WindowsPrintScreenState extends State<WindowsPrintScreen> {
  String printerName = 'POS-58(copy of 2)';

  @override
  void initState() {
    super.initState();
    listPrinters();
  }

  Future<List<int>> generateReceipt() async {
    final profile = await CapabilityProfile.load(
      name: 'default',
    );
    final generator = Generator(
      PaperSize.mm58,
      profile,
    );

    List<int> bytes = [];

    bytes += generator.text(
      'Lighthouse Coworking Space',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
      ),
    );
    bytes += generator.text(
      'Receipt',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: 'Item',
        width: 6,
      ),
      PosColumn(
        text: 'Qty',
        width: 2,
      ),
      PosColumn(
        text: 'Price',
        width: 4,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);
    bytes += generator.hr();
    bytes += generator.feed(2);
    bytes += generator.text(
      'Thank you!',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.cut();

    return bytes;
  }

  void printReceipt() async {
    // List available printers
    // listPrinters();

    // Generate the receipt data
    List<int> bytes = await generateReceipt();
    Uint8List data = Uint8List.fromList(bytes);

    // Convert Dart strings to C strings
    final hPrinter = malloc<HANDLE>();
    final printerNamePtr = printerName.toNativeUtf16();

    // Open a handle to the printer
    final openResult = OpenPrinter(printerNamePtr, hPrinter, ffi.nullptr);
    if (openResult == 0) {
      print('Failed to open printer');
      printLastError('OpenPrinter');
      malloc.free(hPrinter);
      calloc.free(printerNamePtr);
      return;
    }

    // Set up the document info
    final docInfo = calloc<DOC_INFO_1>();
    docInfo.ref.pDocName = TEXT('Test Document');
    docInfo.ref.pOutputFile = ffi.nullptr;
    docInfo.ref.pDatatype = TEXT('RAW');

    // Start a document
    final jobId = StartDocPrinter(hPrinter.value, 1, docInfo);
    if (jobId == 0) {
      print('Failed to start document');
      printLastError('StartDocPrinter');
      ClosePrinter(hPrinter.value);
      malloc.free(hPrinter);
      calloc.free(printerNamePtr);
      calloc.free(docInfo);
      return;
    }

    // Start a page
    if (StartPagePrinter(hPrinter.value) == 0) {
      print('Failed to start page');
      printLastError('StartPagePrinter');
      EndDocPrinter(hPrinter.value);
      ClosePrinter(hPrinter.value);
      malloc.free(hPrinter);
      calloc.free(printerNamePtr);
      calloc.free(docInfo);
      return;
    }

    // Write data to the printer
    final bytesWritten = malloc<DWORD>();
    final dataPointer = Uint8ListPointer(data).allocatePointer();
    final success = WritePrinter(
      hPrinter.value,
      dataPointer,
      data.length,
      bytesWritten,
    );
    if (success == 0) {
      print('Failed to write to printer');
      printLastError('WritePrinter');
    }

    // End the page
    EndPagePrinter(hPrinter.value);

    // End the document
    EndDocPrinter(hPrinter.value);

    // Close the printer handle
    ClosePrinter(hPrinter.value);

    // Free allocated memory
    malloc.free(dataPointer);
    malloc.free(bytesWritten);
    calloc.free(docInfo.ref.pDocName);
    calloc.free(docInfo.ref.pDatatype);
    calloc.free(docInfo);
    calloc.free(printerNamePtr);
    malloc.free(hPrinter);

    print('Print job completed');
  }

  void printLastError(String functionName) {
    int errorCode = GetLastError();
    final messageBuffer = calloc<ffi.Uint16>(1024).cast<Utf16>();
    FormatMessage(
      FORMAT_MESSAGE_OPTIONS.FORMAT_MESSAGE_FROM_SYSTEM |
          FORMAT_MESSAGE_OPTIONS.FORMAT_MESSAGE_IGNORE_INSERTS,
      ffi.nullptr,
      errorCode,
      0,
      messageBuffer,
      1024,
      ffi.nullptr,
    );
    final errorMessage = messageBuffer.toDartString();
    print('$functionName failed with error $errorCode: $errorMessage');
    calloc.free(messageBuffer);
  }

  void listPrinters() {
    final bufferSize = malloc<DWORD>();
    final printerCount = malloc<DWORD>();

    // Get required buffer size
    EnumPrinters(PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS, ffi.nullptr, 2,
        ffi.nullptr, 0, bufferSize, printerCount);

    final bytesNeeded = bufferSize.value;
    final printerInfoPtr = malloc<ffi.Uint8>(bytesNeeded);

    // Get printer info
    final result = EnumPrinters(PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS,
        ffi.nullptr, 2, printerInfoPtr, bytesNeeded, bufferSize, printerCount);

    if (result == 0) {
      print('Failed to enumerate printers');
      printLastError('EnumPrinters');
      malloc.free(bufferSize);
      malloc.free(printerCount);
      malloc.free(printerInfoPtr);
      return;
    }

    final count = printerCount.value;
    final printerInfo = printerInfoPtr.cast<PRINTER_INFO_2>();

    print('Available Printers:');
    for (var i = 0; i < count; i++) {
      final printer = printerInfo.elementAt(i).ref;
      final name = printer.pPrinterName.toDartString();
      print('Printer ${i + 1}: $name');
    }

    malloc.free(printerInfoPtr);
    malloc.free(bufferSize);
    malloc.free(printerCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Windows USB Print'),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: printReceipt,
                child: const Text('Print Receipt'),
              ),
            ),
            const Text("play", style: TextStyle())
          ],
        ));
  }
}

extension Uint8ListPointer on Uint8List {
  ffi.Pointer<ffi.Uint8> allocatePointer() {
    final ptr = malloc<ffi.Uint8>(length);
    final byteList = ptr.asTypedList(length);
    byteList.setAll(0, this);
    return ptr;
  }
}
