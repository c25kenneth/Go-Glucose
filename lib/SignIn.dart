import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:goglucose/center_widget.dart';
import 'package:goglucose/login_content.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Widget topWidget(double screenWidth) {
    return Transform.rotate(
      angle: -35 * math.pi / 180,
      child: Container(
        width: 1.2 * screenWidth,
        height: 1.2 * screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          gradient: const LinearGradient(
            begin: Alignment(-0.2, -0.8),
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(236, 159, 5, 1),
              Color.fromRGBO(255, 78, 0, 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomWidget(double screenWidth) {
    return Container(
      width: 1.5 * screenWidth,
      height: 1.5 * screenWidth,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(0.6, -1.1),
          end: Alignment(0.7, 0.8),
          colors: [
            Color.fromRGBO(236, 159, 5, 1),
            Color.fromRGBO(255, 78, 0, 1),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: -160,
          left: -30,
          child: topWidget(screenSize.width),
        ),
        Positioned(
          bottom: -180,
          left: -40,
          child: bottomWidget(screenSize.width),
        ),
        CenterWidget(size: screenSize),
        const LoginContent()
      ],
    ));
  }
}
