import 'package:flutter/material.dart';

import 'features/rides/presentation/pages/discover_rides_page.dart';

void main() {
  runApp(const RoadBondApp());
}

class RoadBondApp extends StatelessWidget {
  const RoadBondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoadBond',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB3261E),
        ),
        useMaterial3: true,
      ),
      home: const DiscoverRidesPage(),
    );
  }
}