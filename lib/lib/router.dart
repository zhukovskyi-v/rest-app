import 'package:breakly/lib/routes.dart';
import 'package:breakly/screens/add_reminder_option_screen.dart';
import 'package:breakly/screens/add_reminder_screen.dart';
import 'package:breakly/screens/home_screen.dart';
import 'package:breakly/screens/auth_screen.dart';
import 'package:breakly/screens/onboarding_screen.dart';
import 'package:breakly/screens/settings_screen.dart';
import 'package:breakly/service/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'layout.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createRouter(AuthAPI authAPI) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.homePage,
    refreshListenable: authAPI,
    redirect: (context, state) {
      final auth = Provider.of<AuthAPI>(context, listen: false);
      final isLoggedIn = auth.status == AuthStatus.authenticated;
      final currentPath = state.uri.toString();

      final isOnOnboarding = currentPath == Routes.onboarding;
      final isOnLogin = currentPath == Routes.login;

      FlutterNativeSplash.remove();

      if (!isLoggedIn && !isOnOnboarding && !isOnLogin) {
        return Routes.onboarding;
      }
      if (isLoggedIn && (isOnOnboarding || isOnLogin)) {
        return Routes.homePage;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.login,
        name: Routes.login,
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                LayoutScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.homePage,
                builder: (context, state) => HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.addReminderOption,
                builder: (context, state) => AddReminderOptionScreen(),
                routes: [
                  GoRoute(
                    path: Routes.addReminder,
                    builder: (context, state) => AddReminderScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
