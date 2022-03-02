import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/components/custom_cache_image.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/models/cast_list.dart';
import 'package:suggest_filmov/models/movie.dart';
import 'package:suggest_filmov/screens/home/components/all_movies.dart';
import 'package:suggest_filmov/screens/home/components/movies_widget.dart';
import 'package:suggest_filmov/services/api_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../provider/provider_data.dart';
import 'components/genres.dart';
import 'components/movie_detail/movie_detail_page.dart';
import 'components/now_playing.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentMaxAct = 20;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    ProviderData data = Provider.of<ProviderData>(context, listen: false);
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreActors(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return WillPopScope(
      onWillPop: () async {
        data.loaded = true;
        return false;
      },
      child: LoadingOverlay(
        isLoading: !data.loaded,
        color: Colors.black,
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(
          color: blackColor,
        ),
        child: Scaffold(
          backgroundColor: blackColor,
          appBar: AppBar(
            title: Text(
              "Suggest Filmov",
              style: textStyle,
            ),
            centerTitle: true,
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              width: Get.width,
              height: Get.height * .8,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.minHeight),
                  child: Column(
                    children: [
                      NowPlayingWidget(
                        loadMore: () {
                          _getMoreMovies(data);
                        },
                        nowPlayingMovies: data.nowPlayingMovies,
                        constraints: constraints,
                        onTapMovieCard: (int index) {
                          Movie movie = data.nowPlayingMovies[index];
                          data.loaded = false;
                          APIService().getYoutubeId(movie.id!).then((value) {
                            data.youtubeId = value;
                            data.controller = YoutubePlayerController(
                              initialVideoId: data.youtubeId,
                              flags: YoutubePlayerFlags(
                                autoPlay: false,
                                mute: false,
                                isLive: false,
                              ),
                            );
                            data.loaded = true;
                            Get.to(
                              MovieDetailPage(
                                data: data,
                                movie: movie,
                              ),
                            );
                          });
                        },
                      ),
                      /*const SizedBox(height: 10),
                      GenresWidgets(),*/
                      const SizedBox(height: 10),
                      TitleCard(
                        title: "Latest",
                        movies: data.latestMovies,
                        movieType: MovieType.latest,
                      ),
                      const SizedBox(height: 5),
                      MoviesWidget(
                        constraints: constraints,
                        movies: data.latestMovies,
                        onTapMovieCard: (int index) {
                          Movie movie = data.latestMovies[index];
                          data.loaded = false;
                          apiService.getYoutubeId(movie.id!).then((value) {
                            data.youtubeId = value;
                            data.controller = YoutubePlayerController(
                              initialVideoId: data.youtubeId,
                              flags: YoutubePlayerFlags(
                                autoPlay: false,
                                mute: false,
                                isLive: false,
                              ),
                            );
                            data.loaded = true;
                            Get.to(MovieDetailPage(
                              data: data,
                              movie: movie,
                            ));
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TitleCard(
                        title: "Top Rated",
                        color: Colors.yellowAccent,
                        movies: data.topRatedMovies,
                        movieType: MovieType.topRated,
                      ),
                      const SizedBox(height: 5),
                      MoviesWidget(
                        constraints: constraints,
                        movies: data.topRatedMovies,
                        onTapMovieCard: (int index) {
                          Movie movie = data.topRatedMovies[index];
                          data.loaded = false;
                          apiService.getYoutubeId(movie.id!).then((value) {
                            data.youtubeId = value;
                            data.controller = YoutubePlayerController(
                              initialVideoId: data.youtubeId,
                              flags: YoutubePlayerFlags(
                                autoPlay: false,
                                mute: false,
                                isLive: false,
                              ),
                            );
                            data.loaded = true;
                            Get.to(MovieDetailPage(
                              data: data,
                              movie: movie,
                            ));
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TitleCard(
                        title: "Popular Casts",
                        color: Colors.yellowAccent,
                        movies: [],
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: data.popularCasts.length,
                          itemBuilder: (context, index) {
                            Cast cast = data.popularCasts[index];

                            return CastProfile(
                                cast: cast,
                                ended: index + 1 == data.popularCasts.length);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _getMoreActors(ProviderData data) async {
    List<Cast> newCasts =
        await apiService.getPopularActors(page: _currentMaxAct ~/ 10);
    _currentMaxAct += 20;
    data.addNewCasts(newCasts);
    data.refres();
  }

  void _getMoreMovies(ProviderData data) async {
    List<Movie> newMovies =
        await apiService.getNowPlayingMovie(page: _currentMaxAct ~/ 10);
    _currentMaxAct += 20;
    data.addNewPlayingMovies(newMovies);
  }
}

class CastProfile extends StatelessWidget {
  const CastProfile({
    Key? key,
    required this.cast,
    required this.ended,
  }) : super(key: key);

  final Cast cast;
  final bool ended;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 120,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ended
          ? Center(
              child: CircularProgressIndicator(
                color: yellowColor,
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: CustomCacheImage(
                    imgUrl: cast.profilePath,
                    width: 120,
                    height: 130,
                  ),
                ),
                const SizedBox(height: 5),
                Flexible(
                  child: Text(
                    cast.name,
                    style: textStyle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );
  }
}

class TitleCard extends StatelessWidget {
  const TitleCard({
    Key? key,
    required this.title,
    this.color = blueColor,
    this.txtColor = whiteColor,
    this.movies = emptyList,
    this.movieType = MovieType.none,
  }) : super(key: key);

  final String title;
  final Color color, txtColor;
  final List<Movie> movies;
  final MovieType movieType;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          const SizedBox(width: 10),
          Container(
            width: 2,
            height: 15,
            color: color,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: textStyle.copyWith(
                color: txtColor, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const Spacer(),
          Visibility(
            visible: movies.isNotEmpty,
            child: TextButton(
              onPressed: () {
                goTo(
                  context,
                  AllMovies(
                    movies: movies,
                    movieType: movieType,
                  ),
                );
              },
              child: Text(
                "All",
                style: textStyle.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
