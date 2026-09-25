import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/animated_signin_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign In Animation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AnimatedSignInScreen(),
    );
  }
}
