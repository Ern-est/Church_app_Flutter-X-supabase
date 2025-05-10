import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'widgets/bottom_nav.dart';

void main() {
  runApp(BethsaidaApp());
}

class BethsaidaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bethsaida',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: BottomNavWrapper(),
    );
  }
}
