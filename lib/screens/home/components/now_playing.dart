import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:suggest_filmov/components/custom_cache_image.dart';
import '../../../models/movie.dart';

class NowPlayingWidget extends StatelessWidget {
  const NowPlayingWidget({
    Key? key,
    required this.nowPlayingMovies,
    required this.constraints,
    required this.loadMore,
    this.fullHeight = false,
    required this.onTapMovieCard,
  }) : super(key: key);

  final List<Movie> nowPlayingMovies;
  final BoxConstraints constraints;
  final Function onTapMovieCard, loadMore;
  final bool fullHeight;

  @override
  Widget build(BuildContext context) {
    return nowPlayingMovies.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : CarouselSlider.builder(
            itemCount: nowPlayingMovies.length,
            itemBuilder: (context, index, pageIndex) {
              Movie movie = nowPlayingMovies[index];
              if (index + 1 == nowPlayingMovies.length) {
                loadMore();
              }
              return GestureDetector(
                onTap: () => onTapMovieCard(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        CustomCacheImage(
                          imgUrl: movie.backdropPath ?? "",
                          width: constraints.maxWidth,
                          height: fullHeight
                              ? constraints.maxHeight / 1.5
                              : constraints.maxHeight / 3,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 20,
                          child: Text(
                            movie.title!.toUpperCase() +
                                "\n" +
                                movie.releaseDate.toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.black.withOpacity(.6),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              autoPlayCurve: Curves.easeInBack,
              aspectRatio: 16 / 9,
              autoPlay: true,
              pauseAutoPlayOnTouch: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.85,
              enlargeCenterPage: true,
            ),
          );
  }
}
