import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goglucose/SignIn.dart';
import 'package:goglucose/backgroundConstants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: kBackgroundColor,
            textTheme:
                Theme.of(context).textTheme.apply(bodyColor: kPrimaryColor)),
        home: SignIn());
  }
}
