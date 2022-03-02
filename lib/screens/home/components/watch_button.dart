import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suggest_filmov/const.dart';

class WatchButton extends StatelessWidget {
  const WatchButton({
    Key? key,
    required this.playTrailler,
  }) : super(key: key);
  final VoidCallback playTrailler;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: MaterialButton(
          minWidth: 170.w,
          height: 40.h,
          color: Color(0xff493479),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onPressed: playTrailler,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Watch Trailer",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.play_arrow_outlined,
                color: Colors.yellow.shade700,
                size: 28,
              )
            ],
          ),
        ),
      ),
    );
  }
}
