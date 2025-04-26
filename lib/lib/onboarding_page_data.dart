import 'package:flutter/material.dart';

class OnboardingPageData {
  final String title;
  final String description;
  final Widget image;
  final String buttonText;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.image,
    required this.buttonText,
  });
}
