import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final bool isAvatar;

  const CacheImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.isAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, url) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: url,
                fit: fit,
              ),
            ),
          );
        },
        // useOldImageOnUrlChange: true,
        placeholder: (context, url) => isAvatar
            ? Image.asset('assets/images/user.jpg', fit: fit)
            : Image.asset('assets/images/img_sport_placeholder.png', fit: fit),
        errorWidget: (context, url, error) {
          if (isAvatar) {
            return Image.asset('assets/images/user.jpg', fit: fit);
          }
          return Image.asset('assets/images/img_sport_placeholder.png', fit: fit);
        },
        fadeInDuration: Duration(milliseconds: 200),
        fit: fit,
      );
    } catch (e) {
      print('____ERROR____IN_CACHE_IMAGE : $e');
    }
    return Container();
  }
}
