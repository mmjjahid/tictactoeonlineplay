import 'package:get/get.dart';
import 'package:tictactoeonlineplay/Pages/Authentication/AuthPage.dart';
import 'package:tictactoeonlineplay/Pages/GamePage/MultiPlayer.dart';
import 'package:tictactoeonlineplay/Pages/GamePage/SinglePlayer.dart';
import 'package:tictactoeonlineplay/Pages/HomePage/HomePage.dart';
import 'package:tictactoeonlineplay/Pages/LobbyPage/LobbyPage.dart';
import 'package:tictactoeonlineplay/Pages/RoomPage/roomPage.dart';
import 'package:tictactoeonlineplay/Pages/UpdateProfile/UpdateProfile.dart';
import 'package:tictactoeonlineplay/Pages/Welcome/WelcomePage.dart';
import 'package:tictactoeonlineplay/Splash/SplashPage.dart';

import '../Pages/Additional Pages/ settings_page.dart';
import '../Pages/Additional Pages/about_page.dart';
import '../Pages/Additional Pages/developer_info_page.dart';

var pages = [
  GetPage(
    name: '/room',
    page: () => RoomPage(),
  ),
  GetPage(
    name: '/auth',
    page: () => AuthPage(),
  ),
  GetPage(
    name: '/home',
    page: () => HomePage(),
  ),
  GetPage(
    name: '/splash',
    page: () => SplashPage(),
  ),
  // GetPage(
  //   name: '/gamePage',
  //   page: () => MultiPlayer(),
  // ),
  GetPage(
    name: '/singleplayer',
    page: () => SinglePlayer(),
  ),
  GetPage(
    name: '/updateProfile',
    page: () => UpdateProfile(),
  ),
  GetPage(
    name: '/welcome',
    page: () => WelcomePage(),
  ),
  GetPage(
    name: '/developer-info',
    page: () => DeveloperInfoPage(),
  ),
  GetPage(
    name: '/about',
    page: () => AboutPage(),
  ),
  GetPage(
    name: '/settings',
    page: () => SettingsPage(),
  ),
];
