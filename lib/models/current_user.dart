class CurrUser {
  late String _id;
  final String name, email, bio;

  CurrUser({
    required this.name,
    required this.email,
    required this.bio,
  });

  String get id => this._id;

  set id(String value) => this._id = value;

  factory CurrUser.fromJson(String id, Map<String, dynamic> json) {
    CurrUser currUser = CurrUser(
      name: json["name"],
      email: json["email"],
      bio: json["bio"],
    );
    currUser.id = id;
    return currUser;
  }
  Map<String, dynamic> toMap(CurrUser user) {
    return {
      "id": user.id,
      "name": user.name,
      "email": user.email,
      "bio": user.bio,
    };
  }
}
