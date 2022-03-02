import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CstmSvgPicture extends StatelessWidget {
  const CstmSvgPicture({
    Key? key,
    required this.svgName,
    this.width,
    this.height,
  }) : super(key: key);
  final String svgName;
  final double? width, height;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "images/$svgName.svg",
      width: width == null ? 50.w : width,
      height: height == null ? 35.h : height,
    );
  }
}
