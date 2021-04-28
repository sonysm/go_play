import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class HomeFeedCell extends StatelessWidget {
  final VoidCallback? onCellTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onAddCommentTap;

  const HomeFeedCell({
    Key? key,
    this.onCellTap,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onAddCommentTap,
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
                      imageUrl:
                          'https://images.unsplash.com/photo-1581803118522-7b72a50f7e9f?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logan Weaver',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'a day ago',
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
                'Hello crush! Your application code can then handle messages as you see fit; updating local cache, displaying a notification or updating UI. The possibilities are endless!',
                style: Theme.of(context).textTheme.bodyText1,
                onTap: onCellTap,
              ),
            ),
            InkWell(
              onTap: () {},
              child: SizedBox(
                width: double.infinity,
                child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1562552052-c72ceddf93dc?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
              ),
            ),
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(
                    radius: 12.0,
                    imageUrl:
                        'https://images.unsplash.com/photo-1581803118522-7b72a50f7e9f?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'),
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
                        style: TextStyle(color: Colors.blueGrey),
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
