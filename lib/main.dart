import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breakly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        // '/': (context) => const MyHomePage(title: 'Breakly',),
        // '/onboarding': (context) => const OnboardingScreen(),
        '/': (context) => const OnboardingScreen(),
        '/authentication': (context) => const AuthScreen(),
      },
    );
  }
}
