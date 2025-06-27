import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tictactoeonlineplay/Components/InGameUserCard.dart';
import 'package:tictactoeonlineplay/Pages/LobbyPage/LobbyPage.dart';
import '../../Configs/AssetsPath.dart';
import '../../Controller/SinglePlayerController.dart';
import '../HomePage/HomePage.dart';
import 'package:get/get.dart';

class SinglePlayer extends StatelessWidget {
  const SinglePlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    SinglePlayerController singlePlayerController =
        Get.put(SinglePlayerController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    // Ensure the asset path is valid and points to an existing SVG file.
                    InkWell(
                      onTap: () {
                        Get.to(() => const HomePage());
                      },
                      child: SvgPicture.asset(
                        IconsPath.backIcon,
                        width: 24,
                        height: 24,
                        // Fallback if asset is missing.
                        placeholderBuilder: (context) =>
                            const Icon(Icons.arrow_back),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Play Game',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 45,
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Player:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SvgPicture.asset(IconsPath.xIcon),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                              SvgPicture.asset(
                                IconsPath.kingIcon,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Obx(
                                () => Text(
                                  'Won : ${singlePlayerController.xScore}',
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
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 45,
                            vertical: 15,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Player:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SvgPicture.asset(IconsPath.oIcon),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                              SvgPicture.asset(
                                IconsPath.kingIcon,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Obx(
                                () => Text(
                                  'Won : ${singlePlayerController.oScore}',
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
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: [10, 10],
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
                        itemCount: singlePlayerController.playValue.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              singlePlayerController.onClick(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  color: singlePlayerController
                                              .playValue[index] ==
                                          'X'
                                      ? Theme.of(context).colorScheme.primary
                                      : singlePlayerController
                                                  .playValue[index] ==
                                              'O'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : singlePlayerController
                                                      .playValue[index] ==
                                                  ''
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                  borderRadius: index == 0
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                        )
                                      : index == 2
                                          ? const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                            )
                                          : index == 6
                                              ? const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                )
                                              : index == 8
                                                  ? const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    )
                                                  : const BorderRadius.only()),
                              child: Center(
                                  child:
                                      singlePlayerController.playValue[index] ==
                                              'X'
                                          ? SvgPicture.asset(
                                              IconsPath.xIcon,
                                              width: 45,
                                            )
                                          : singlePlayerController
                                                      .playValue[index] ==
                                                  'O'
                                              ? SvgPicture.asset(
                                                  IconsPath.oIcon,
                                                )
                                              : singlePlayerController
                                                          .playValue[index] ==
                                                      ''
                                                  ? SizedBox()
                                                  : SizedBox()),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => AnimatedContainer(
                          duration: Duration(microseconds: 500),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: singlePlayerController.isXtime.value
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'TURN: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              singlePlayerController.isXtime.value
                                  ? SvgPicture.asset(
                                      IconsPath.xIcon,
                                      width: 30,
                                    )
                                  : SvgPicture.asset(
                                      IconsPath.oIcon,
                                      width: 30,
                                    ),
                            ],
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
