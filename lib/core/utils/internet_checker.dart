import 'package:internet_connection_checker/internet_connection_checker.dart';

final internetConnectionChecker =
    InternetConnectionChecker.createInstance(addresses: [
  AddressCheckOption(
    uri: Uri.parse("https://www.google.com"),
    timeout: Duration(seconds: 1),
  ),
  AddressCheckOption(
    uri: Uri.parse("https://1.1.1.1"), // ✅ Cloudflare for backup check
    timeout: Duration(seconds: 1),
  ),
]);
