import 'package:concentric_transition/page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tictactoeonlineplay/Configs/AssetsPath.dart';
import 'package:tictactoeonlineplay/Pages/Authentication/AuthPage.dart';
import 'package:tictactoeonlineplay/Pages/HomePage/HomePage.dart';
import 'package:get/get.dart';
import 'package:tictactoeonlineplay/Pages/RoomPage/roomPage.dart';
import '../OnBoarding/OnBoarding.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var pages = [
      const OnBoarding(
        title: 'Welcome',
        subtitle: 'Most fun game now available on your smartphone device!',
        image: ImagePath.welcome1,
      ),
      const OnBoarding(
        title: 'Compete',
        subtitle: 'Play online with your friends and challenge your skills!',
        image: ImagePath.welcome2,
      ),
      const OnBoarding(
        title: 'Enjoy',
        subtitle: 'Have fun playing Tic Tac Toe anytime, anywhere!',
        image: ImagePath.welcome3,
      ),
    ];
    return Scaffold(
      body: ConcentricPageView(
        nextButtonBuilder: (context) {
          return const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 35,
          );
        },
        itemBuilder: (index) {
          return pages[index];
        },
        onFinish: () {
          Get.offAll(AuthPage());
        },
        itemCount: 3,
        colors: [Colors.red, Colors.green, Colors.deepPurple],
      ),
    );
  }
}
