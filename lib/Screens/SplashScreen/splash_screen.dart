import 'package:flutter/material.dart';
import 'package:studentapp/Screens/Introductionscreen/introduction_screen.dart';
import 'package:studentapp/Screens/WelcomeScreen/WelcomeScreen.dart';
import '../loginscreen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenH,
        width: screenW,
        color: const Color(0xFFEDE7F6),
        child: Center(
          child: Image.asset(
            'assets/images/splash.png',
            width: screenW * 0.3,
            height: screenW * 0.3,
          ),
        ),
      ),
    );
  }
}
