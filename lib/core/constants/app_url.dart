import 'package:flutter/foundation.dart' show kIsWeb;

const String apiOrigin = "http://api.lighthouse-hub.com:3010";
const String baseUrl = kIsWeb ? "/api-proxy" : apiOrigin;
