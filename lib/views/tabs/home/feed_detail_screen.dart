import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class FeedDetailScreen extends StatefulWidget {
  static const String tag = '/feedDetailScreen';
  final Post post;

  FeedDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _FeedDetailScreenState createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  TextEditingController _commentController = TextEditingController();

  late User user;

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Post Detail'),
      elevation: 0.5,
      forceElevated: true,
    );
  }

  Widget buildDetailBody() {
    return SliverToBoxAdapter(
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
                    imageUrl: user.photo,
                  ),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.getFullname(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.post.createdAt.toString().timeAgoString,
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
                          size: 22.0,
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
                widget.post.description ?? '',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            widget.post.photo != null
                ? InkWell(
                    onTap: () {},
                    child: SizedBox(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: widget.post.photo!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  ksIconBtn(
                    icon: FeatherIcons.heart,
                    onTap: () {},
                  ),
                  4.width,
                  ksIconBtn(
                    icon: FeatherIcons.messageSquare,
                    onTap: () {},
                  ),
                  4.width,
                  ksIconBtn(
                    icon: FeatherIcons.share2,
                    onTap: () {},
                  ),
                  Spacer(),
                  Text('99 likes'),
                  8.width,
                  Text('27 comments'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomCommentAction() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 8.0),
      color: Theme.of(context).primaryColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.blueGrey[200]!),
              ),
              child: TextField(
                controller: _commentController,
                //focusNode: commentTextNode,
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 6,
                minLines: 1,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Add a comment',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: Colors.blueGrey)),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          CupertinoButton(
            child: _commentController.text.trim().length > 0
                ? Icon(Icons.send, color: mainColor)
                : Text('👍', style: Theme.of(context).textTheme.headline5),
            padding: EdgeInsets.zero,
            onPressed: () {},
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                buildNavbar(),
                buildDetailBody(),
                SliverPadding(padding: EdgeInsets.only(bottom: 120.0)),
              ],
            ),
            Positioned(bottom: 0, child: _bottomCommentAction())
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    user = widget.post.owner;
  }
}
