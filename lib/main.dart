import 'package:flutter/material.dart';
import 'package:timer/pages/home.dart';
import 'package:timer/pages/timer.dart';
import 'package:timer/pages/preptime.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Preptime(
        // prepSeconds: 10,
        // workSeconds: 30,
        // rounds: 1,
      ),
    );
  }
}