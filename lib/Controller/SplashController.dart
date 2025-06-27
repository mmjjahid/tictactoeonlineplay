import 'package:get/get.dart';
import 'package:tictactoeonlineplay/Pages/HomePage/HomePage.dart';
import 'package:tictactoeonlineplay/Pages/Welcome/WelcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashController extends GetxController {
  final auth = FirebaseAuth.instance;
  @override
  void onInit() {
    splashHandle();
    super.onInit();
  }

  Future<void> splashHandle() async {
    await Future.delayed(const Duration(seconds: 3));
    if (auth.currentUser == null) {
      Get.offAll(WelcomePage());
    } else {
      Get.offAll(HomePage());
    }
  }
}
