import 'package:flutter/material.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/models/movie.dart';

import 'custom_cache_image.dart';

class MovieCardWidget extends StatelessWidget {
  const MovieCardWidget({
    Key? key,
    required this.onTapMovieCard,
    required this.movie,
    required this.index,
    this.imgHeight = 220,
  }) : super(key: key);

  final Function onTapMovieCard;
  final Movie movie;
  final int index;
  final double imgHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapMovieCard(index),
      child: Card(
        color: whiteColor,
        borderOnForeground: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: index == 0 ? 0 : 4),
        elevation: 5,
        semanticContainer: true,
        shadowColor: whiteColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              CustomCacheImage(
                imgUrl: movie.backdropPath!,
                height: imgHeight,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 55,
                child: Center(
                  child: Text(
                    movie.title!.toUpperCase(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
