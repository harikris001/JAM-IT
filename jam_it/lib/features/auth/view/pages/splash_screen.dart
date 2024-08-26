import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:jam_it/core/theme/app_pallete.dart';
import 'package:jam_it/features/auth/view/pages/signup_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 250,
      child: FlutterSplashScreen.gif(
        backgroundColor: Pallete.transparentColor,
        gifPath: 'assets/video/splash.gif',
        gifWidth: 235,
        gifHeight: 235,
        duration: const Duration(seconds: 6, milliseconds: 500),
        nextScreen: const SignupPage(),
      ),
    );
  }
}
