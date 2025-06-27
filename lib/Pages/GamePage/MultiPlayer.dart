// FILE: MultiPlayer.dart (Cleaned version using sound from controller only)
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:tictactoeonlineplay/Components/InGameUserCard.dart';
import 'package:tictactoeonlineplay/Controller/MultiPlayerController.dart';
import 'package:tictactoeonlineplay/Models/RoomModel.dart';
import 'package:tictactoeonlineplay/Pages/HomePage/HomePage.dart';
import 'package:tictactoeonlineplay/Configs/AssetsPath.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final currentUser = _auth.currentUser;
final currentPlayerId = currentUser?.uid;

class MultiPlayer extends StatefulWidget {
  final String roomId;
  const MultiPlayer({Key? key, required this.roomId}) : super(key: key);

  @override
  State<MultiPlayer> createState() => _MultiPlayerState();
}

class _MultiPlayerState extends State<MultiPlayer> {
  late MultiPlayerController multiPlayerController;

  @override
  void initState() {
    super.initState();
    multiPlayerController = Get.put(MultiPlayerController());
    if (currentUser?.uid != null) {
      multiPlayerController.listenMatchStatus(
        widget.roomId,
        currentUser!.uid,
      );
    }
  }

  @override
  void dispose() {
    multiPlayerController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StreamBuilder<RoomModel>(
                stream: multiPlayerController.getRoomDetails(widget.roomId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final roomData = snapshot.data!;
                    final playValue = roomData.gameValue;
                    return Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Get.to(() => const HomePage()),
                              child: SvgPicture.asset(
                                IconsPath.backIcon,
                                width: 24,
                                height: 24,
                                placeholderBuilder: (_) =>
                                    const Icon(Icons.arrow_back),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text('Play Game',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                        const SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                InGameUserCard(
                                  base64Image: roomData.player1?.image,
                                  userName:
                                      roomData.player1?.name ?? 'Player 1',
                                  icon: IconsPath.xIconSecondary,
                                ),
                                const SizedBox(height: 10),
                                _buildStatsBox(context, roomData.player1),
                              ],
                            ),
                            Column(
                              children: [
                                InGameUserCard(
                                  base64Image: roomData.player2?.image,
                                  userName:
                                      roomData.player2?.name ?? 'Player 2',
                                  icon: IconsPath.oIconSecondary,
                                ),
                                const SizedBox(height: 10),
                                _buildStatsBox(context, roomData.player2),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 35),
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
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 9,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                final value = playValue?[index] ?? '';
                                return InkWell(
                                  onTap: () {
                                    if (currentPlayerId != null &&
                                        playValue != null) {
                                      multiPlayerController.updateData(
                                        widget.roomId,
                                        playValue,
                                        index,
                                        roomData,
                                        currentPlayerId!,
                                      );
                                    } else {
                                      Get.snackbar(
                                          'Error', 'User not authenticated!',
                                          snackPosition: SnackPosition.TOP);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: value == 'X'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : value == 'O'
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
                                      child: value == 'X'
                                          ? SvgPicture.asset(IconsPath.xIcon,
                                              width: 45)
                                          : value == 'O'
                                              ? SvgPicture.asset(
                                                  IconsPath.oIcon)
                                              : const SizedBox(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: roomData.isXturn == true
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
                                  const SizedBox(width: 10),
                                  roomData.isXturn == true
                                      ? SvgPicture.asset(IconsPath.xIcon,
                                          width: 30)
                                      : SvgPicture.asset(IconsPath.oIcon,
                                          width: 30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: multiPlayerController.confettiController,
          shouldLoop: false,
          blastDirection: pi / 2,
          colors: const [
            Colors.red,
            Colors.pink,
            Colors.green,
            Colors.deepPurple,
            Colors.yellow,
            Colors.indigo,
          ],
          gravity: 0.01,
          emissionFrequency: 0.05,
        ),
      ],
    );
  }

  Widget _buildStatsBox(BuildContext context, dynamic player) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SvgPicture.asset(IconsPath.kingIcon),
          const SizedBox(height: 5),
          Text('Wins: ${player?.totalWins ?? 0}',
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
