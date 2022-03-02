import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/models/movie.dart';
import 'package:suggest_filmov/provider/provider_data.dart';
import 'package:suggest_filmov/screens/home/components/movie_detail/movie_detail_page.dart';

import '../../../components/movie_card_widget.dart';

class AllMovies extends StatefulWidget {
  AllMovies({
    Key? key,
    required this.movies,
    required this.movieType,
    this.simMovId = 1,
  }) : super(key: key);

  final List<Movie> movies;

  final MovieType movieType;
  final int simMovId;
  @override
  State<AllMovies> createState() => _AllMoviesState();
}

class _AllMoviesState extends State<AllMovies> {
  late List<Movie> movies;
  int _currentMaxAct = 20;
  ScrollController _scrollController = ScrollController();
  bool hasLoad = true;
  @override
  void initState() {
    movies = widget.movies.toList();
    ProviderData data = Provider.of<ProviderData>(context, listen: false);
    super.initState();
    if (widget.movieType != MovieType.none) {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (await getMoreData(data)) {
            hasLoad = true;
          } else {
            hasLoad = false;
            _scrollController.dispose();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (hasLoad) {
      _scrollController.dispose();
    }
  }

  Future<bool> getMoreData(ProviderData data) async {
    List<Movie> newMovies;

    if (widget.movieType == MovieType.latest) {
      newMovies = await apiService.getTopRated(page: _currentMaxAct ~/ 10);
    } else if (widget.movieType == MovieType.similar) {
      newMovies = await apiService.getSimilarMovies(widget.simMovId,
          page: _currentMaxAct ~/ 10);
    } else {
      newMovies = await apiService.getPopular(page: _currentMaxAct ~/ 10);
    }
    if (newMovies.first.id != -1) {
      _currentMaxAct += 20;
      movies = movies.toList();
      newMovies.toSet().toList().forEach((element) {
        movies.add(element);
      });
      data.refres();
      return true;
    }
    data.refres();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        title: Text(
          widget.movieType == MovieType.latest
              ? "All Latest Movies"
              : widget.movieType == MovieType.similar
                  ? "All Similar Movies"
                  : "All Top Rated Movies",
          style: textStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimationLimiter(
          child: GridView.builder(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: movies.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return index + 1 == movies.length &&
                      hasLoad &&
                      widget.movieType != MovieType.none
                  ? Center(
                      child: CircularProgressIndicator(
                        color: yellowColor,
                      ),
                    )
                  : AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        horizontalOffset: 200,
                        child: MovieCardWidget(
                          imgHeight: 125,
                          onTapMovieCard: () {
                            goTo(
                                context,
                                MovieDetailPage(
                                  data: data,
                                  movie: movies[index],
                                ));
                          },
                          movie: movies[index],
                          index: index,
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
