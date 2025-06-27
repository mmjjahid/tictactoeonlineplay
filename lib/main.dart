import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tictactoeonlineplay/Configs/PageRoute.dart';
import 'package:tictactoeonlineplay/Configs/Theme.dart';
import 'package:get/get.dart';
import 'package:tictactoeonlineplay/Splash/SplashPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: FToastBuilder(),
      getPages: pages,
      title: 'Tic Tac Toe Multiplayer',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: SplashPage(),
    );
  }
}
