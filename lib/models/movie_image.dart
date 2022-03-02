

import 'package:suggest_filmov/models/screenshot.dart';

class MovieImage {
  final List<Screenshot> backdrops;
  final List<Screenshot> posters;

  const MovieImage({required this.backdrops, required this.posters});

  factory MovieImage.fromJson(Map<String, dynamic> result) {
   

    return MovieImage(
      backdrops: (result['backdrops'] as List)
              .map((b) => Screenshot.fromJson(b))
              .toList(),
      posters: (result['posters'] as List)
              .map((b) => Screenshot.fromJson(b))
              .toList(),
    );
  }

}