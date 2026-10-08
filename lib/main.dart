import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/splash/splash_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Finish Firebase setup before screens access authentication or data.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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