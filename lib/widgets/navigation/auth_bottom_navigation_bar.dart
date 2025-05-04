import 'package:flutter/material.dart';

class AuthBottomNavigationBar extends StatefulWidget {
  const AuthBottomNavigationBar({super.key});

  @override
  State<AuthBottomNavigationBar> createState() =>
      _AuthBottomNavigationBarState();
}

class _AuthBottomNavigationBarState extends State<AuthBottomNavigationBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return BottomNavigationBar(
      backgroundColor: theme.cardTheme.color,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/add-reminder-option');
            break;
          case 2:
            Navigator.pushNamed(context, '/statistics');
            break;
          case 3:
            Navigator.pushNamed(context, '/settings');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_outlined),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
