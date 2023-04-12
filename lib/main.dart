// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/screens/auth/splash/splash_screen.dart';
import 'package:question_board_mobile/screens/home/home_screen.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soru Tahtası',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const SplashScreen(),
    );
  }
}
