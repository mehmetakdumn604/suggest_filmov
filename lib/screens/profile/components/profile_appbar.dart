import 'package:flutter/material.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';
import 'package:suggest_filmov/const.dart';

class ProfileAppbar extends StatelessWidget {
  const ProfileAppbar({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function  onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 30),
        SizedBox(
          width: 250,
          child: Text(
            "Profile",
            style:
                textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: () {
            onPressed();
          },
          icon: Icon(
            Icons.exit_to_app,
            color: redColor,
          ),
        ),
      ],
    );
  }
}
