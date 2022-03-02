import 'package:flutter/material.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';

class FollowInfoWidgets extends StatelessWidget {
  const FollowInfoWidgets({
    Key? key,
    required this.followerCount,
    required this.followedCount,
    required this.integralCount,
  }) : super(key: key);

  final int followerCount, followedCount, integralCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            "$followerCount \nFollowers ",
            style:
                textStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 100,
          child: Text(
            "$followedCount \nFollower ",
            style:
                textStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 100,
          child: Text(
            "$integralCount \nIntegral ",
            style:
                textStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
