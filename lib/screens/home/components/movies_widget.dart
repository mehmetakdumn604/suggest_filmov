import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:suggest_filmov/components/movie_card_widget.dart';
import '../../../models/movie.dart';

class MoviesWidget extends StatelessWidget {
  const MoviesWidget({
    Key? key,
    required this.constraints,
    required this.movies,
    required this.onTapMovieCard,
  }) : super(key: key);
  final BoxConstraints constraints;
  final Function onTapMovieCard;
  final List<Movie> movies;
  @override
  Widget build(BuildContext context) {
    return movies.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : CarouselSlider.builder(
            itemCount: movies.length,
            itemBuilder: (context, index, pageIndex) {
              Movie movie = movies[index];
              return MovieCardWidget(
                onTapMovieCard: onTapMovieCard,
                movie: movie,
                index: index,
              );
            },
            options: CarouselOptions(
              height: 295,
              autoPlay: false,
              pauseAutoPlayOnTouch: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.45,
              enlargeCenterPage: false,
            ),
          );
  }
}
