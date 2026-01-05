import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkConnection {
  final InternetConnectionChecker internetConnectionChecker;

  // Cache للنتيجة لتقليل الـ checks المتكررة
  bool? _cachedResult;
  DateTime? _lastCheckTime;
  static const Duration _cacheDuration = Duration(seconds: 5);

  // إعدادات الـ retry
  static const int _maxRetries = 3;
  static const Duration _initialTimeout = Duration(seconds: 5);
  static const Duration _maxTimeout = Duration(seconds: 10);

  NetworkConnection({
    required this.internetConnectionChecker,
  });

  /// Factory method لإنشاء NetworkConnection مع الإعدادات الافتراضية المحسنة
  factory NetworkConnection.createDefault({
    Duration? timeout,
    List<AddressCheckOption>? customAddresses,
  }) {
    final defaultTimeout = timeout ?? const Duration(seconds: 5);

    final addresses = customAddresses ??
        [
          AddressCheckOption(
            uri: Uri.parse('https://www.gstatic.com/generate_204'),
            timeout: defaultTimeout,
          ),
          AddressCheckOption(
            uri: Uri.parse('https://clients3.google.com/generate_204'),
            timeout: defaultTimeout,
          ),
          AddressCheckOption(
            uri: Uri.parse('https://www.cloudflare.com/cdn-cgi/trace'),
            timeout: defaultTimeout,
          ),
          AddressCheckOption(
            uri: Uri.parse('https://www.msftconnecttest.com/connecttest.txt'),
            timeout: defaultTimeout,
          ),
        ];

    return NetworkConnection(
      internetConnectionChecker: InternetConnectionChecker.createInstance(
        addresses: addresses,
      ),
    );
  }

  /// تحسين isConnected مع retry و caching
  Future<bool> get isConnected async {
    // استخدام cache إذا كانت النتيجة حديثة
    if (_cachedResult != null &&
        _lastCheckTime != null &&
        DateTime.now().difference(_lastCheckTime!) < _cacheDuration) {
      return _cachedResult!;
    }

    // محاولة الاتصال مع retry mechanism
    final result = await _checkConnectionWithRetry();

    // حفظ النتيجة في cache
    _cachedResult = result;
    _lastCheckTime = DateTime.now();

    return result;
  }

  /// فحص الاتصال مع retry و exponential backoff
  Future<bool> _checkConnectionWithRetry() async {
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        // حساب timeout مع exponential backoff
        final timeout = Duration(
          milliseconds: (_initialTimeout.inMilliseconds * (1 << attempt)).clamp(
            _initialTimeout.inMilliseconds,
            _maxTimeout.inMilliseconds,
          ),
        );

        // محاولة الاتصال مع timeout
        final result = await internetConnectionChecker.hasConnection
            .timeout(timeout, onTimeout: () => false);

        if (result) {
          return true;
        }

        // إذا لم تكن المحاولة الأخيرة، انتظر قبل المحاولة التالية
        if (attempt < _maxRetries - 1) {
          await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
        }
      } catch (e) {
        // في حالة الخطأ، جرب مرة أخرى
        if (attempt < _maxRetries - 1) {
          await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
        }
      }
    }

    return false;
  }

  /// فحص جودة الاتصال (سرعة الاستجابة)
  Future<ConnectionQuality> getConnectionQuality() async {
    try {
      final stopwatch = Stopwatch()..start();
      final isConnected = await this.isConnected;
      stopwatch.stop();

      if (!isConnected) {
        return ConnectionQuality.offline;
      }

      final responseTime = stopwatch.elapsedMilliseconds;

      if (responseTime < 500) {
        return ConnectionQuality.excellent;
      } else if (responseTime < 1500) {
        return ConnectionQuality.good;
      } else if (responseTime < 3000) {
        return ConnectionQuality.fair;
      } else {
        return ConnectionQuality.poor;
      }
    } catch (e) {
      return ConnectionQuality.offline;
    }
  }

  /// Stream للاستماع لتغييرات الاتصال
  Stream<bool> get connectionStream {
    return internetConnectionChecker.onStatusChange.map(
      (status) => status == InternetConnectionStatus.connected,
    );
  }

  /// مسح الـ cache (مفيد عند تغيير حالة الاتصال)
  void clearCache() {
    _cachedResult = null;
    _lastCheckTime = null;
  }

  /// فحص الاتصال بدون cache (للاستخدام في حالات خاصة)
  Future<bool> checkConnectionWithoutCache() async {
    return await _checkConnectionWithRetry();
  }
}

/// مؤشر جودة الاتصال
enum ConnectionQuality {
  excellent, // < 500ms
  good, // 500-1500ms
  fair, // 1500-3000ms
  poor, // > 3000ms
  offline, // لا يوجد اتصال
}
