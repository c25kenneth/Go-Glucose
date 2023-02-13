import 'package:flutter/material.dart';
import 'package:goglucose/change_screen_animation.dart';
import 'package:goglucose/helper_functions.dart';

import 'login_content.dart';

class TopText extends StatefulWidget {
  const TopText({Key? key}) : super(key: key);

  @override
  State<TopText> createState() => _TopTextState();
}

class _TopTextState extends State<TopText> {
  @override
  void initState() {
    ChangeScreenAnimation.topTextAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HelperFunctions.wrapWithAnimatedBuilder(
      animation: ChangeScreenAnimation.topTextAnimation,
      child: Text(
        ChangeScreenAnimation.currentScreen == Screens.createAccount
            ? 'Get Started with \n Go Glucose'
            : 'Welcome Back \n to Go Glucose',
        style: const TextStyle(
          color: Color.fromARGB(255, 82, 78, 78),
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
