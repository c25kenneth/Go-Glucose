import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goglucose/HomePageScreens/HomeScreen.dart';
import 'package:goglucose/FirebaseFlutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:goglucose/helper_functions.dart';

import 'backgroundConstants.dart';
import 'change_screen_animation.dart';
import 'bottomText.dart';
import 'top_text.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;

  String nameSignUp = '';
  String emailSignIn = '';
  String emailSignUp = '';
  String passwordSignIn = '';
  String passwordSignUp = '';

  Widget inputField(
      String hint, IconData iconData, String screen, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            obscureText: (isPassword == true) ? true : false,
            onChanged: (val) {
              if (iconData == Ionicons.person_outline && screen == "Sign Up") {
                setState(() {
                  nameSignUp = val;
                });
              } else if (iconData == Ionicons.mail_outline &&
                  screen == "Sign Up") {
                setState(() {
                  emailSignUp = val;
                });
              } else if (iconData == Ionicons.mail_outline &&
                  screen == "Sign In") {
                setState(() {
                  emailSignIn = val;
                });
              } else if (iconData == Ionicons.lock_closed_outline &&
                  screen == "Sign Up") {
                setState(() {
                  passwordSignUp = val;
                });
              } else if (iconData == Ionicons.lock_closed_outline &&
                  screen == "Sign In") {
                setState(() {
                  passwordSignIn = val;
                });
              }
            },
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () async {
          if (title == "Log In" && emailSignIn != "" && passwordSignIn != "") {
            User? currUser = await signIn(emailSignIn, passwordSignIn);
            if (currUser != null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(user: currUser)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Incorrect email or password! Please try again. "),
              ));
            }
          } else if (title == "Sign Up" &&
              emailSignUp != "" &&
              nameSignUp != "" &&
              passwordSignUp != "") {
            User? currUser =
                await registerUser(nameSignUp, emailSignUp, passwordSignUp);
            if (currUser != null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(user: currUser)));
              print("user Registered successfully!");
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Error with Registering User Please try again later. "),
              ));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("One or more fields are empty! "),
            ));
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          primary: kSecondaryColor,
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    createAccountContent = [
      inputField('Name', Ionicons.person_outline, "Sign Up", false),
      inputField('Email', Ionicons.mail_outline, "Sign Up", false),
      inputField('Password', Ionicons.lock_closed_outline, "Sign Up", true),
      loginButton('Sign Up'),
      orDivider(),
    ];

    loginContent = [
      inputField('Email', Ionicons.mail_outline, "Sign In", false),
      inputField('Password', Ionicons.lock_closed_outline, "Sign In", true),
      loginButton('Log In'),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 136,
          left: 24,
          child: TopText(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createAccountContent,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContent,
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: BottomText(),
          ),
        ),
      ],
    );
  }
}
