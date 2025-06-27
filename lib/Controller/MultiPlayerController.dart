// FILE: MultiPlayerController.dart (Fixed sound and play-again issues)
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tictactoeonlineplay/Models/UserModel.dart';
import '../Models/RoomModel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tictactoeonlineplay/Configs/AssetsPath.dart';
import 'package:audioplayers/audioplayers.dart';

class MultiPlayerController extends GetxController {
  final db = FirebaseFirestore.instance;
  RxBool isXtime = true.obs;
  RxMap<String, bool> hasShownDialog = <String, bool>{}.obs;
  ConfettiController confettiController =
      ConfettiController(duration: Duration(seconds: 2));
  StreamSubscription<DocumentSnapshot>? playAgainListener;
  StreamSubscription<DocumentSnapshot>? roomListener;
  Timer? autoExitTimer;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool hasPlayedSound = false;

  @override
  void onClose() {
    confettiController.dispose();
    playAgainListener?.cancel();
    roomListener?.cancel();
    autoExitTimer?.cancel();
    audioPlayer.dispose();
    super.onClose();
  }

  Stream<RoomModel> getRoomDetails(String roomId) {
    return db.collection('rooms').doc(roomId).snapshots().map((event) {
      final data = event.data();
      if (data == null) throw Exception('Room data not found');
      return RoomModel.fromJson(data);
    });
  }

  void listenMatchStatus(String roomId, String currentPlayerId) {
    roomListener?.cancel();
    roomListener =
        db.collection('rooms').doc(roomId).snapshots().listen((doc) async {
      if (!doc.exists || hasShownDialog[roomId] == true) return;
      final data = RoomModel.fromJson(doc.data()!);

      if (data.matchEnded == true) {
        hasShownDialog[roomId] = true;
        hasPlayedSound = false; // Reset sound flag for new match end

        await Future.delayed(Duration(milliseconds: 300));

        if (data.winner == "draw") {
          if (!hasPlayedSound) {
            await playSound('draw');
            hasPlayedSound = true;
          }
          showDialogBox("Match Draw", "You both played well!", roomData: data);
        } else {
          String winnerSymbol = data.winner!;
          bool isPlayerWinner =
              (winnerSymbol == "X" && data.player1?.id == currentPlayerId) ||
                  (winnerSymbol == "O" && data.player2?.id == currentPlayerId);

          if (isPlayerWinner) {
            confettiController.play();
            if (!hasPlayedSound) {
              await playSound('win');
              hasPlayedSound = true;
            }
            showDialogBox("Congratulations!", "$winnerSymbol won the match",
                roomData: data, showCrown: true);
          } else {
            if (!hasPlayedSound) {
              await playSound('lose');
              hasPlayedSound = true;
            }
            showDialogBox("Oops!", "$winnerSymbol won the match",
                roomData: data);
          }
        }
      }
    });
  }

