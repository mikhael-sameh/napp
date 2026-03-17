import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'home_screen.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
 get splash => null;
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('asset/intro.json'),
      nextScreen: const HomeScreen(),
      centered: true,
      splashIconSize: 300,
      duration: 3000,
      backgroundColor: Colors.white,
    );
  }
}
