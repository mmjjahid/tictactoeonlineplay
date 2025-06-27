import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tictactoeonlineplay/Configs/Massages.dart';
import 'package:tictactoeonlineplay/Models/RoomModel.dart';
import 'package:tictactoeonlineplay/Models/UserModel.dart';
import 'package:tictactoeonlineplay/Pages/LobbyPage/LobbyPage.dart';
import 'package:uuid/uuid.dart';

class RoomController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  var uuid = Uuid();

  RxString roomCode = ''.obs;
  RxBool isLoading = false.obs;
  Rx<UserModel> user = UserModel().obs;

  @override
  void onInit() {
    getUserDetails();
    super.onInit();
  }

  Future<void> getUserDetails() async {
    final userId = auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot = await db.collection("users").doc(userId).get();
      if (snapshot.exists) {
        user.value = UserModel.fromJson(snapshot.data()!);
      }
    } catch (e) {
      print("❌ Failed to get user details: $e");
    }
  }

  Future<void> createRoom() async {
    isLoading.value = true;

    await getUserDetails();

    if (user.value.id == null) {
      errorMassage("User not found");
      isLoading.value = false;
      return;
    }

    int coins = int.tryParse(user.value.totalCoins ?? '0') ?? 0;
    if (coins < 10) {
      errorMassage("You need at least 10 coins to create a room.");
      isLoading.value = false;
      return;
    }

    String id = uuid.v4().substring(0, 8).toUpperCase();
    roomCode.value = id;

    var player1 = UserModel(
      id: user.value.id,
      name: user.value.name,
      email: user.value.email,
      totalWins: user.value.totalWins ?? '0',
      totalCoins: user.value.totalCoins ?? '0',
      image: user.value.image,
      totalDraws: user.value.totalDraws ?? '0',
      totalLosses: user.value.totalLosses ?? '0',
      totalMatches: user.value.totalMatches,
      role: 'admin',
    );

    var newRoom = RoomModel(
      id: id,
      entryFee: '10',
      winningPrize: '20',
      drawMatch: '',
      player1: player1,
      gameStatus: 'lobby',
      player1Status: 'waiting',
      gameValue: List.filled(9, ""),
      isXturn: true,
    );

    try {
      await db.collection('rooms').doc(id).set(newRoom.toJson());
      successMassage('Room Created Successfully');
      Get.to(() => LobbyPage(roomId: id));
    } catch (e) {
      print("❌ Error while creating room: $e");
      errorMassage("Room creation failed.");
    }

    isLoading.value = false;
  }

  Future<void> joinRoom(String roomId) async {
    isLoading.value = true;

    await getUserDetails(); // Ensure user data is fresh

    if (user.value.id == null) {
      errorMassage("User not found");
      isLoading.value = false;
      return;
    }

    int coins = int.tryParse(user.value.totalCoins ?? '0') ?? 0;
    if (coins < 10) {
      errorMassage("You need at least 10 coins to join a room.");
      isLoading.value = false;
      return;
    }

    var player2 = UserModel(
      id: user.value.id,
      name: user.value.name,
      email: user.value.email,
      totalWins: user.value.totalWins ?? '0',
      totalCoins: user.value.totalCoins ?? '0',
      image: user.value.image,
      totalDraws: user.value.totalDraws ?? '0',
      totalLosses: user.value.totalLosses ?? '0',
      totalMatches: user.value.totalMatches,
      role: 'player',
    );

    try {
      await db.collection('rooms').doc(roomId).update({
        'Player2': player2.toJson(),
        'player2Status': 'waiting',
      });

      successMassage('Join Successful');
      Get.to(() => LobbyPage(roomId: roomId));
    } catch (e) {
      errorMassage('Failed to join room.');
      print("❌ Error while joining room: $e");
    }

    isLoading.value = false;
  }
}
