import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'destinations.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
    body: navigationShell,
    bottomNavigationBar: NavigationBar(
      backgroundColor: theme.cardTheme.color,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: navigationShell.goBranch,
      indicatorColor: colorScheme.primary,
      surfaceTintColor: textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
      destinations:
          destinations
              .map(
                (destination) => NavigationDestination(
                  icon: Icon(destination.icon),
                  label: destination.label,
                  selectedIcon: Icon(destination.icon, color: Colors.white),
                ),
              )
              .toList(),
    ),
  );
  }
}
