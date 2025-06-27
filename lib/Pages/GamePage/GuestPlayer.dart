import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tictactoeonlineplay/Components/InGameUserCard.dart';
import 'package:tictactoeonlineplay/Pages/LobbyPage/LobbyPage.dart';
import '../../Configs/AssetsPath.dart';
import '../../Controller/GuestPlayerController.dart'; // updated
import '../Authentication/AuthPage.dart';
import '../HomePage/HomePage.dart';
import 'package:get/get.dart';

class GuestPlayer extends StatelessWidget {
  const GuestPlayer({super.key}); // updated

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    GuestPlayerController guestPlayerController =
        Get.put(GuestPlayerController()); // updated

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const AuthPage());
                      },
                      child: SvgPicture.asset(
                        IconsPath.backIcon,
                        width: 24,
                        height: 24,
                        placeholderBuilder: (context) =>
                            const Icon(Icons.arrow_back),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Guest Mode',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45, vertical: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Player:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15),
                              SvgPicture.asset(IconsPath.xIcon),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(IconsPath.kingIcon),
                              const SizedBox(width: 10),
                              Obx(
                                () => Text(
                                  'Won : ${guestPlayerController.xScore}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45, vertical: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Player:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15),
                              SvgPicture.asset(IconsPath.oIcon),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(IconsPath.kingIcon),
                              const SizedBox(width: 10),
                              Obx(
                                () => Text(
                                  'Won : ${guestPlayerController.oScore}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: const [10, 10],
                  radius: const Radius.circular(20),
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 2,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    width: width,
                    height: width - 54,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Obx(
                      () => GridView.builder(
                        itemCount: guestPlayerController.playValue.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              guestPlayerController.onClick(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: guestPlayerController.playValue[index] ==
                                        'X'
                                    ? Theme.of(context).colorScheme.primary
                                    : guestPlayerController.playValue[index] ==
                                            'O'
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                borderRadius: BorderRadius.only(
                                  topLeft: index == 0
                                      ? const Radius.circular(20)
                                      : Radius.zero,
                                  topRight: index == 2
                                      ? const Radius.circular(20)
                                      : Radius.zero,
                                  bottomLeft: index == 6
                                      ? const Radius.circular(20)
                                      : Radius.zero,
                                  bottomRight: index == 8
                                      ? const Radius.circular(20)
                                      : Radius.zero,
                                ),
                              ),
                              child: Center(
                                child: guestPlayerController.playValue[index] ==
                                        'X'
                                    ? SvgPicture.asset(IconsPath.xIcon,
                                        width: 45)
                                    : guestPlayerController.playValue[index] ==
                                            'O'
                                        ? SvgPicture.asset(IconsPath.oIcon)
                                        : const SizedBox(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => AnimatedContainer(
                          duration: const Duration(microseconds: 500),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: guestPlayerController.isXtime.value
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'TURN: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              const SizedBox(width: 10),
                              guestPlayerController.isXtime.value
                                  ? SvgPicture.asset(IconsPath.xIcon, width: 30)
                                  : SvgPicture.asset(IconsPath.oIcon,
                                      width: 30),
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
