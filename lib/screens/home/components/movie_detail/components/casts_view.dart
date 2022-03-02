import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../components/custom_cache_image.dart';
import '../../../../../components/utility_funcs.dart';
import '../../../../../const.dart';
import '../../../../../models/cast_list.dart';
import '../../../../../models/movie.dart';
import '../../../home_screen.dart';

class CastsView extends StatelessWidget {
  const CastsView({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: apiService.getCastList(movie.id!),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 240.h,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TitleCard(
                      title: "CAST LISTS",
                      color: Colors.pinkAccent,
                      txtColor: yellowColor,
                    ),
                  ),
                  Expanded(
                    child: snapshot.data.isEmpty
                        ? Center(
                            child: Text(
                              "Couldn't find cast. Sorry...",
                              style: textStyle,
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              Cast cast = snapshot.data[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CustomCacheImage(
                                        width: 120,
                                        height: 150,
                                        imgUrl: cast.profilePath,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FittedBox(
                                            child: Text(
                                              cast.name,
                                              style: textStyle.copyWith(
                                                color: whiteColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            cast.character,
                                            style: textStyle.copyWith(
                                              color: yellowColor,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: customLoading,
          );
        });
  }
}
