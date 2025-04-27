import 'package:breakly/service/auth_api.dart';
import 'package:breakly/widgets/gradient_circle_border.dart';
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
    // try {
    await context.read<AuthAPI>().signInWithGoogle();
    Navigator.pushReplacementNamed(context, '/home');
    // } catch (e) {
    //   showAlert(title: 'Login failed', text: e.message.toString());
  }

  onAuthAnonymous() async {
    // try {
    await context.read<AuthAPI>().signInWithAnonymous();
    Navigator.pushReplacementNamed(context, '/home');
    // } catch (e) {
    //   showAlert(title: 'Login failed', text: e.message.toString());
    // }
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
            GradientCircleBorder(size: 180, borderWidth: 3),
            const SizedBox(height: 48),
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
