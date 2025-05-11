import 'package:breakly/service/auth_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'constants/constants.dart';
import 'firebase_options.dart';
import 'lib/router.dart';
import 'theme/theme.dart';

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
      options.debug =false;
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authAPI = Provider.of<AuthAPI>(context, listen: false);
    return MaterialApp.router(
      title: 'Breakly',
      routerConfig: createRouter(authAPI),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}

// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final AuthStatus status = context.watch<AuthAPI>().status;
//
//     if (status == AuthStatus.authenticated ||
//         status == AuthStatus.unauthenticated) {
//       FlutterNativeSplash.remove();
//     }
//
//     if (status == AuthStatus.authenticated) {
//       return const HomeScreen();
//     } else if (status == AuthStatus.unauthenticated) {
//       return const OnboardingScreen();
//     } else {
//       return const Scaffold(
//         body: Center(child: Text('Unknown authentication state')),
//       );
//     }
//   }
// }
