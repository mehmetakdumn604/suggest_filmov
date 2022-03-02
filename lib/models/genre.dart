class Genre {//film dizi türü
  final int id;
  final String name;

  String? error;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(dynamic json) {
    if (json == null) {
      return Genre(id: 0, name: '');
    }
    return Genre(id: json['id'], name: json['name']);
  }
}
