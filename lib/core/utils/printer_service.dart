import 'package:lighthouse/core/utils/printing_commands.dart';

class PrinterServiceSingleton {
  static final PrinterServiceSingleton _instance =
      PrinterServiceSingleton._internal();

  late final PrinterService printerService;

  factory PrinterServiceSingleton() {
    return _instance;
  }

  PrinterServiceSingleton._internal() {
    printerService = PrinterService(
      printerName: "XP-80C (copy 1)",
      printerAddress: "192.168.110.15",
      mode: PrintMode.USB,
    );
  }
}

