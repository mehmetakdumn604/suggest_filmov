import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/components/custom_cache_image.dart';
import 'package:suggest_filmov/components/movie_card_widget.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/models/movie.dart';
import 'package:suggest_filmov/provider/provider_data.dart';
import 'package:suggest_filmov/screens/home/components/movie_detail/movie_detail_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: getSize(context).width,
        color: blackColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  data.searchMovie = value;
                },
                style: textStyle,
                decoration: InputDecoration(
                  border: outlineInputBorder,
                  filled: true,
                  fillColor: Colors.grey[850],
                  hintText: "Movie Name",
                  focusedBorder: outlineInputBorder,
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white.withOpacity(.7),
                    fontSize: 14,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      data.refres();
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Movie>>(
                  future: apiService.getSearchMovList(data.searchMovie),
                  builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: snapshot.data![0].title == "notfounded"
                            ? Center(
                                child: Text(
                                  "Not found the movie you search",
                                  style: textStyle,
                                ),
                              )
                            : AnimationLimiter(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    Movie movie = snapshot.data![index];
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                        horizontalOffset: 80.0,
                                        child: ListTile(
                                          onTap: () {
                                            /*apiService
                                              .getRecommendations(movie.id!)
                                              .then((value) {
                                            value.forEach(
                                              (element) {
                                                print(element.title);
                                              },
                                            );
                                          });*/
                                            FocusScope.of(context).unfocus();
                                            data.loaded = false;
                                            apiService
                                                .getYoutubeId(movie.id!)
                                                .then((value) {
                                              data.youtubeId = value;
                                              data.controller =
                                                  YoutubePlayerController(
                                                initialVideoId: data.youtubeId,
                                                flags: YoutubePlayerFlags(
                                                  autoPlay: false,
                                                  mute: false,
                                                  isLive: false,
                                                ),
                                              );
                                              data.loaded = true;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MovieDetailPage(
                                                      data: data,
                                                      movie: movie,
                                                      type: "search",
                                                    ),
                                                  ));
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          leading: ClipOval(
                                              child: CustomCacheImage(
                                            imgUrl: movie.backdropPath ?? "",
                                            width: 50,
                                            height: 50,
                                          )),
                                          title: Text(
                                            movie.title ?? "Not found name",
                                            style: textStyle,
                                          ),
                                          subtitle: Text(
                                            movie.voteAverage.toString() +
                                                " / 10 \t Vote Count : " +
                                                movie.voteCount.toString(),
                                            style: textStyle.copyWith(
                                                fontSize: 14),
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.favorite),
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      );
                    }
                    return Expanded(
                      child: data.discoverMovies.isEmpty
                          ? Center(
                              child: customLoading,
                            )
                          : AnimationLimiter(
                              child: GridView.builder(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: data.discoverMovies.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    child: SlideAnimation(
                                      horizontalOffset: 200,
                                      child: MovieCardWidget(
                                        imgHeight: 125,
                                        onTapMovieCard: () {},
                                        movie: data.discoverMovies[index],
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
