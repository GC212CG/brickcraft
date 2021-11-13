import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'home_view.dart';

void main() {
  // Remove # symbol from the last of URL
  setPathUrlStrategy();
  // Run Flutter App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Present HomeView.dart
      home: HomeView(),
      routes: {},
    );
  }
}
