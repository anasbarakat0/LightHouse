import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';
import 'package:lighthouse/features/main_window/presentation/view/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await setUp();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: "assets/translations",
      fallbackLocale: const Locale('ar'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: "LightHouse".tr(),
      theme: ThemeData(
        fontFamily: "Proxima Nova",
        colorScheme: ColorScheme.fromSwatch().copyWith(
          brightness: Brightness.dark,
          primary: orange,
          secondary: orange,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: orange,
          ),
        ),
        textTheme:  TextTheme(
          titleLarge: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.w800,
            fontFamily: context.locale.countryCode == 'en'? "Proxima Nova":"NotoSansArabic",
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
            fontFamily:  context.locale.countryCode == 'en'? "Proxima Nova":"NotoSansArabic",
            color: navy,
          ),
          titleSmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            fontFamily:  context.locale.countryCode == 'en'? "Proxima Nova":"NotoSansArabic",
            color: navy,
          ),
          bodyLarge: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w400,
            fontFamily: context.locale.countryCode == 'en'? "Raleway" : "NotoKufiArabic",
            color: navy,
          ),
          bodyMedium: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            fontFamily: context.locale.countryCode == 'en'? "Raleway" : "NotoKufiArabic",
            color: navy,
          ),
          bodySmall: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            fontFamily: context.locale.countryCode == 'en'? "Raleway" : "NotoKufiArabic",
            color: navy,
          ),
          labelLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            fontFamily:  context.locale.countryCode == 'en'? "Proxima Nova":"NotoSansArabic",
            color: navy,
          ),
          labelMedium: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily:  context.locale.countryCode == 'en'? "Proxima Nova":"NotoSansArabic",
            color: navy,
          ),
          labelSmall: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            fontFamily:  context.locale.countryCode == 'en'? "Proxima Nova":"NotoSansArabic",
            color: navy,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: orange,
            foregroundColor: darkNavy,
          ),
        ),
        scaffoldBackgroundColor: darkNavy,
        useMaterial3: true,
      ),
      home: memory.get<SharedPreferences>().getBool("auth") ?? false
          ? const MainScreen()
          : const LoginWindows(),
    );
  }
}
