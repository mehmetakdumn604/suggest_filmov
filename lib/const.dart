// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:suggest_filmov/models/movie.dart';

const APIKEY = "YOUR_TMDB_API_KEY";

const READACCESSTOKEN =
    "YOUR_READ_ACCESS_TOKEN";

const Color redColor = Color(0xffFF4A4A);
const Color blackColor = Color(0xff26231F);
const Color blueColor = Color(0xff1F83FF);
const Color whiteColor = Color(0xffEBEBEB);
const Color yellowColor = Color(0xffF8C91D);
const Color loginBg = Color(0xffF6F9FE);
const Color loginButtonBg = Color(0xffEBF2F8);

void goTo(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}

void goToRemove(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => page),
    (route) => false,
  );
}

const String tableName = "watchList";

const String favTable = "favTable";

const List<Movie> emptyList = [];

enum MovieType {
  latest,
  topRated,
  similar,
  none,
}

String tvRecPageKey = "tvPage";
String movRecPageKey = "movRecPage";

String latestPageKey = "latestPage";
String topRatedPageKey = "topRatedPage";
String discoverPageKey = "discoverPage";

// total_pages: 6263, total_results: 125253
