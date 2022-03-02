import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/components/custom_cache_image.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/models/movie.dart';
import 'package:suggest_filmov/provider/provider_data.dart';
import 'package:suggest_filmov/screens/home/components/all_movies.dart';
import 'package:suggest_filmov/screens/home/components/movie_detail/movie_detail_page.dart';
import 'package:suggest_filmov/services/firebase_service.dart';

import 'components/photo_name_widget.dart';
import 'components/profile_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileAppbar(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        "Are you sure you want to exit from your account?",
                        style: textStyle.copyWith(
                          color: blackColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.spaceAround,
                      actions: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: blueColor.withOpacity(.5),
                          onPressed: () {
                            AuthService.signOut(context);
                          },
                          child: Text(
                            "Yes",
                            style: textStyle.copyWith(
                              color: blackColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: blueColor.withOpacity(.5),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "No",
                            style: textStyle.copyWith(
                              color: blackColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              PhotoNameWidget(),
              const SizedBox(height: 20),
              MyListWidget(
                leftIcon: Icon(
                  Icons.watch_later_outlined,
                  color: redColor,
                ),
                rigthIcon: IconButton(
                  onPressed: () {
                    goTo(
                      context,
                      AllMovies(
                        movies: data.watchList,
                        movieType: MovieType.none,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: whiteColor,
                  ),
                ),
                movies: data.watchList,
                title: "My Watch List",
                type: "watch",
              ),
              MyListWidget(
                leftIcon: Icon(
                  Icons.favorite_rounded,
                  color: redColor,
                ),
                rigthIcon: IconButton(
                  onPressed: () {
                    goTo(
                        context,
                        AllMovies(
                          movies: data.favList,
                          movieType: MovieType.none,
                        ));
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: whiteColor,
                  ),
                ),
                movies: data.favList,
                title: "My Favorite List",
                type: "fav",
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyListWidget extends StatelessWidget {
  const MyListWidget({
    Key? key,
    required this.leftIcon,
    required this.rigthIcon,
    required this.title,
    required this.movies,
    this.type,
  }) : super(key: key);

  final Widget leftIcon, rigthIcon;
  final String title;
  final List<Movie> movies;
  final String? type;

  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return SizedBox(
      width: getSize(context).width,
      height: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                leftIcon,
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: textStyle,
                ),
                const Spacer(),
                rigthIcon,
              ],
            ),
          ),
          Expanded(
            child: movies.isEmpty
                ? Center(
                    child: Text(
                      "Any Movie here. Add new.",
                      style: textStyle,
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: movies.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Movie movie = movies[index];
                      return GestureDetector(
                        onTap: () {
                          goTo(
                              context,
                              MovieDetailPage(
                                data: data,
                                movie: movie,
                                type: type,
                              ));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: index == 0 ? 16 : 12, vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Hero(
                                tag: movie.id.toString() + (type ?? ""),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CustomCacheImage(
                                    imgUrl: movie.backdropPath!,
                                    width: 150,
                                    height: 150,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 120,
                                height: 70,
                                child: Text(
                                  movie.title!.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
