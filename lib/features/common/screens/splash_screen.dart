import 'dart:math';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({this.from, Key? key}) : super(key: key);
  final String? from;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Forget about this AnimationController first
    // We will get back to it in Chapter 13
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(milliseconds: 700),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: FadeTransition(
        opacity: _controller,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: max(MediaQuery.of(context).size.width * 0.8, 250)),
          child: Image.asset(
            // Use an asset image as splash screen
            'assets/images/tecky_splash.png',
            fit: BoxFit.contain,
          ),
        ),
      )));
}
