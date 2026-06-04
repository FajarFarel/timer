import 'dart:async';
import 'login.dart';
import 'package:flutter/material.dart';
import '../uttils/colors.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  void _startDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      _goToLogin();
    });
  }

  void _goToLogin() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final logoSize = (screenWidth * 0.4).clamp(150.0, 300.0);

          return Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.background,
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(
                  "assets/logo.jpg",
                  width: logoSize,
                  height: logoSize,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
