import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:police_app/firebase_options.dart' as DefaultFirebaseOptions;
import 'firebase_options.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Police App',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // police theme 🔵
        ),
        useMaterial3: true,
      ),

      home: const LoginPage(), // ✅ Start from login page
    );
  }
}
