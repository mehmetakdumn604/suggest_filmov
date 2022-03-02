import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suggest_filmov/const.dart';

class ButtonBg extends StatelessWidget {
  const ButtonBg({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: loginButtonBg,
      ),
      child: Center(child: child),
    );
  }
}
