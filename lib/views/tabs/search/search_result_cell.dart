import 'package:flutter/material.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/widgets/cache_image.dart';

class SearchResultCell extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  const SearchResultCell({Key? key, required this.post, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: post.photo != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              height: AppSize(context).appWidth(27),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: AppSize(context).appWidth(33),
                    height: AppSize(context).appWidth(25),
                    child: CacheImage(url: post.photo!, fit: BoxFit.cover),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            post.description ?? post.title ?? post.externalDesc ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              post.createdAt.toString().timeAgoString,
                              style: Theme.of(context).textTheme.caption?.copyWith(color: ColorResources.getSecondaryText(context)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    post.title ?? post.description ?? '',
                    maxLines: 3,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      post.createdAt.toString().timeAgoString,
                      style: Theme.of(context).textTheme.caption?.copyWith(color: ColorResources.getSecondaryText(context)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
