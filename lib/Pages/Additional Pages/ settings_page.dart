import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/ProfileController.dart';
import '../UpdateProfile/UpdateProfile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // TODO: Load saved theme mode from preferences if any
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
      // TODO: Save theme preference & notify app-wide theme change if applicable
    });
  }

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            subtitle: Text('Toggle light/dark theme'),
            value: _isDarkMode,
            onChanged: _toggleDarkMode,
            secondary: Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Edit Profile'),
            subtitle: Text('Change your display name or profile picture'),
            onTap: () {
              Get.to(UpdateProfile());
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await profileController.signOut();
            },
          ),
        ],
      ),
    );
  }
}
