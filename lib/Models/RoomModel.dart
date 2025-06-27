import 'UserModel.dart';

class RoomModel {
  String? id;
  String? entryFee;
  String? winningPrize;
  String? drawMatch;
  UserModel? player1;
  UserModel? player2;
  String? gameStatus; // e.g., "waiting", "ongoing", "ended"
  String? player1Status; // "online", "offline", etc.
  String? player2Status;
  List<String>? gameValue; // game board values, e.g., ["", "X", "O", ...]
  bool? isXturn; // true if X's turn
  String? winner; // "X", "O", "draw", or null
  bool? matchEnded; // true if game is over
  bool? playAgainPlayer1; // player1 clicked play again
  bool? playAgainPlayer2; // player2 clicked play again

  RoomModel({
    this.id,
    this.entryFee,
    this.winningPrize,
    this.drawMatch,
    this.player1,
    this.player2,
    this.gameStatus,
    this.player1Status,
    this.player2Status,
    this.gameValue,
    this.isXturn,
    this.winner,
    this.matchEnded,
    this.playAgainPlayer1,
    this.playAgainPlayer2,
  });

  RoomModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    entryFee = json["entryFee"];
    winningPrize = json["winningPrize"];
    drawMatch = json["drawMatch"];
    player1 =
        json["Player1"] != null ? UserModel.fromJson(json["Player1"]) : null;
    player2 =
        json["Player2"] != null ? UserModel.fromJson(json["Player2"]) : null;
    gameStatus = json["gameStatus"];
    player1Status = json["player1Status"];
    player2Status = json["player2Status"];
    gameValue =
        json["gameValue"] != null ? List<String>.from(json["gameValue"]) : null;
    isXturn = json["isXturn"];
    winner = json["winner"];
    matchEnded = json["matchEnded"];
    playAgainPlayer1 = json["playAgainPlayer1"];
    playAgainPlayer2 = json["playAgainPlayer2"];
  }

  static List<RoomModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(RoomModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["entryFee"] = entryFee;
    _data["winningPrize"] = winningPrize;
    _data["drawMatch"] = drawMatch;
    if (player1 != null) _data["Player1"] = player1?.toJson();
    if (player2 != null) _data["Player2"] = player2?.toJson();
    _data["gameStatus"] = gameStatus;
    _data["player1Status"] = player1Status;
    _data["player2Status"] = player2Status;
    if (gameValue != null) _data["gameValue"] = gameValue;
    _data["isXturn"] = isXturn;
    _data["winner"] = winner;
    _data["matchEnded"] = matchEnded;
    _data["playAgainPlayer1"] = playAgainPlayer1;
    _data["playAgainPlayer2"] = playAgainPlayer2;
    return _data;
  }
}