  Future<void> playSound(String type) async {
    try {
      String path = '';
      switch (type) {
        case 'win':
          path = 'assets/sounds/win.mp3';
          break;
        case 'lose':
          path = 'assets/sounds/lose.mp3';
          break;
        case 'draw':
          path = 'assets/sounds/draw.mp3';
          break;
      }
      if (path.isNotEmpty) {
        await audioPlayer.play(AssetSource(path));
      }
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> updateData(String roomId, List<String> gameValue, int index,
      RoomModel roomData, String currentPlayerId) async {
    List<String> oldValue = List.from(gameValue);
    bool isXturn = roomData.isXturn ?? true;

    if ((isXturn && roomData.player1?.id != currentPlayerId) ||
        (!isXturn && roomData.player2?.id != currentPlayerId)) {
      Get.snackbar('Wait!', 'It\'s not your turn!',
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (oldValue[index].isEmpty && !(roomData.matchEnded ?? false)) {
      oldValue[index] = isXturn ? "X" : "O";
      await db.collection("rooms").doc(roomId).update({
        "gameValue": oldValue,
        "isXturn": !isXturn,
      });
      await checkWinner(oldValue, roomData);
    } else {
      Get.snackbar(
          'Invalid Move', 'This cell is already occupied or game ended!',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> checkWinner(List<String> playValue, RoomModel roomData) async {
    String? winner;
    List<List<int>> winningPositions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var positions in winningPositions) {
      if (playValue[positions[0]] == playValue[positions[1]] &&
          playValue[positions[0]] == playValue[positions[2]] &&
          playValue[positions[0]].isNotEmpty) {
        winner = playValue[positions[0]];
        break;
      }
    }

    if (winner != null) {
      await db.collection("rooms").doc(roomData.id).update({
        "winner": winner,
        "matchEnded": true,
      });
      await updateStats(winner, winner == 'X' ? 'O' : 'X', roomData);
    } else if (!playValue.contains('')) {
      await db.collection("rooms").doc(roomData.id).update({
        "winner": "draw",
        "matchEnded": true,
      });
      await updateDraw(roomData);
    }
  }

  void showDialogBox(String title, String subtitle,
      {required RoomModel roomData, bool showCrown = false}) {
    startAutoExitTimer();
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            if (showCrown) SvgPicture.asset(IconsPath.kingIcon, width: 60),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(subtitle),
        actions: [
          TextButton(
            onPressed: () => handlePlayAgain(roomData,
                isPlayer1: roomData.player1?.id == Get.find<UserModel>().id),
            child: Text('Play Again'),
          ),
          TextButton(
            onPressed: () => Get.offAllNamed('/home'),
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }

  Future<void> handlePlayAgain(RoomModel roomData,
      {required bool isPlayer1}) async {
    final user = Get.find<UserModel>();
    if (int.parse(user.totalCoins ?? '0') < 10) {
      Get.snackbar("Not enough coins", "You need at least 10 coins to play",
          snackPosition: SnackPosition.TOP);
      return;
    }

    String roomId = roomData.id!;
    String playAgainField = isPlayer1 ? "playAgainPlayer1" : "playAgainPlayer2";

    await db.collection("rooms").doc(roomId).update({
      playAgainField: true,
    });

    Get.snackbar('Waiting', 'Waiting for opponent...',
        snackPosition: SnackPosition.TOP);

    playAgainListener?.cancel();
    playAgainListener = db.collection("rooms").doc(roomId).snapshots().listen(
      (doc) async {
        if (!doc.exists) return;
        RoomModel updatedRoom = RoomModel.fromJson(doc.data()!);

        if ((updatedRoom.playAgainPlayer1 ?? false) &&
            (updatedRoom.playAgainPlayer2 ?? false)) {
          await updateCoinsForReplay(updatedRoom);

          await db.collection("rooms").doc(roomId).update({
            "gameValue": List.filled(9, ''),
            "isXturn": true,
            "matchEnded": false,
            "winner": null,
            "playAgainPlayer1": false,
            "playAgainPlayer2": false,
          });

          hasShownDialog[roomId] = false;
          hasPlayedSound = false;
          playAgainListener?.cancel();
          autoExitTimer?.cancel();
          Get.back(); // Close the result dialog
        }
      },
    );

    autoExitTimer = Timer(Duration(seconds: 10), () async {
      await db.collection("rooms").doc(roomId).update({
        playAgainField: false,
      });
      Get.back();
      Get.snackbar("Opponent not ready", "Opponent did not want to play.",
          snackPosition: SnackPosition.TOP);
    });
  }

  Future<void> updateCoinsForReplay(RoomModel room) async {
    final p1 = room.player1!;
    final p2 = room.player2!;

    p1.totalCoins = (int.parse(p1.totalCoins ?? '0') - 10).toString();
    p2.totalCoins = (int.parse(p2.totalCoins ?? '0') - 10).toString();

    await db.collection("users").doc(p1.id).update({
      "totalCoins": p1.totalCoins,
    });
    await db.collection("users").doc(p2.id).update({
      "totalCoins": p2.totalCoins,
    });
  }

  void startAutoExitTimer() {
    autoExitTimer?.cancel();
    autoExitTimer = Timer(Duration(seconds: 15), () {
      Get.offAllNamed('/home');
    });
  }

  Future<void> updateStats(
      String winner, String loser, RoomModel roomData) async {
    UserModel player1 = roomData.player1!;
    UserModel player2 = roomData.player2!;
    bool winnerIsPlayer1 = (winner == 'X');

    UserModel updatedWinner = winnerIsPlayer1 ? player1 : player2;
    UserModel updatedLoser = winnerIsPlayer1 ? player2 : player1;

    updatedWinner.totalWins =
        (int.parse(updatedWinner.totalWins ?? '0') + 1).toString();
    updatedWinner.totalCoins =
        (int.parse(updatedWinner.totalCoins ?? '0') + 20).toString();
    updatedWinner.totalMatches =
        (int.parse(updatedWinner.totalMatches ?? '0') + 1).toString();

    updatedLoser.totalCoins =
        (int.parse(updatedLoser.totalCoins ?? '0') - 10).toString();
    updatedLoser.totalMatches =
        (int.parse(updatedLoser.totalMatches ?? '0') + 1).toString();

    await db.collection("rooms").doc(roomData.id).update({
      "player1":
          winnerIsPlayer1 ? updatedWinner.toJson() : updatedLoser.toJson(),
      "player2":
          winnerIsPlayer1 ? updatedLoser.toJson() : updatedWinner.toJson(),
    });

    await db.collection("users").doc(updatedWinner.id).update({
      "totalWins": updatedWinner.totalWins,
      "totalCoins": updatedWinner.totalCoins,
      "totalMatches": updatedWinner.totalMatches,
    });

    await db.collection("users").doc(updatedLoser.id).update({
      "totalCoins": updatedLoser.totalCoins,
      "totalMatches": updatedLoser.totalMatches,
    });
  }

  Future<void> updateDraw(RoomModel roomData) async {
    UserModel player1 = roomData.player1!;
    UserModel player2 = roomData.player2!;

    player1.totalDraws = (int.parse(player1.totalDraws ?? '0') + 1).toString();
    player1.totalMatches =
        (int.parse(player1.totalMatches ?? '0') + 1).toString();

    player2.totalDraws = (int.parse(player2.totalDraws ?? '0') + 1).toString();
    player2.totalMatches =
        (int.parse(player2.totalMatches ?? '0') + 1).toString();

    await db.collection("rooms").doc(roomData.id).update({
      "player1": player1.toJson(),
      "player2": player2.toJson(),
    });

    await db.collection("users").doc(player1.id).update({
      "totalDraws": player1.totalDraws,
      "totalMatches": player1.totalMatches,
    });
    await db.collection("users").doc(player2.id).update({
      "totalDraws": player2.totalDraws,
      "totalMatches": player2.totalMatches,
    });
  }
}
