import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ Firebase Core
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';
import 'firebase_options.dart'; // ✅ إعدادات Firebase من FlutterFire CLI
import 'splash_screen.dart'; // ✅ استيراد الصفحة الرئيسية مؤقتاً
import 'utils/locale_controller.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(LocaleScope(
    controller: LocaleController(),
    child: const RafiqApp(),
  ));
}

class RafiqApp extends StatelessWidget {
  const RafiqApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = LocaleScope.of(context);

    return AnimatedBuilder(
      animation: localeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Rafiq',
          debugShowCheckedModeBanner: false,
          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            fontFamily: 'Inter',
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF9D5C7D),
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
          // ✅ مؤقتًا بدل SplashScreen
        );
      },
    );
  }
}
