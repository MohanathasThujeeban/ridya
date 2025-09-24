import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_theme.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.primaryBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const RidyaApp());
}

class RidyaApp extends StatelessWidget {
  const RidyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ridya - 3D Ride Experience',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.materialTheme,
      home: const SplashScreen(),
    );
  }
}
