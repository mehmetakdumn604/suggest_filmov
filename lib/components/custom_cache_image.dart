import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';

class CustomCacheImage extends StatelessWidget {
  const CustomCacheImage(
      {Key? key, this.width, this.height, required this.imgUrl})
      : super(key: key);

  final double? width;
  final double? height;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      filterQuality: FilterQuality.high,
      maxHeightDiskCache: 280,
      imageUrl: imgUrl.contains("https://")
          ? imgUrl
          : "https://image.tmdb.org/t/p/original/$imgUrl",
      fit: BoxFit.fill,
      width: width != null ? width : getSize(context).width,
      height: height != null ? height : 280,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        direction: ShimmerDirection.ltr,
        child: Container(
          width: width != null ? width : getSize(context).width,
          height: height != null ? height : getSize(context).height / 3,
          color: Colors.grey.withOpacity(.6),
        ),
      ),
      errorWidget: (BuildContext context, String txt, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            "images/noImage.jpg",
            fit: BoxFit.fill,
            width: width != null ? width : getSize(context).width,
            height: height != null ? height : 280,
          ),
        );
      },
    );
  }
}
