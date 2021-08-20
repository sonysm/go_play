import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final ImageErrorType type;

  const CacheImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.type = ImageErrorType.normal,
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
        placeholder: (context, url) {
          switch (type) {
            case ImageErrorType.user:
              return Image.asset('assets/images/user.jpg', fit: fit);
            default:
              return Image.asset('assets/images/img_sport_placeholder.png',
                  fit: fit);
          }
        },
        errorWidget: (context, url, error) {
          switch (type) {
            case ImageErrorType.user:
              return Image.asset('assets/images/user.jpg', fit: fit);
            case ImageErrorType.venue:
              return CachedNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1487466365202-1afdb86c764e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1052&q=80',
                fit: BoxFit.cover,
              );
            default:
              return Image.asset('assets/images/img_sport_placeholder.png',
                  fit: fit);
          }
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

enum ImageErrorType { normal, user, venue }
