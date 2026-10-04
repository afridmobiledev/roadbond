// Dart (Flutter)
import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/onboarding_welcome_page.dart';

void main() {
  runApp(const RoadBondApp());
}

class RoadBondApp extends StatelessWidget {
  const RoadBondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Road Bond',
      debugShowCheckedModeBanner: false,
      home: const OnboardingWelcomePage(),
    );
  }
}