import 'package:breakly/lib/onboarding_page_data.dart';
import 'package:breakly/widgets/gradient_circle_border.dart';
import 'package:breakly/widgets/onboarding/onboarding_indicator.dart';
import 'package:breakly/widgets/onboarding/onboarding_notification.dart';
import 'package:breakly/widgets/onboarding/onboarding_timer.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Welcome to\nBreakly',
      description:
          'An app designed to remind you to take regular breaks from your computer work.',
      image: GradientCircleBorder(),
      buttonText: 'Next',
    ),
    OnboardingPageData(
      title: 'Flexible\nBreak Reminders',
      description:
          'Get notified when it’s time to take a break based on your custom preferences.',
      image: OnboardingNotification(),
      buttonText: 'Next',
    ),
    OnboardingPageData(
      title: 'Timed Breaks\nand Exercises',
      description:
          'Track your break and exercise durations with a convenient built-in timer.',
      image: OnboardingTimer(),
      buttonText: 'Done',
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/authentication');
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        page.image,
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            OnboardingIndicator(
              count: _pages.length,
              currentIndex: _currentPage,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 32,
                right: 32,
                left: 32,
                top: 16,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _onNext,
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                  ),
                  child: Text(
                    _pages[_currentPage].buttonText,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
