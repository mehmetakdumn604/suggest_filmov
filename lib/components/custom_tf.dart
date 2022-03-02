import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suggest_filmov/const.dart';

class CustomTF extends StatelessWidget {
  const CustomTF({
    Key? key,
    required this.hint,
    required this.label,
    required this.controller,
    this.width,
    this.height,
  }) : super(key: key);
  final String hint, label;
  final double? width, height;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: width,
          height: height == null ? 50.h : height,
          child: TextField(
            controller: controller,
            obscureText: label.contains("Password"),
            keyboardType:
                label.contains("Email") ? TextInputType.emailAddress : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  TextStyle(fontSize: 12.sp, color: blackColor.withOpacity(.5)),
              labelStyle: TextStyle(
                  fontSize: 15.sp,
                  color: blackColor,
                  fontWeight: FontWeight.w700),
              labelText: label,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 26.h,
        ),
      ],
    );
  }
}
