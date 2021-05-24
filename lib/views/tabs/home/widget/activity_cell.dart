import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';

class ActivityCell extends StatefulWidget {
  final Post post;

  const ActivityCell({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _ActivityCellState createState() => _ActivityCellState();
}

class _ActivityCellState extends State<ActivityCell> {
  String calcMinuteDuration() {
    var s = DateTime.parse(
        widget.post.activityDate! + ' ' + widget.post.activityStartTime!);
    var e = DateTime.parse(
        widget.post.activityDate! + ' ' + widget.post.activityEndTime!);

    if (e.difference(s).inMinutes == 0) {
      int dur = 24 * 60;
      return '$dur\mn';
    } else if (e.difference(s).isNegative) {
      int dur = (e.add(Duration(days: 1))).difference(s).inMinutes;
      return '$dur\mn';
    }

    int dur = e.difference(s).inMinutes;

    // print('___dur = $dur');

    return '$dur\mn';
  }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Avatar(
                    radius: 18.0,
                    user: widget.post.owner,
                  ),
                  8.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget.post.owner.getFullname(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    widget.post.activityLocation != null
                                        ? TextSpan(
                                            text:
                                                ' added an activity at ${widget.post.activityLocation!.name}.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          )
                                        : TextSpan(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.post.createdAt.toString().timeAgoString,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color: isLight(context)
                                  ? Colors.blueGrey[400]
                                  : Colors.blueGrey[100]),
                        ),
                      ],
                    ),
                  ),
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
            Stack(
              children: [
                widget.post.photo != null
                    ? SizedBox(
                        width: AppSize(context).appWidth(100),
                        height: AppSize(context).appWidth(100),
                        child: CacheImage(url: widget.post.photo!),
                      )
                    : SizedBox(
                        width: AppSize(context).appWidth(100),
                        height: AppSize(context).appWidth(100),
                        child: CacheImage(
                            url: widget.post.sport!.id == 1
                                ? 'https://images.unsplash.com/photo-1589487391730-58f20eb2c308?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1353&q=80'
                                : 'https://images.unsplash.com/photo-1592656094267-764a45160876?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                      ),
                Positioned(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.sport!.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 16.0,
                              color: whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.post.title,
                            style: TextStyle(
                              fontSize: 22.0,
                              color: whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        'Sport',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16.0,
                  bottom: 16.0,
                  child: Row(
                    children: [
                      Icon(Feather.clock, color: whiteColor),
                      4.width,
                      Text(
                        calcMinuteDuration(),
                        style: TextStyle(
                          fontSize: 24.0,
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
                          if (widget.post.reacted!) {
                            widget.post.totalReaction -= 1;
                          } else {
                            widget.post.totalReaction += 1;
                          }
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
                                style: TextStyle(
                                    color: isLight(context)
                                        ? Colors.blueGrey[300]
                                        : Colors.blueGrey[100]),
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
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
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