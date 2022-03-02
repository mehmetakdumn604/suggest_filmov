import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInUpButton extends StatelessWidget {
  const SignInUpButton({
    Key? key,
    required this.btnTxt,
    required this.onPressed,
  }) : super(key: key);
  final String btnTxt;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.w,
      height: 50.h,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: Color(0xff3A5367),
        onPressed: onPressed,
        child: Text(
          btnTxt,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
