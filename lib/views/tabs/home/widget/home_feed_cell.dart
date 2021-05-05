import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class HomeFeedCell extends StatelessWidget {
  final VoidCallback? onCellTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onAddCommentTap;
  final Post post;

  const HomeFeedCell({
    Key? key,
    this.onCellTap,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onAddCommentTap,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCellTap,
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8.0),
              child: Row(
                children: [
                  Avatar(
                    radius: 18.0,
                    imageUrl: post.owner.photo,
                  ),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.owner.getFullname(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        post.createdAt.toString().timeAgoString,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.blueGrey[200]),
                      ),
                    ],
                  ),
                  Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          FeatherIcons.moreHorizontal,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: SelectableText(
                post.description ?? '',
                style: Theme.of(context).textTheme.bodyText1,
                onTap: onCellTap,
              ),
            ),
            post.photo != null
                ? InkWell(
                    onTap: onCellTap,
                    child: SizedBox(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: post.photo!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SizedBox(),
            /*post.photo != null
                ? Expanded(
                    child: Swiper(
                      itemCount: post.image!.length,
                      outer: true,
                      itemBuilder: (context, index) => Container(
                        width: MediaQuery.of(context).size.width,
                        child: CacheImage(
                          url: post.image![index].name,
                        ),
                      ),
                      curve: Curves.easeInOutCubic,
                      //autoplay: post.image!.isEmpty ? false : true,
                      loop: false,
                      // autoplayDelay: 5000,
                      // duration: 850,
                      pagination: post.image!.length > 1
                          ? SwiperPagination(
                              builder: DotSwiperPaginationBuilder(
                                activeColor: mainColor,
                                color: Colors.grey[100],
                                size: 8.0,
                                activeSize: 8.0,
                              ),
                            )
                          : null,

                      onTap: (index) {},
                    ),
                  )
                : SizedBox(),*/
            HFButtomAction(
              onLikeTap: onLikeTap,
              onCommentTap: onCommentTap,
              onShareTap: onShareTap,
              onAddCommentTap: onAddCommentTap,
            ),
          ],
        ),
      ),
    );
  }
}

class HFButtomAction extends StatefulWidget {
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onAddCommentTap;
  const HFButtomAction({
    Key? key,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onAddCommentTap,
  }) : super(key: key);

  @override
  _HFButtomActionState createState() => _HFButtomActionState();
}

class _HFButtomActionState extends State<HFButtomAction> {
  bool isLike = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              ksIconBtn(
                icon: isLike ? Icons.favorite : FeatherIcons.heart,
                iconColor: isLike ? mainColor : Colors.blueGrey,
                onTap: () {
                  widget.onLikeTap();
                  setState(() => isLike = !isLike);
                },
              ),
              4.width,
              ksIconBtn(
                icon: FeatherIcons.messageSquare,
                onTap: widget.onCommentTap,
              ),
              4.width,
              ksIconBtn(
                icon: FeatherIcons.share2,
                onTap: widget.onShareTap,
              ),
              Spacer(),
              Text('99 likes'),
              8.width,
              Text('27 comments'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(
                    radius: 12.0,
                    imageUrl: KS.shared.user.photo),
                8.width,
                Expanded(
                  child: InkWell(
                    onTap: widget.onAddCommentTap,
                    child: Container(
                      height: 32.0,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0XFFB0BEC5)),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add a comment',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
