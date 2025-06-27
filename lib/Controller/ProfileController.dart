import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // ✅ Required for GlobalKey
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../Configs/Massages.dart';
import '../Models/UserModel.dart';
import '../Pages/HomePage/HomePage.dart';
import '../Pages/UpdateProfile/UpdateProfile.dart';

class ProfileController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxString base64Image = "".obs;

  /// 🔑 Add this for drawer control
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// Handle Navigation After Login
  Future<void> handleLoginNavigation() async {
    final user = auth.currentUser;

    if (user != null) {
      final doc = await db.collection("users").doc(user.uid).get();
      if (doc.exists &&
          doc.data()?['name'] != null &&
          doc.data()?['name'] != "") {
        Get.offAll(() => HomePage());
      } else {
        Get.offAll(() => UpdateProfile());
      }
    } else {
      errorMassage("User not signed in.");
    }
  }

  /// Pick Image from Camera/Gallery
  Future<String> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      File file = File(image.path);
      List<int> imageBytes = await file.readAsBytes();
      base64Image.value = base64Encode(imageBytes);
      return image.path;
    } else {
      return "";
    }
  }

  /// Update Profile with name + base64 image
  Future<void> updateProfile(String name) async {
    isLoading.value = true;
    try {
      if (name != "") {
        var newUser = UserModel(
          id: auth.currentUser!.uid,
          name: name,
          email: auth.currentUser!.email,
          image: base64Image.value,
          totalWins: "0",
        );
        await db
            .collection("users")
            .doc(auth.currentUser!.uid)
            .set(newUser.toJson());
        successMassage('Profile Updated');
        Get.offAll(() => HomePage());
      } else {
        errorMassage('Please Enter Your Name');
      }
    } catch (e) {
      errorMassage('Profile Update Failed');
      print(e);
    }
    isLoading.value = false;
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      await auth.signOut();
      Get.offAllNamed('/auth');
    } catch (e) {
      print("Logout error: $e");
      Get.snackbar("Logout Failed", "Something went wrong while logging out.");
    }
  }
}
