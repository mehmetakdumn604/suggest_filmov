import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../components/utility_funcs.dart';
import '../../../../../const.dart';
import '../../../../../models/movie.dart';
import '../../../home_screen.dart';
import '../../movie_card_wth_name.dart';

class SimilarMoviesView extends StatelessWidget {
  const SimilarMoviesView({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: apiService.getSimilarMovies(movie.id!),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: SizedBox(
                height: 240.h,
                child: Column(
                  children: [
                    TitleCard(
                      title: "YOU MUST ALSO LIKES",
                      color: Colors.pinkAccent,
                      txtColor: yellowColor,
                      movies: snapshot.data,
                      movieType: MovieType.similar,
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Movie simMov = snapshot.data[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MovieCardWthName(simMov: simMov,type: "sim",),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: customLoading,
          );
        });
  }
}
