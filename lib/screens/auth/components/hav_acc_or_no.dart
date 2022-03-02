import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suggest_filmov/const.dart';

class HaveAccOrNo extends StatelessWidget {
  const HaveAccOrNo(
      {Key? key,
      required this.goToSignIn,
      required this.txt,
      required this.btnTxt})
      : super(key: key);

  final VoidCallback goToSignIn;
  final String txt, btnTxt;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          txt,
          style: TextStyle(
            color: blackColor,
            fontSize: 12.sp,
          ),
        ),
        TextButton(
            onPressed: goToSignIn,
            child: Text(
              btnTxt,
              style: TextStyle(
                color: blackColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ))
      ],
    );
  }
}
