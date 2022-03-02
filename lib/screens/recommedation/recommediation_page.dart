import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/models/movie.dart';

import '../../provider/provider_data.dart';
import 'components/rect_list.dart';

class RecommediationPage extends StatelessWidget {
  const RecommediationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: blackColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Recommendations For You",
              style: textStyle,
            ),
            bottom: TabBar(
              labelColor: whiteColor,
              tabs: [
                Tab(
                  text: "Movies",
                ),
                Tab(
                  text: "Films",
                ),
              ],
            ),
          ),
          body: Container(
            width: getSize(context).width,
            height: getSize(context).height,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  FutureBuilder<List<Movie>>(
                      future: apiService
                          .getRecommendations(data.latestMovies.first.id!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data![0].title == "notfounded"
                              ? Center(
                                  child: Text(
                                    "Movie not found",
                                    style: textStyle,
                                  ),
                                )
                              : RecListview(
                                  snapshot: snapshot,
                                  type: "rec",
                                );
                        }

                        return Center(
                          child: customLoading,
                        );
                      }),
                  FutureBuilder<List<Movie>>(
                      future: apiService.getRecommendations(
                          data.latestMovies.first.id!,
                          isMovie: false),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data![0].title == "notfounded"
                              ? Center(
                                  child: Text(
                                    "Movie not found",
                                    style: textStyle,
                                  ),
                                )
                              : RecListview(
                                  snapshot: snapshot,
                                  type: "rec",
                                );
                        }

                        return Center(
                          child: customLoading,
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
