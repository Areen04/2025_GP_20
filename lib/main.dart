import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ Firebase Core
import 'firebase_options.dart'; // ✅ إعدادات Firebase من FlutterFire CLI
import 'splash_screen.dart'; // ✅ استيراد الصفحة الرئيسية مؤقتاً

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const RafiqApp());
}

class RafiqApp extends StatelessWidget {
  const RafiqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rafiq',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9D5C7D),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // ✅ مؤقتًا بدل SplashScreen
    );
  }
}
