import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/main.dart';
import 'package:suggest_filmov/models/movie.dart';
import 'package:suggest_filmov/models/review.dart';
import 'package:suggest_filmov/provider/provider_data.dart';
import 'package:suggest_filmov/services/base_service.dart';
import 'package:suggest_filmov/services/shared_service.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../models/cast_list.dart';
import '../models/genre.dart';
import '../models/movie_detail.dart';
import '../models/movie_image.dart';

class APIService extends BaseService {
  Dio _dio = Dio();
  TMDB _tmdb = TMDB(
    ApiKeys(APIKEY, READACCESSTOKEN),
  );
  final String _baseUrl = "https://api.themoviedb.org/3";
  bool realUpcoming(String releaseDate) {
    List<int> date = releaseDate
        .split("-")
        .map((e) => int.parse(e))
        .toList(); // 2022-01-05 => [2022,01,05]
    DateTime currentTime = DateTime.now();
    return DateTime(date[0], date[1], date[2]).isAfter(currentTime);
  }

  Future<List<Movie>> getUpComingMovies(
    ProviderData providerData,
  ) async {
    try {
      final response = await _tmdb.v3.movies.getUpcoming(page: page);

      final results = List<Map<String, dynamic>>.from(response['results']);
      List<Movie> movies = results.map((value) {
        Movie movie = Movie.fromJson(value);
        return movie;
      }).toList(growable: true);
      List<Movie> movies2 = movies
          .where((element) => realUpcoming(element.releaseDate!))
          .toList();
      providerData.upComingMovies = movies2;
      return movies2;
    } on DioError catch (e) {
      throw Exception("failed to load : ${e.error}");
    }
  }

  Future<List<Movie>> getNowPlayingMovie({int page = 1}) async {
    DateTime dateTime = DateTime.now();
    String year =
        dateTime.year > 9 ? dateTime.year.toString() : "0${dateTime.year}";

    try {
      final response = await Dio().get(
          "https://api.themoviedb.org/3/discover/movie?api_key=$APIKEY&sort_by=primary_release_year.desc&page=$page&primary_release_year=$year");
      final results = List<Map<String, dynamic>>.from(response.data['results']);

      List<Movie> movies =
          results.map((movie) => Movie.fromJson(movie)).toList(growable: false);
      //   providerData.nowPlayingMovies = movies;
      return movies;
    } on DioError catch (e) {
      throw Exception("failed to load : ${e.error}");
    }
  }

  Future<List<Movie>> getDiscover(ProviderData data) async {
    try {
      final response = await _tmdb.v3.discover
          .getMovies(page: await SharedService.getData(discoverPageKey));
      final results = List<Map<String, dynamic>>.from(response["results"]);

      List<Movie> movies =
          results.map((movie) => Movie.fromJson(movie)).toList(growable: false);
      data.discoverMovies = movies;

      return movies;
    } on DioError catch (e) {
      throw Exception("failed to load : ${e.error}");
    }
  }

  Future<List<Movie>> getPopular({int page = 1}) async {
    try {
      final response = await _tmdb.v3.movies
          .getPopular(page: await SharedService.getData(latestPageKey));
      final results = List<Map<String, dynamic>>.from(response["results"]);

      List<Movie> movies =
          results.map((movie) => Movie.fromJson(movie)).toList(growable: false);
      //  providerData.latestMovies = movies;

      return movies;
    } on DioError catch (e) {
      throw Exception("failed to load : ${e.error}");
    }
  }

  Future<List<Movie>> getTopRated({int page = 1}) async {
    try {
      final response = await _tmdb.v3.movies
          .getTopRated(page: await SharedService.getData(topRatedPageKey));
      final results = List<Map<String, dynamic>>.from(response["results"]);

      List<Movie> movies =
          results.map((movie) => Movie.fromJson(movie)).toList();
      //data.topRatedMovies = movies;

      return movies;
    } on DioError catch (e) {
      throw Exception("failed to load : ${e.error}");
    }
  }

  Future<List<Cast>> getPopularActors({int page = 1}) async {
    try {
      final response = await _tmdb.v3.people.getPopular(page: page);
      final results = List<Map<String, dynamic>>.from(response["results"]);

      List<Cast> castList =
          results.map((movie) => Cast.fromJson(movie)).toList(growable: false);
      // data.popularCasts = castList;

      return castList;
    } on DioError catch (e) {
      throw Exception("failed to load : ${e.error}");
    }
  }

  Future<List<Movie>> getMovieByGenre(int movieId) async {
    try {
      final response = await Dio().get(
          "https://api.themoviedb.org/3/discover?with_genres=$movieId&api_key=$APIKEY&page=$page");

      final results = List<Map<String, dynamic>>.from(response.data['results']);

      List<Movie> movies = results.map((movie) {
        Movie movieModel = Movie.fromJson(movie);
        return movieModel;
      }).toList(growable: false);

      return movies;
    } on DioError catch (e) {
      throw Exception("failed to load : ${e.error}");
    }
  }

