import 'package:flutter/material.dart';
import 'package:suggest_filmov/const.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);
  final Widget icon;
  final Function? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: blackColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        splashRadius: 28,
        splashColor: whiteColor,
        onPressed: () {
          if (onPressed == null) {
            Navigator.pop(context);
          } else {
            onPressed!();
          }
        },
        icon: icon,
      ),
    );
  }
}
