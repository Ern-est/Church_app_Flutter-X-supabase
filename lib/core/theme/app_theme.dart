import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color neonPink = Color(0xFFFF6EC7);
  static const Color neonYellow = Color(0xFFFFFF33);
  static const Color whiteBackground = Colors.white;

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: whiteBackground,
    primaryColor: neonPink,
    colorScheme: ColorScheme.light(primary: neonPink, secondary: neonYellow),
    textTheme: GoogleFonts.pacificoTextTheme().apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: neonPink,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: neonPink,
      unselectedItemColor: Colors.grey,
      backgroundColor: whiteBackground,
      type: BottomNavigationBarType.fixed,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: neonPink,
    colorScheme: ColorScheme.dark(primary: neonPink, secondary: neonYellow),
    textTheme: GoogleFonts.pacificoTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: neonPink,
      foregroundColor: Colors.black,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: neonYellow,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
