import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette - Orange, Black, White theme
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color darkOrange = Color(0xFFE55A2B);
  static const Color lightOrange = Color(0xFFFF8A65);
  static const Color accentOrange = Color(0xFFFFA726);

  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color darkBlack = Color(0xFF000000);
  static const Color lightBlack = Color(0xFF2E2E2E);
  static const Color greyBlack = Color(0xFF424242);

  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF9E9E9E);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryOrange, darkOrange],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryBlack, lightBlack],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A1A), Color(0xFF2E2E2E), Color(0xFF1A1A1A)],
    stops: [0.0, 0.5, 1.0],
  );

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'UberMove',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: primaryWhite,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: 'UberMove',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: primaryWhite,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: 'UberMove',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: primaryWhite,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'UberMove',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: primaryWhite,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'UberMove',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: primaryWhite,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'UberMove',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: darkGrey,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'UberMove',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: darkGrey,
  );

  // Box Shadows for 3D effects
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> floatingShadow = [
    BoxShadow(color: Color(0x26000000), blurRadius: 15, offset: Offset(0, 6)),
    BoxShadow(color: Color(0x1A000000), blurRadius: 30, offset: Offset(0, 12)),
  ];

  static const List<BoxShadow> pressedShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 5, offset: Offset(0, 2)),
  ];

  // Animation Durations
  static const Duration quickAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 800);
  static const Duration splashDuration = Duration(milliseconds: 3000);

  // Border Radius
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(12),
  );
  static const BorderRadius inputRadius = BorderRadius.all(Radius.circular(8));

  // Material Theme
  static ThemeData get materialTheme {
    return ThemeData(
      primarySwatch: Colors.orange,
      primaryColor: primaryOrange,
      scaffoldBackgroundColor: primaryBlack,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlack,
        foregroundColor: primaryWhite,
        elevation: 0,
        titleTextStyle: heading2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: primaryWhite,
          textStyle: bodyMedium,
          shape: RoundedRectangleBorder(borderRadius: buttonRadius),
          elevation: 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightBlack,
        border: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide.none,
        ),
        hintStyle: bodySmall.copyWith(color: darkGrey),
        labelStyle: bodyMedium.copyWith(color: primaryOrange),
      ),
      cardTheme: CardThemeData(
        color: lightBlack,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: cardRadius),
      ),
      textTheme: const TextTheme(
        displayLarge: heading1,
        displayMedium: heading2,
        displaySmall: heading3,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelSmall: caption,
      ),
      fontFamily: 'UberMove',
    );
  }
}
