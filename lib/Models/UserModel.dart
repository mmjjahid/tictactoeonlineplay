class UserModel {
  String? id;
  String? name;
  String? email;
  String? image;
  String? totalWins;
  String? totalLosses;
  String? totalDraws;
  String? totalMatches; // ✅ total matches
  String? role;
  String? totalCoins; // ✅ total coins
  bool? yourTurn;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.image,
    this.totalWins,
    this.totalLosses,
    this.totalDraws,
    this.totalMatches,
    this.role,
    this.totalCoins,
    this.yourTurn,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    image = json["image"];
    totalWins = json["totalWins"];
    totalLosses = json["totalLosses"];
    totalDraws = json["totalDraws"];
    totalMatches = json["totalMatches"];
    role = json["role"];
    totalCoins = json["totalCoins"];
    yourTurn = json["yourTurn"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "image": image,
      "totalWins": totalWins,
      "totalLosses": totalLosses,
      "totalDraws": totalDraws,
      "totalMatches": totalMatches,
      "role": role,
      "totalCoins": totalCoins,
      "yourTurn": yourTurn,
    };
  }
}
