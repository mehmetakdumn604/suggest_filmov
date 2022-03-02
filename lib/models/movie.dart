import 'package:suggest_filmov/models/movie_detail.dart';
import 'package:suggest_filmov/models/movie_image.dart';

List<String> columnNames = [
  "id",
  "backdrop_path",
  "original_language",
  "original_title",
  "overview",
  "popularity",
  "poster_path",
  "release_date",
  "title",
  "vote_average",
  "vote_count",
  "genre_ids",
];

class Movie {
  final String? backdropPath;
  final int? id, sqlId;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final int? voteCount;
  final String? voteAverage;
  final List? genreIds;
  MovieImage? movieImage;

  String? error;

  Movie({
    this.sqlId,
    this.backdropPath,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteCount,
    this.voteAverage,
    this.genreIds,
    this.movieImage,
  });

  factory Movie.fromJson(dynamic json, {bool fromSql = false}) {
    if (json == null) {
      return Movie();
    }
    List genres = [];
    if (fromSql) {
      String genreId = json["genre_ids"];
      genreId = genreId.replaceFirst("[", "");
      genreId = genreId.replaceFirst("]", "");

      genres = genreId.split(",") as List;
    } else {
      genres = json["genre_ids"];
    }
    return Movie(
      backdropPath: json["backdrop_path"] ?? json["poster_path"],
      id: json["id"],
      originalLanguage: json["original_language"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      popularity: json["popularity"],
      posterPath: json["poster_path"],
      releaseDate: json["release_date"],
      title: json["title"] ?? json["name"],
      video: json["video"] ?? false,
      voteAverage: json["vote_average"].toString(),
      voteCount: json["vote_count"],
      genreIds: genres,
    );
  }

  Movie copy({
    int? sqlId,
  }) =>
      Movie(
        sqlId: sqlId,
        backdropPath: this.backdropPath,
        id: this.id,
        originalLanguage: this.originalLanguage,
        originalTitle: this.originalTitle,
        overview: this.overview,
        popularity: this.popularity,
        posterPath: this.posterPath,
        releaseDate: this.releaseDate,
        title: this.title,
        voteAverage: this.voteAverage.toString(),
        voteCount: this.voteCount,
        genreIds: this.genreIds,
      );

  Map<String, Object?> toJson() => {
        "sqlId": sqlId,
        "id": id!,
        "backdrop_path": backdropPath ?? "",
        "original_language": originalLanguage ?? "en",
        "original_title": originalTitle ?? "",
        "overview": overview ?? "",
        "popularity": popularity.toString(),
        "poster_path": posterPath ?? "",
        "release_date": releaseDate ?? "",
        "title": title ?? "",
        "vote_average": voteAverage ?? "",
        "vote_count": voteCount ?? 0,
        "genre_ids": genreIds.toString()
      };
}
