import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jycziuuqekiuyyswgkmb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp5Y3ppdXVxZWtpdXl5c3dna21iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjM5NjEsImV4cCI6MjA2Mjc5OTk2MX0.WJrL3FXbIjRr_k2ttQwNdpxu1i6RVYYSkWFe8AD-WZg',
  );

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
      home: RootNavigator(),
    );
  }
}

class RootNavigator extends StatefulWidget {
  @override
  State<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<RootNavigator> {
  bool _showOnboarding = true;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initializeFlow();
  }

  Future<void> _initializeFlow() async {
    final prefs = await SharedPreferences.getInstance();

    final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

    if (!seenOnboarding) {
      setState(() {
        _showOnboarding = true;
      });
    } else {
      _showOnboarding = false;
    }

    // Splash screen should always show
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _showSplash = false;
    });
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(onFinished: _completeOnboarding);
    } else if (_showSplash) {
      return SplashScreen();
    } else {
      return AuthWrapper(); // Now goes to auth
    }
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      return Text(
        'Welcome, ${user.email}!',
      ); // 🔁 Replace with HomeScreen later
    } else {
      return AuthScreen(); // Login/signup screen
    }
  }
}
