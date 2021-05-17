import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';

class HomeFeedCell extends StatefulWidget {
  final Post post;

  const HomeFeedCell({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _HomeFeedCellState createState() => _HomeFeedCellState();
}

class _HomeFeedCellState extends State<HomeFeedCell> {
  @override
  Widget build(BuildContext context) {
    Widget buildTotalReaction(int total) {
      return total > 0
          ? Text(total > 1 ? '$total likes' : '$total like')
          : SizedBox();
    }

    Widget buildTotalComment(int total) {
      return total > 0
          ? Text(total > 1 ? '$total comments' : '$total comment')
          : SizedBox();
    }

    return InkWell(
      onTap: () => launchFeedDetailScreen(widget.post),
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
                    user: widget.post.owner,
                  ),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.owner.getFullname(),
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
                  KSIconButton(
                    icon: FeatherIcons.moreHorizontal,
                    iconSize: 24.0,
                    onTap: () => showOptionActionBottomSheet(widget.post),
                  ),
                ],
              ),
            ),
            widget.post.description != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: SelectableText(
                      widget.post.description!,
                      style: Theme.of(context).textTheme.bodyText1,
                      onTap: () => launchFeedDetailScreen(widget.post),
                    ),
                  )
                : SizedBox(height: 8.0),
            widget.post.photo != null
                ? InkWell(
                    onTap: () => launchFeedDetailScreen(widget.post),
                    child: SizedBox(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: widget.post.photo!,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      KSIconButton(
                        icon: widget.post.reacted!
                            ? Icons.favorite
                            : FeatherIcons.heart,
                        iconColor:
                            Theme.of(context).brightness == Brightness.light
                                ? widget.post.reacted!
                                    ? Colors.green
                                    : Colors.blueGrey
                                : widget.post.reacted!
                                    ? Colors.green
                                    : Colors.white,
                        onTap: () {
                          setState(() {
                            widget.post.reacted = !widget.post.reacted!;
                            reactPost();
                          });
                        },
                      ),
                      4.width,
                      KSIconButton(
                        icon: FeatherIcons.messageSquare,
                        onTap: () => launchFeedDetailScreen(widget.post, true),
                      ),
                      4.width,
                      KSIconButton(
                        icon: FeatherIcons.share2,
                        onTap: () {},
                      ),
                      Spacer(),
                      buildTotalReaction(widget.post.totalReaction),
                      8.width,
                      buildTotalComment(widget.post.totalComment),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Avatar(
                          radius: 12.0,
                          user: KS.shared.user,
                        ),
                        8.width,
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                launchFeedDetailScreen(widget.post, true),
                            child: Container(
                              height: 32.0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
            ),
          ],
        ),
      ),
    );
  }

  void launchFeedDetailScreen(Post post, [bool isCommentTap = false]) async {
    var p = await launchScreen(context, FeedDetailScreen.tag,
        arguments: {'post': post, 'isCommentTap': isCommentTap}) as Post;
    setState(() => widget.post.reacted = p.reacted);
  }

  void showOptionActionBottomSheet(Post post) {
    showModalBottomSheet(
      context: context,
      //backgroundColor: Colors.transparent,
      //shape: RoundedRectangleBorder(
      //  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      //),
      builder: (context) {
        return SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isMe(post.owner.id)
                    ? TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 0.0)),
                        ),
                        onPressed: () {
                          dismissScreen(context);
                          showKSConfirmDialog(context,
                              'Are you sure you want to delete this post?', () {
                            deletePost(post.id);
                          });
                        },
                        child: Container(
                          height: 54.0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 16.0, right: 16.0),
                                child: Icon(
                                  Feather.trash_2,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.blueGrey
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                'Delete Post',
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 0.0)),
                  ),
                  onPressed: () {
                    dismissScreen(context);
                  },
                  child: Container(
                    height: 54.0,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Icon(
                            Feather.info,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.blueGrey
                                    : Colors.white,
                          ),
                        ),
                        Text(
                          'Report Post',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  KSHttpClient ksClient = KSHttpClient();

  void deletePost(int postId) async {
    showKSLoading(context);
    var result = await ksClient.postApi('/delete/post/$postId');
    if (result != null) {
      await Future.delayed(Duration(milliseconds: 500));
      dismissScreen(context);
      if (result is! HttpResult) {
        BlocProvider.of<HomeCubit>(context).onDeletePostFeed(postId);
      }
    }
  }

  void reactPost() async {
    var result =
        await ksClient.postApi('/create/post/reaction/${widget.post.id}');
    if (result != null) {
      if (result is! HttpResult) {
        print('success!!!!');
      }
    }
  }
}
