import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:breakly/appwrite/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  showAlert({required String title, required String text}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          title: Text(title),
          content: Text(text),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],

        );
      },
    );
  }

  onAuth() async {
    try {
      context.read<AuthAPI>().signInWithProvider(
        provider: OAuthProvider.google,
      );
    } on AppwriteException catch (e) {
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

  onAuthAnonymous() async {
    try {
      await context.read<AuthAPI>().signInWithAnonymous();
      Navigator.pushReplacementNamed(context, '/home');
    } on AppwriteException catch (e) {
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gradient Circle
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 8, color: Colors.transparent),
                gradient: SweepGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.8),
                    colorScheme.secondary,
                    colorScheme.primary.withValues(alpha: 0.8),
                  ],
                  startAngle: 0.0,
                  endAngle: 3.14 * 2,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Sign In Text
            Text(
              'Sign In',
              style: textTheme.displayLarge?.copyWith(letterSpacing: 1.2),
            ),
            const SizedBox(height: 48),
            // Google Sign In Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: colorScheme.surface.withValues(alpha: 0.3),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: onAuth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/google-icon-logo.svg',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Continue with Google',
                        style: textTheme.titleMedium?.copyWith(
                          color: textTheme.displayLarge?.color,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Sign Up Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ", style: textTheme.bodyMedium),
                GestureDetector(
                  onTap: onAuthAnonymous,
                  child: Text(
                    'Sign in as Guest',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.surface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            // Sign Up Link
          ],
        ),
      ),
    );
  }
}
