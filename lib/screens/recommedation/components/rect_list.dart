import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_cache_image.dart';
import '../../../components/utility_funcs.dart';
import '../../../const.dart';
import '../../../models/movie.dart';
import '../../../provider/provider_data.dart';
import '../../../services/sql_service.dart';
import '../../home/components/movie_detail/movie_detail_page.dart';

class RecListview extends StatelessWidget {
  const RecListview({Key? key, required this.snapshot, required this.type})
      : super(key: key);
  final AsyncSnapshot<List<Movie>> snapshot;
  final String type;
  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        Movie movie = snapshot.data![index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 85,
            child: ListTile(
              focusColor: Colors.pinkAccent,
              hoverColor: Colors.pinkAccent,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onTap: () {
                goTo(
                    context,
                    MovieDetailPage(
                      data: data,
                      movie: movie,
                      type: type,
                    ));
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              leading: Hero(
                tag: movie.id.toString() + type,
                child: ClipOval(
                    child: CustomCacheImage(
                  imgUrl: movie.backdropPath ?? "",
                  width: 50,
                  height: 50,
                )),
              ),
              title: Text(
                movie.title ?? "title",
                style: textStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Text(
                movie.voteAverage.toString() +
                    " / 10 \t Vote Count : " +
                    movie.voteCount.toString(),
                style: textStyle.copyWith(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              trailing: GestureDetector(
                onTap: () {
                  favOperations(data, movie);
                },
                child: data.favList.map((e) => e.id).toList().contains(movie.id)
                    ? Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                        size: 26,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  void favOperations(ProviderData data, Movie movie) async {
    if (data.favList.map((e) => e.id).toList().contains(movie.id)) {
      data.removeMovieToFavList(movie);
      await SqlService.instance.delete(movie.id!, favTable);
    } else {
      data.addMovieToFavList(movie);
      await SqlService.instance.insert(movie, favTable);
    }
  }
}
