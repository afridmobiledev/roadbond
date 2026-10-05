// Dart (Flutter)
import 'package:flutter/material.dart';

import 'features/splash/splash_page.dart';

void main() {
  runApp(const RoadBondApp());
}

class RoadBondApp extends StatelessWidget {
  const RoadBondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Road Bond',
      home: SplashPage(),
    );
  }
}