  Future<List<Genre>> getGenreList(ProviderData data,
      {bool isMovie = true}) async {
    try {
      String filmType = isMovie ? "movie" : "tv";
      final response = await _dio.get(
          'https://api.themoviedb.org/3/genre/$filmType/list?api_key=$APIKEY&page=$page');
      var genres = response.data['genres'] as List;
      List<Genre> genreList = genres.map((g) => Genre.fromJson(g)).toList();
      data.genres = genreList;
      return genreList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<MovieDetail> getMovieDetail(
      BuildContext context, int movieId, ProviderData data) async {
    try {
      final response =
          await _dio.get('https://api.themoviedb.org/3/movie/$movieId?$APIKEY');
      MovieDetail movieDetail = MovieDetail.fromJson(response.data);

      movieDetail.trailerId = await getYoutubeId(movieId);

      movieDetail.movieImage = await getMovieImage(movieId);

      movieDetail.castList = await getCastList(movieId);

      return movieDetail;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<String> getYoutubeId(int movieId) async {
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$APIKEY');

      var youtubeId = response.data['results'][0]['key'];

      return youtubeId;
    } catch (error) {
      return "noLink";
    }
  }

  Future<MovieImage> getMovieImage(int movieId) async {
    try {
      final response = await _tmdb.v3.movies.getImages(movieId);

      return MovieImage.fromJson(response["results"]);
    } catch (error) {
      throw Exception('Exception accoured: $error');
    }
  }

  Future<List<Cast>> getCastList(int movieId) async {
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$APIKEY');
      var list = response.data['cast'] as List;

      List<Cast> castList = list.map((c) => Cast.fromJson(c)).toList();
      return castList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Movie>> getSearchMovList(String query) async {
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/search/movie?api_key=$APIKEY&query=$query');

      var list = response.data["results"] as List;

      if (list.isEmpty) {
        return [Movie(title: "notfounded")];
      }
      return list.map((c) => Movie.fromJson(c)).toList();
    } catch (error) {
      throw Exception('Exception accoured: $error');
    }
  }

  Future<List<Movie>> getRecommendations(int movieId,
      {bool isMovie = true}) async {
    try {
      final response = isMovie
          ? await _tmdb.v3.movies.getRecommended(movieId,
              page: await SharedService.getData(movRecPageKey))
          : await _tmdb.v3.tv
              .getTopRated(page: await SharedService.getData(tvRecPageKey));

      var list = response["results"] as List;

      if (list.isEmpty) {
        return [Movie(title: "notfounded")];
      }
      return list.map((c) => Movie.fromJson(c)).toList();
    } catch (error) {
      throw Exception('Exception accoured: $error');
    }
  }

  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    try {
      final response = await _tmdb.v3.movies.getSimilar(movieId, page: page);

      var list = response["results"] as List;

      List<Movie> movieList = list.map((c) => Movie.fromJson(c)).toList();
      //  data.similarMovies = movieList;
      return movieList;
    } catch (error) {
      // throw Exception('Exception accoured: $error');
      return [Movie(id: -1)];
    }
  }

  Future<void> getImagesOfMovie(
    int movieId,
  ) async {
    try {
      var response = await _tmdb.v3.movies.getImages(movieId);

      var list = response["posters"];
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<ReviewModel>> getReviewsOfMovie(int movieId) async {
    try {
      var response = await _tmdb.v3.movies.getReviews(movieId);
      var list = response["results"] as List;
      List<ReviewModel> reviews =
          list.map((e) => ReviewModel.fromJson(e)).toList();
      if (reviews.isEmpty) {
        reviews.add(ReviewModel(
            author: "AuthorMakduman",
            authorDetails: AuthorDetails(
                avatarPath: "", name: "", rating: 0, username: ""),
            content: "",
            createdAt: DateTime(2000),
            id: "",
            updatedAt: DateTime(2000),
            url: ""));
      }
      return reviews;
    } catch (e) {
      return [
        ReviewModel(
            author: "AuthorMakduman",
            authorDetails: AuthorDetails(
                avatarPath: "", name: "", rating: 0, username: ""),
            content: "",
            createdAt: DateTime(2000),
            id: "",
            updatedAt: DateTime(2000),
            url: "")
      ];
    }
  }

  Future<void> rateMovie(int movieId, double ratingValue) async {
    try {
      var response = await _tmdb.v3.movies.rateMovie(movieId, ratingValue);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> createRequesToken() async {
    try {
      var reqToken = await _dio.get(
          "https://api.themoviedb.org/3/authentication/token/new?api_key=$APIKEY");

      return reqToken.data["request_token"];
    } catch (e) {
      throw Exception("Request Token Error : APIService() : line 336");
    }
  }

  Future<String> getValidateUrl() async {
    String requestToken = await createRequesToken();
    return _tmdb.v3.auth.getValidationUrl(requestToken);
  }

  Future<String> createSessionId() async {
    String reqToken = await createRequesToken();
    try {
      var sessionId = await _dio.post(
        "$_baseUrl/authentication/session/new?api_key=$APIKEY&request_token=$reqToken",
      );
      return sessionId.data["session_id"];
    } catch (e) {
      throw Exception("Session Id Error : APIService() : line 348");
    }
  }
}
