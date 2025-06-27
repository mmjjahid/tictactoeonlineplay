import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tictactoeonlineplay/Components/PrimaryButtonWithIcon.dart';
import 'package:tictactoeonlineplay/Configs/AssetsPath.dart';
import 'package:tictactoeonlineplay/Components/SocialIcons.dart';
import 'package:get/get.dart';
import 'package:tictactoeonlineplay/Controller/ProfileController.dart';
import 'package:tictactoeonlineplay/Pages/RoomPage/roomPage.dart';
import '../../Models/UserModel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.deepPurple.shade50,
              ],
            ),
          ),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text("User data not found"));
              }

              final user = UserModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100.withOpacity(0.4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: user.image != null
                              ? ClipOval(
                                  child: Image.memory(
                                    base64Decode(user.image!),
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  ),
                                )
                              : Icon(Icons.person,
                                  size: 48, color: Colors.grey),
                        ),
                        SizedBox(height: 12),
                        Text(
                          user.name ?? 'No Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.deepPurple,
                          ),
                        ),
                        Text(
                          user.email ?? 'No Email',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stat cards
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildStatCard(context, Icons.emoji_events, "Wins",
                                user.totalWins),
                            SizedBox(width: 10),
                            _buildStatCard(
                                context,
                                Icons.sentiment_very_dissatisfied,
                                "Losses",
                                user.totalLosses),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            _buildStatCard(context, Icons.handshake, "Draws",
                                user.totalDraws),
                            SizedBox(width: 10),
                            _buildStatCard(context, Icons.monetization_on,
                                "Coins", user.totalCoins),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatCard(context, Icons.grid_3x3, "Matches",
                                user.totalMatches),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Divider(thickness: 1, color: Colors.deepPurple.shade100),

                  ListTile(
                    leading: Icon(Icons.code, color: Colors.deepPurple),
                    title: Text('Developer Info',
                        style: TextStyle(color: Colors.black87)),
                    onTap: () => Get.toNamed('/developer-info'),
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: Colors.deepPurple),
                    title:
                        Text('About', style: TextStyle(color: Colors.black87)),
                    onTap: () => Get.toNamed('/about'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.deepPurple),
                    title: Text('Settings',
                        style: TextStyle(color: Colors.black87)),
                    onTap: () => Get.toNamed('/settings'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'TIC TAC TOE',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'With MultiPlayer',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              SvgPicture.asset(IconsPath.appLogo),
              Column(
                children: [
                  PrimaryButtonWithIcon(
                    buttonText: 'Single Player',
                    onTap: () {
                      Get.toNamed('/singleplayer');
                    },
                    image: IconsPath.singlemanIcon,
                  ),
                  SizedBox(height: 30),
                  PrimaryButtonWithIcon(
                    buttonText: 'Multi Player',
                    onTap: () {
                      Get.offAll(RoomPage());
                    },
                    image: IconsPath.multiPlayerIcon,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SocialIcons(
                    icon: 'assets/icons/info.svg',
                    url: 'https://www.google.com',
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  SocialIcons(
                    icon: 'assets/icons/github.svg',
                    url: 'https://github.com/engineersajid',
                  ),
                  SocialIcons(
                    icon: 'assets/icons/youtube.svg',
                    url: 'https://youtube.com/explorermotivation',
                  ),
                  SocialIcons(
                    icon: 'assets/icons/logout.svg',
                    onTap: () async {
                      await profileController.signOut();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Beautiful stat card widget
  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String label,
    String? value,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(2, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Theme.of(context).primaryColor),
            SizedBox(height: 8),
            Text(
              value ?? '0',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
