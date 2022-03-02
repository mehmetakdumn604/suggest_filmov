import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/components/custom_cache_image.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';

import '../../../provider/provider_data.dart';

class PhotoNameWidget extends StatelessWidget {
  const PhotoNameWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            data.uploadProfile().whenComplete(() => data.refres());
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomCacheImage(
              imgUrl: data.url,
              height: 100,
              width: 100,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 250,
          child: Text(
            data.currUser.name,
            style:
                textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 250,
          child: Text(
            "Bio : ${data.currUser.bio}",
            style:
                textStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        /* FollowInfoWidgets(
          followedCount: 0,
          followerCount: 0,
          integralCount: 0,
        )*/
      ],
    );
  }
}
