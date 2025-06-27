import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tictactoeonlineplay/Configs/Massages.dart';
import 'package:tictactoeonlineplay/Controller/LobbyController.dart';
import 'package:tictactoeonlineplay/Controller/RoomController.dart';
import 'package:tictactoeonlineplay/Pages/GamePage/MultiPlayer.dart';
import 'package:tictactoeonlineplay/Pages/RoomPage/roomPage.dart';
import 'package:tictactoeonlineplay/Widgets/RoomInfo.dart';
import '../../Components/PrimaryButton.dart';
import '../../Components/UserCard.dart';
import '../../Configs/AssetsPath.dart';
import '../../Models/RoomModel.dart';
import '../../Widgets/PricingArea.dart';
import '../HomePage/HomePage.dart';

class LobbyPage extends StatelessWidget {
  final String roomId;
  const LobbyPage({super.key, required this.roomId});

  String parseCoins(dynamic coins) {
    if (coins == null) return '0';
    if (coins is int) return coins.toString();
    if (coins is String) return int.tryParse(coins)?.toString() ?? '0';
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    RoomController roomController = Get.put(RoomController());
    LobbyController lobbyController = Get.put(LobbyController());

    final RxBool hasNavigated = false.obs;

    const int minCoinsRequired = 10;

    void showNotEnoughCoinsDialog() {
      Get.snackbar(
        "Insufficient Coins",
        "You need at least $minCoinsRequired coins to play the match.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      );
    }

    bool hasEnoughCoins(RoomModel roomData) {
      int userCoins = 0;

      if (roomController.user.value.totalCoins != null) {
        if (roomController.user.value.totalCoins is int) {
          userCoins = roomController.user.value.totalCoins as int;
        } else {
          userCoins =
              int.tryParse(roomController.user.value.totalCoins.toString()) ??
                  0;
        }
      }

      int entryFee = int.tryParse(roomData.entryFee ?? '0') ?? 0;

      return userCoins >= minCoinsRequired && userCoins >= entryFee;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.offAll(RoomPage());
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
                      'Play With Private Room',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RoomInfo(roomCode: roomId),
                const SizedBox(height: 40),
                StreamBuilder<RoomModel>(
                  stream: lobbyController.getRoomDetails(roomId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.hasData) {
                      final roomData = snapshot.data!;

                      if (roomData.player1Status == 'ready' &&
                          roomData.player2Status == 'ready' &&
                          !hasNavigated.value) {
                        hasNavigated.value = true;

                        lobbyController.startGame().then((_) {
                          Get.to(MultiPlayer(roomId: roomId));
                        });
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceArea(
                            entryPrice: roomData.entryFee ?? '0',
                            winningPrice: roomData.winningPrize ?? '0',
                          ),
                          const SizedBox(height: 20),
                          roomData.player1Status == 'ready' &&
                                  roomData.player2Status == 'ready'
                              ? Obx(() => Text(
                                    "Game starting in ${lobbyController.waitingTime.value} seconds...",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange,
                                    ),
                                  ))
                              : const SizedBox(),
                          const SizedBox(height: 90),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              UserCard(
                                userName: roomData.player1?.name ?? 'Player 1',
                                requiredCoins:
                                    parseCoins(roomData.player1?.totalCoins),
                                status: roomData.player1Status ?? 'waiting',
                                base64Image: roomData.player1?.image,
                              ),
                              roomData.player2 == null
                                  ? SizedBox(
                                      width: width / 2.4,
                                      child: const Text(
                                          'Waiting for Other Player'),
                                    )
                                  : UserCard(
                                      userName:
                                          roomData.player2?.name ?? 'Player 2',
                                      requiredCoins: parseCoins(
                                          roomData.player2?.totalCoins),
                                      status:
                                          roomData.player2Status ?? 'waiting',
                                      base64Image: roomData.player2?.image,
                                    ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          (() {
                            bool userIsPlayer1 = roomData.player1?.email ==
                                roomController.user.value.email;
                            bool enoughCoins = hasEnoughCoins(roomData);

                            if (!enoughCoins) {
                              return PrimaryButton(
                                buttonText: "Not Enough Coins",
                                onTap: showNotEnoughCoinsDialog,
                              );
                            }

                            if (userIsPlayer1) {
                              return PrimaryButton(
                                buttonText: "Start Game",
                                onTap: () {
                                  lobbyController.updatePlayer1Status(
                                      'ready', roomId);
                                },
                              );
                            } else {
                              if (roomData.player2Status == "waiting") {
                                return PrimaryButton(
                                  buttonText: "Ready",
                                  onTap: () {
                                    lobbyController.updatePlayer2Status(
                                        'ready', roomId);
                                  },
                                );
                              } else if (roomData.player2Status == "ready") {
                                return PrimaryButton(
                                  buttonText: "Waiting For Start",
                                  onTap: () {
                                    lobbyController.updatePlayer2Status(
                                        'waiting', roomId);
                                  },
                                );
                              } else {
                                return PrimaryButton(
                                  buttonText: "Start",
                                  onTap: () {},
                                );
                              }
                            }
                          })(),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('Room details not available.'),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
