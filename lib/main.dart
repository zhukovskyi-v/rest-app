import 'package:breakly/screens/add_reminder_option_screen.dart';
import 'package:breakly/screens/add_reminder_screen.dart';
import 'package:breakly/screens/home_screen.dart';
import 'package:breakly/service/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'constants/constants.dart';
import 'screens/auth_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/theme.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  tz.initializeTimeZones();

  // 2. Налаштування для Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher'); // Стандартна іконка

  // 3. Налаштування для iOS
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  // 4. Об'єднуємо
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // 5. Ініціалізуємо плагін
  await Future.wait([
    flutterLocalNotificationsPlugin.initialize(initializationSettings),
    Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_TOKEN),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://98944b751c4872c6e48233adbe6a6206@o4509266066866176.ingest.de.sentry.io/4509266067980368';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(SentryWidget(child: 
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthAPI())],
      child: const MyApp(),
    ),
  )),
  );
  // TODO: Remove this line after sending the first sample event to sentry.
  await Sentry.captureException(StateError('This is a sample exception.'));
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
      home: const AuthGate(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/authentication': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-reminder-option': (context) => const AddReminderOptionScreen(),
        '/add-reminder': (context) => const AddReminderScreen(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthStatus status = context.watch<AuthAPI>().status;

    if (status == AuthStatus.authenticated ||
        status == AuthStatus.unauthenticated) {
      FlutterNativeSplash.remove();
    }

    if (status == AuthStatus.authenticated) {
      return const HomeScreen();
    } else if (status == AuthStatus.unauthenticated) {
      return const OnboardingScreen();
    } else {
      return const Scaffold(
        body: Center(child: Text('Unknown authentication state')),
      );
    }
  }
}
