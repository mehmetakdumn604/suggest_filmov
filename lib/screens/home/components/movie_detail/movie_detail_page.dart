import 'dart:developer';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:suggest_filmov/components/back_icon.dart';
import 'package:suggest_filmov/components/custom_cache_image.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/models/genre.dart';
import 'package:suggest_filmov/models/movie.dart';
import 'package:suggest_filmov/provider/provider_data.dart';
import 'package:suggest_filmov/screens/bottombar.dart';
import 'package:suggest_filmov/screens/home/components/watch_button.dart';
import 'package:suggest_filmov/screens/home/home_screen.dart';
import 'package:suggest_filmov/services/sql_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'components/casts_view.dart';
import 'components/sim_mov_view.dart';

class MovieDetailPage extends StatefulWidget {
  static const String id = "home";
  MovieDetailPage({
    Key? key,
    required this.data,
    required this.movie,
    this.type,
  }) : super(key: key);
  final ProviderData data;
  final Movie movie;
  final String? type;
  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return WillPopScope(
      onWillPop: () async {
        data.loaded = true;
        return true;
      },
      child: LoadingOverlay(
        isLoading: !data.loaded,
        color: Colors.black,
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(
          color: blackColor,
        ),
        child: SafeArea(
          child: Scaffold(
              backgroundColor: blackColor,
              body: SizedBox(
                height: getSize(context).height,
                width: getSize(context).width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: getSize(context).height * .4,
                        child: Stack(
                          children: [
                            Hero(
                              tag: (widget.movie.id ?? "").toString() +
                                  widget.type.toString(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                                child: CustomCacheImage(
                                  imgUrl: widget.movie.backdropPath ?? "",
                                  height: 320.h,
                                  width: getSize(context).width,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 5,
                              top: 5,
                              child: BackIcon(
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 5,
                              top: 5,
                              child: BackIcon(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    goToRemove(context, BottomBarPage()),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 5,
                              child: Container(
                                width: getSize(context).width - 10,
                                decoration: BoxDecoration(
                                  color: blackColor.withOpacity(.5),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //* movie name
                                    FittedBox(
                                      child: Text(
                                        "${widget.movie.title!}(${widget.movie.releaseDate ?? ''.split("-")[0]})",
                                        style: textStyle.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    //genres
                                    FittedBox(
                                      child: Text(
                                        getGenre(widget.movie.genreIds!,
                                            widget.data.genres),
                                        style: textStyle.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    //rating
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      child: RatingStars(
                                        animationDuration:
                                            Duration(milliseconds: 250),
                                        maxValue: 10,
                                        starColor: yellowColor,
                                        starOffColor: Colors.grey.shade400,
                                        starCount: 5,
                                        starSize: 16,
                                        valueLabelColor: Colors.transparent,
                                        valueLabelPadding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 2),
                                        valueLabelTextStyle: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: yellowColor,
                                        ),
                                        onValueChanged: (double value) {
                                          // todo post rating
                                          // apiService.rateMovie(widget.movie.id!, value);
                                        },
                                        value: double.parse(
                                            widget.movie.voteAverage!),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    //watch button and share
                                    Row(
                                      children: [
                                        WatchButton(
                                          playTrailler: () {
                                            data.loaded = false;
                                            apiService
                                                .getYoutubeId(widget.movie.id!)
                                                .then(
                                              (value) {
                                                data.youtubeId = value;
                                                data.controller =
                                                    YoutubePlayerController(
                                                  initialVideoId:
                                                      data.youtubeId,
                                                  flags: YoutubePlayerFlags(
                                                    autoPlay: false,
                                                    mute: false,
                                                    isLive: false,
                                                  ),
                                                );
                                                data.loaded = true;
                                                goTo(
                                                    context,
                                                    VideoPlayer(
                                                        widget: widget));
                                              },
                                            );
                                          },
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (!data.watchList
                                                    .map((e) => e.id)
                                                    .contains(
                                                        widget.movie.id)) {
                                                  data.addMovieToWatchList(
                                                      widget.movie);

                                                  SqlService.instance.insert(
                                                      widget.movie, tableName);
                                                  showToast(
                                                    context,
                                                    "${widget.movie.title} added to WatchList successfully",
                                                    Colors.green.shade700,
                                                  );
                                                } else {
                                                  data.removeMovieToWatchList(
                                                      widget.movie);

                                                  SqlService.instance.delete(
                                                      widget.movie.id!,
                                                      tableName);
                                                  showToast(
                                                    context,
                                                    "${widget.movie.title} deleted from WatchList successfully",
                                                    redColor,
                                                  );
                                                }
                                              },
                                              child: Icon(
                                                !data.watchList
                                                        .map((e) => e.id)
                                                        .contains(
                                                            widget.movie.id)
                                                    ? Icons
                                                        .bookmark_add_outlined
                                                    : Icons
                                                        .bookmark_added_rounded,
                                                color: !data.watchList
                                                        .map((e) => e.id)
                                                        .contains(
                                                            widget.movie.id)
                                                    ? whiteColor
                                                    : Colors.greenAccent,
                                                size: 28,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {
                                                //todo share movie trailer and name

                                                data.loaded = false;
                                                apiService
                                                    .getYoutubeId(
                                                        widget.movie.id!)
                                                    .then(
                                                  (value) async {
                                                    await Share.share(
                                                        "https://www.youtube.com/watch?v=" +
                                                            value,
                                                        subject:
                                                            "Look what I found!");
                                                    data.loaded = true;
                                                  },
                                                );
                                              },
                                              child: Icon(
                                                Icons.share_outlined,
                                                color: whiteColor,
                                                size: 28,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      TitleCard(
                        title: "OVERVIEW",
                        txtColor: whiteColor,
                        color: redColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: ExpandableText(
                          widget.movie.overview!,
                          expandText: "Show More",
                          collapseText: "Show Less",
                          animation: true,
                          animationCurve: Curves.ease,
                          animationDuration: Duration(milliseconds: 350),
                          collapseOnTextTap: true,
                          maxLines: 8,
                          linkStyle: textStyle,
                          style: textStyle.copyWith(color: whiteColor),
                          linkColor: blueColor,
                        ),
                      ),
                      CastsView(movie: widget.movie),
                      const SizedBox(height: 15),
                      SimilarMoviesView(movie: widget.movie),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

String getGenre(List genreIds, List<Genre> allGenres) {
  String genreString = "";
  for (int i = 0; i < genreIds.length; i++) {
    for (int j = 0; j < allGenres.length; j++) {
      if (allGenres[j].id.toString().trim() == genreIds[i].toString().trim()) {
        genreString += allGenres[j].name;
        if (i != genreIds.length - 1) {
          genreString += "/";
        }
        break;
      }
    }
  }

  return genreString.trim().isEmpty ? "No found genre" : genreString;
}

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final MovieDetailPage widget;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    widget.widget.data.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        return true;
      },
      child: SafeArea(
        child: SizedBox(
          width: getSize(context).width,
          height: getSize(context).height,
          child: YoutubePlayer(
            controller: widget.widget.data.controller,
            width: MediaQuery.of(context).size.width,
            aspectRatio: 16 / 9,
            onReady: () {
              log("video is ready");
            },
          ),
        ),
      ),
    );
  }
}
