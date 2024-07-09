import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login1/Authentication/Email/login_screen.dart';
import 'package:login1/screens/postScreen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final _auth = FirebaseAuth.instance;
  // final user = _auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
            Lottie.asset(
              'assets/animation/anm.json',
            ),
            const Text(
              "Welcome to login..",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
        nextScreen: (_auth.currentUser != null)
            ? const Postscreen()
            : const LoginScreen(),
        duration: 2500,
        splashIconSize: 400);
  }
}
