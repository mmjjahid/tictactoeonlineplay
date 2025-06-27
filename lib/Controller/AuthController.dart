import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tictactoeonlineplay/Configs/Massages.dart';
import 'package:tictactoeonlineplay/Pages/HomePage/HomePage.dart';
import 'package:tictactoeonlineplay/Pages/UpdateProfile/UpdateProfile.dart';

class AuthController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<void> login() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user!;
      successMassage('Login Success');

      final docRef = db.collection("users").doc(user.uid);
      final userDoc = await docRef.get();

      if (!userDoc.exists) {
        // ➕ New user → Create full profile with 10000 coins
        await docRef.set({
          "id": user.uid,
          "name": "", // Will be set in UpdateProfile
          "email": user.email ?? "",
          "image": user.photoURL ?? "",
          "totalWins": "0",
          "totalLosses": "0",
          "totalDraws": "0",
          "totalMatches": "0",
          "totalCoins": "10000", // ✅ Coins set here
          "role": "player",
          "yourTurn": false,
        });
      } else {
        // 🔁 Existing user → Ensure `totalCoins` is set to 10000 if missing
        final data = userDoc.data() ?? {};
        final currentCoins = data['totalCoins'];

        if (currentCoins == null || currentCoins == "") {
          await docRef.update({"totalCoins": "10000"}); // ✅ Ensure it's added
        }
      }

      // ⏩ Redirect based on name
      final updatedUserDoc = await docRef.get();
      final name = updatedUserDoc.data()?['name'] ?? "";

      if (name.isEmpty) {
        Get.offAll(() => UpdateProfile());
      } else {
        Get.offAll(() => HomePage());
      }
    } catch (e) {
      errorMassage('Login Failed');
      print("Login error: $e");
    }
  }
}
