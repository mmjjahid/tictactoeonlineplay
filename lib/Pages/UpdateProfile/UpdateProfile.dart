import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:tictactoeonlineplay/Components/PrimaryButtonWithIcon.dart';
import 'package:tictactoeonlineplay/Configs/AssetsPath.dart';
import 'package:tictactoeonlineplay/Controller/ProfileController.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());
    TextEditingController nameController = TextEditingController();
    RxString imagePath = "".obs;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(
                        () => profileController.base64Image.value == ""
                            ? Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Icon(Icons.add_a_photo_outlined,
                                    size: 50, color: Colors.grey),
                              )
                            : Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.memory(
                                    base64Decode(
                                        profileController.base64Image.value),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(width: 30),
                      Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              imagePath.value = await profileController
                                  .pickImage(ImageSource.camera);
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: SvgPicture.asset(IconsPath.cameraIcon,
                                  width: 30),
                            ),
                          ),
                          SizedBox(height: 30),
                          InkWell(
                            onTap: () async {
                              imagePath.value = await profileController
                                  .pickImage(ImageSource.gallery);
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: SvgPicture.asset(IconsPath.imageIcon,
                                  width: 30),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.primaryContainer,
                      filled: true,
                      hintText: 'Enter Your Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'You can change these details later from profile page. don’t worry',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              Obx(
                () => profileController.isLoading.value
                    ? CircularProgressIndicator()
                    : PrimaryButtonWithIcon(
                        buttonText: 'Save',
                        onTap: () {
                          profileController.updateProfile(nameController.text);
                        },
                        image: IconsPath.saveIcon,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
