import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/components/custom_cache_image.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';
import 'package:suggest_filmov/const.dart';

import '../../../models/movie.dart';
import '../../../provider/provider_data.dart';
import 'movie_detail/movie_detail_page.dart';

class MovieCardWthName extends StatelessWidget {
  const MovieCardWthName({
    Key? key,
    required this.simMov,
    required this.type,
  }) : super(key: key);

  final Movie simMov;
  final String type;
  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return GestureDetector(
      onTap: () {
        goTo(
            context,
            MovieDetailPage(
              data: data,
              movie: simMov,
              type: type,
            ));
      },
      child: Column(
        children: [
          Hero(
            tag: simMov.id.toString() + type,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomCacheImage(
                height: 150.h,
                width: 120,
                imgUrl: simMov.backdropPath ?? "",
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          FittedBox(
            child: SizedBox(
              width: 120,
              child: Text(
                simMov.title ?? "",
                style: textStyle.copyWith(
                  color: whiteColor,
                  fontSize: 16,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
