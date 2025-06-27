import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tictactoeonlineplay/Configs/Massages.dart';
import 'package:tictactoeonlineplay/Models/RoomModel.dart';

class LobbyController extends GetxController {
  final db = FirebaseFirestore.instance;
  RxInt waitingTime = 5.obs;

  // ✅ Copy Room Code to Clipboard
  void copyRoomCode(String roomCode) {
    FlutterClipboard.copy(roomCode).then(
      (value) => successMassage('Copied'),
    );
  }

  // ✅ Get Room Details Stream
  Stream<RoomModel> getRoomDetails(String roomId) {
    return db.collection('rooms').doc(roomId).snapshots().map((event) {
      if (!event.exists || event.data() == null) {
        throw Exception('Room data not found');
      }
      return RoomModel.fromJson(event.data()!);
    });
  }

  // ✅ Optional: Game start countdown logic (currently unused in UI)
  Future<void> startGame() async {
    await timer(waitingTime.value);
  }

  // ✅ Corrected Timer Logic with Await
  Future<void> timer(int time) async {
    while (time > 0) {
      await Future.delayed(Duration(seconds: 1));
      time--;
      waitingTime.value = time;
    }
  }

  // ✅ Update Player 1 Status in Firestore
  Future<void> updatePlayer1Status(String status, String roomId) async {
    await db.collection('rooms').doc(roomId).update({
      'player1Status': status,
    });
  }

  // ✅ Update Player 2 Status in Firestore
  Future<void> updatePlayer2Status(String status, String roomId) async {
    await db.collection('rooms').doc(roomId).update({
      'player2Status': status,
    });
  }

  // ✅ Optional: Helper to identify if current user is player 1
  bool isCurrentUserPlayer1(RoomModel roomData, String currentUserEmail) {
    return roomData.player1?.email == currentUserEmail;
  }
}
