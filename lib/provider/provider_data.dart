// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suggest_filmov/models/cast_list.dart';
import 'package:suggest_filmov/models/current_user.dart';
import 'package:suggest_filmov/models/movie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/genre.dart';
import '../services/firebase_service.dart';

class ProviderData extends ChangeNotifier {
  String _youtubeId = "";
  String get youtubeId => this._youtubeId;

  set youtubeId(String value) {
    this._youtubeId = value;
    notifyListeners();
  }

  bool _loaded = true;
  bool get loaded => this._loaded;

  set loaded(bool value) {
    this._loaded = value;
    notifyListeners();
  }

  //film listeleri
  List<Movie> _nowPlayingMovies = [];
  List<Movie> get nowPlayingMovies => this._nowPlayingMovies;

  set nowPlayingMovies(List<Movie> value) {
    this._nowPlayingMovies = value;
    notifyListeners();
  }

  void addNewPlayingMovies(List<Movie> newCasts) {
    _nowPlayingMovies = _nowPlayingMovies.toList();
    newCasts.toSet().toList().forEach((element) {
      _nowPlayingMovies.add(element);
    });
    notifyListeners();
  }

  List<Movie> _upComingMovies = [];
  List<Movie> get upComingMovies => this._upComingMovies;

  set upComingMovies(List<Movie> value) {
    this._upComingMovies = value;
    notifyListeners();
  }

  //latest movies
  List<Movie> _latestMovies = [];
  List<Movie> get latestMovies => this._latestMovies;

  set latestMovies(List<Movie> value) {
    this._latestMovies = value;
    notifyListeners();
  }

  void addNewLatestMovies(List<Movie> newCasts) {
    _latestMovies = _latestMovies.toList();
    newCasts.toSet().toList().forEach((element) {
      _latestMovies.add(element);
    });
    notifyListeners();
  }

  //watchList
  List<Movie> _watchList = [];
  List<Movie> get watchList => this._watchList;

  set watchList(List<Movie> value) {
    this._watchList = value;

    notifyListeners();
  }

  void addMovieToWatchList(Movie movie) {
    _watchList.add(movie);
    notifyListeners();
  }

  void removeMovieToWatchList(Movie movie) {
    _watchList.remove(_watchList
        .firstWhere((element) => element.id.toString() == movie.id.toString()));
    notifyListeners();
  }

  //fav mov lists
  List<Movie> _favList = [];
  List<Movie> get favList => this._favList;

  set favList(List<Movie> value) {
    this._favList = value;

    notifyListeners();
  }

  void addMovieToFavList(Movie movie) {
    _favList.add(movie);
    notifyListeners();
  }

  void removeMovieToFavList(Movie movie) {
    _favList.remove(_favList
        .firstWhere((element) => element.id.toString() == movie.id.toString()));
    notifyListeners();
  }

//discover movies
  List<Movie> _discoverMovies = [];
  List<Movie> get discoverMovies => this._discoverMovies;

  set discoverMovies(List<Movie> value) {
    this._discoverMovies = value;
    notifyListeners();
  }

  int _discoverPage = 1;
  int get discoverPage => this._discoverPage;

  set discoverPage(int value) {
    this._discoverPage = value;
    notifyListeners();
  }

  // top rated Movies
  List<Movie> _topRatedMovies = [];
  List<Movie> get topRatedMovies => this._topRatedMovies;

  set topRatedMovies(List<Movie> value) {
    this._topRatedMovies = value;
    notifyListeners();
  }

  // similar movies List
  List<Movie> _similarMovies = [];
  List<Movie> get similarMovies => this._similarMovies;

  set similarMovies(List<Movie> value) {
    this._similarMovies = value;
    notifyListeners();
  }

  int _similarPage = 1;
  int get similarPage => this._similarPage;

  set similarPage(int value) {
    this._similarPage = value;
    notifyListeners();
  }

  //tür listesi
  List<Genre> _genres = [];
  List<Genre> get genres => this._genres;

  set genres(List<Genre> value) {
    this._genres = value;
    notifyListeners();
  }

  //cast lists
  List<Cast> _popularCasts = [];
  List<Cast> get popularCasts => this._popularCasts;

  set popularCasts(List<Cast> value) {
    this._popularCasts = value.toSet().toList();
    notifyListeners();
  }

  void addNewCasts(List<Cast> newCasts) {
    _popularCasts = _popularCasts.toList();
    newCasts.toSet().toList().forEach((element) {
      _popularCasts.add(element);
    });
    notifyListeners();
  }

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: "",
    flags: YoutubePlayerFlags(
      forceHD: true,
      autoPlay: false,
      mute: false,
      isLive: false,
    ),
  );

  YoutubePlayerController get controller => this._controller;

  set controller(YoutubePlayerController value) => this._controller = value;

  // bottom bar page indexi
  int _pageIndex = 0;
  int get pageIndex => this._pageIndex;

  set pageIndex(int value) {
    this._pageIndex = value;
    notifyListeners();
  }

  //controllers
  TextEditingController _similarController = TextEditingController();
  TextEditingController get similarController => this._similarController;

  void clearDataTextController() {
    _similarController.clear();
    notifyListeners();
  }

  //refresh page
  void refres() {
    notifyListeners();
  }

  //searching movie
  String _searchMovie = "";
  String get searchMovie => this._searchMovie;

  set searchMovie(String value) {
    this._searchMovie = value;
    notifyListeners();
  }

  //curr user
  CurrUser? _currUser;
  CurrUser get currUser => this._currUser!;

  set currUser(CurrUser value) {
    this._currUser = value;
  }

  //profile image
  File? _profileImage;
  String _url = "";
  File? get profileImage => this._profileImage;

  set profileImage(File? value) {
    this._profileImage = value;
    notifyListeners();
  }

  String get url => this._url;

  set url(String value) {
    this._url = value;
    notifyListeners();
  }

  Future<void> uploadProfile() async {
    try {
      var recievedFile = await ImagePicker.platform.getImage(
        source: ImageSource.gallery,
        maxWidth: 100,
        maxHeight: 100,
      );
      if (recievedFile == null)
        return;
      else {
        profileImage = File(recievedFile.path);

        FirestorageService.uploadImage(_profileImage!).then((s) => getUrl());
      }
    } on PlatformException catch (e) {
      print("platform exception $e");
    }
    notifyListeners();
  }

  Future<void> getUrl() async {
    String tempUrl = await FirestorageService.loadImage();
    url = tempUrl;
    notifyListeners();
  }
}
