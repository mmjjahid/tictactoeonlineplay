import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tictactoeonlineplay/Components/PrimaryButtonWithIcon.dart';
import 'package:tictactoeonlineplay/Configs/AssetsPath.dart';
import 'package:tictactoeonlineplay/Controller/AuthController.dart';
import 'package:tictactoeonlineplay/Pages/GamePage/GuestPlayer.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isLoading = false.obs;
    AuthController authController = Get.put(AuthController());

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 70),

              // App Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(IconsPath.appLogo),
                ],
              ),

              const SizedBox(height: 30),

              // Welcome Texts
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Please sign in to continue',
                style: Theme.of(context).textTheme.bodySmall,
              ),

              const SizedBox(height: 150),

              // 🟢 Play as Guest Button (before Google login)
              PrimaryButtonWithIcon(
                buttonText: 'Play as Guest',
                onTap: () {
                  Get.to(() => GuestPlayer());
                },
                imageWidget: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 20),

              // 🔴 Login With Google Button
              PrimaryButtonWithIcon(
                buttonText: 'Login With Google',
                onTap: () {
                  authController.login();
                },
                image: IconsPath.googleIcon,
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
