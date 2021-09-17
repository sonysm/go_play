import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/bloc/user.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/report_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:line_icons/line_icons.dart';

class ActivityCell extends StatefulWidget {
  final Post post;
  final int index;
  final bool isAvatarSelectable;
  final bool isHomeFeed;

  const ActivityCell({Key? key, required this.index, required this.post, this.isAvatarSelectable = true, this.isHomeFeed = true}) : super(key: key);

  @override
  _ActivityCellState createState() => _ActivityCellState();
}

class _ActivityCellState extends State<ActivityCell> {
  late Post _post;

  late HomeCubit _homeCubit;
  late MeetupCubit _meetupCubit;

  String calcMinuteDuration() {
    var s = DateTime.parse(_post.activityDate! + ' ' + _post.activityStartTime!);
    var e = DateTime.parse(_post.activityDate! + ' ' + _post.activityEndTime!);

    if (e.difference(s).inMinutes == 0) {
      int dur = 24 * 60;
      return '$dur\mn';
    } else if (e.difference(s).isNegative) {
      int dur = (e.add(Duration(days: 1))).difference(s).inMinutes;
      return '$dur\mn';
    }

    int dur = e.difference(s).inMinutes;

    return '$dur\mn';
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTotalReaction(int total) {
      return total > 0 ? Text(total > 1 ? '$total likes' : '$total like') : SizedBox();
    }

    Widget buildTotalComment(int total) {
      return total > 0 ? Text(total > 1 ? '$total comments' : '$total comment') : SizedBox();
    }

    return InkWell(
      onTap: () => launchFeedDetailScreen(),
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
                    user: _post.owner,
                    isSelectable: widget.isAvatarSelectable,
                    onTap: (user) {
                      _post.owner = user;
                      setState(() {});
                    },
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
                                      text: _post.owner.getFullname(),
                                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    _post.activityLocation != null
                                        ? TextSpan(
                                            text: ' added an activity at ${_post.activityLocation!.name}.',
                                            style: Theme.of(context).textTheme.bodyText1,
                                          )
                                        : TextSpan(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _post.createdAt.toString().timeAgoString,
                          style: Theme.of(context).textTheme.caption!.copyWith(color: isLight(context) ? Colors.blueGrey[400] : Colors.blueGrey[100]),
                        ),
                      ],
                    ),
                  ),
                  KSIconButton(
                    icon: FeatherIcons.moreHorizontal,
                    iconSize: 24.0,
                    onTap: () => showOptionActionBottomSheet(_post),
                  ),
                ],
              ),
            ),
            _post.description != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: SelectableText(
                      _post.description!,
                      style: Theme.of(context).textTheme.bodyText1,
                      onTap: () => launchFeedDetailScreen(),
                    ),
                  )
                : SizedBox(height: 8.0),
            Stack(
              children: [
                _post.photo != null
                    ? SizedBox(
                        width: AppSize(context).appWidth(100),
                        child: CachedNetworkImage(
                          imageUrl: _post.photo!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : SizedBox(
                        width: AppSize(context).appWidth(100),
                        height: AppSize(context).appWidth(100),
                        child: CacheImage(
                            url: _post.sport!.id == 1
                                ? 'https://images.unsplash.com/photo-1589487391730-58f20eb2c308?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1353&q=80'
                                : 'https://images.unsplash.com/photo-1592656094267-764a45160876?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                      ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 26.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black87,
                          Color(0x00000000),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: AppSize(context).appWidth(60),
                          child: Text(
                            _post.title,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: whiteColor,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        4.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _post.sport!.name.toUpperCase(),
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Feather.clock,
                                  color: whiteColor,
                                  size: 18.0,
                                ),
                                4.width,
                                Text(
                                  calcMinuteDuration(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  strutStyle: StrutStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24, child: Image.asset(imgVplayText)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      KSIconButton(
                        icon: _post.reacted! ? Icons.favorite : FeatherIcons.heart,
                        iconColor: Theme.of(context).brightness == Brightness.light
                            ? _post.reacted!
                                ? Colors.green
                                : Colors.blueGrey
                            : _post.reacted!
                                ? Colors.green
                                : Colors.white,
                        onTap: () {
                          if (_post.reacted!) {
                            _post.totalReaction -= 1;
                          } else {
                            _post.totalReaction += 1;
                          }
                          setState(() {
                            _post.reacted = !_post.reacted!;
                          });
                          reactPost();
                        },
                      ),
                      4.width,
                      KSIconButton(
                        icon: FeatherIcons.messageSquare,
                        iconColor: ColorResources.getInactiveIconColor(context),
                        onTap: () => launchFeedDetailScreen(isCommentTap: true),
                      ),
                      // 4.width,
                      // KSIconButton(
                      //   icon: FeatherIcons.share2,
                      //   onTap: () {},
                      // ),
                      Spacer(),
                      buildTotalReaction(_post.totalReaction),
                      8.width,
                      buildTotalComment(_post.totalComment),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<UserCubit, User>(
                          builder: (context, user) {
                            return Avatar(
                              radius: 12.0,
                              user: user,
                              isSelectable: widget.isAvatarSelectable,
                            );
                          },
                        ),
                        8.width,
                        Expanded(
                          child: InkWell(
                            onTap: () => launchFeedDetailScreen(isCommentTap: true),
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
                                style: TextStyle(color: isLight(context) ? Colors.blueGrey[300] : Colors.blueGrey[100]),
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

  @override
  void initState() {
    super.initState();
    _homeCubit = context.read<HomeCubit>();
    _meetupCubit = context.read<MeetupCubit>();
    _post = widget.post;
  }

  void launchFeedDetailScreen({bool isCommentTap = false}) async {
    launchScreen(context, FeedDetailScreen.tag, arguments: {
      'post': _post,
      'postIndex': widget.index,
      'isCommentTap': isCommentTap,
      'postCallback': (Post p) {
        setState(() => _post = p);
      }
    });
  }

  void showOptionActionBottomSheet(Post post) {
    showKSBottomSheet(context, children: [
      if (isMe(post.owner.id))
        KSTextButtonBottomSheet(
          title: 'Delete Post',
          icon: Feather.trash_2,
          onTab: () {
            dismissScreen(context);
            showKSConfirmDialog(
              context,
              message: 'Are you sure you want to delete this post?',
              onYesPressed: () {
                deletePost(post.id);
              },
            );
          },
        ),
      if (!isMe(post.owner.id) && widget.isHomeFeed) ...[
        KSTextButtonBottomSheet(
          title: 'Hide Activity',
          icon: LineIcons.minusCircle,
          iconSize: 24.0,
          onTab: () {
            dismissScreen(context);
            showKSConfirmDialog(
              context,
              message: 'Are you sure you want to hide this post?',
              onYesPressed: () {
                _homeCubit.onHidePost(post.id);
                showKSSnackBar(
                  context,
                  title: 'This post is no longer show to you.',
                  action: true,
                  actionTitle: 'Undo',
                  onAction: () {
                    _homeCubit.onUndoHidingPost(index: widget.index, post: post);
                  },
                );
              },
            );
          },
        ),
        KSTextButtonBottomSheet(
          title: 'Unfollow ${post.owner.getFullname()}',
          icon: LineIcons.userMinus,
          iconSize: 24.0,
          onTab: () {
            dismissScreen(context);
            showKSConfirmDialog(
              context,
              message: 'Are you sure you want to unfollow ${post.owner.getFullname()}?',
              onYesPressed: () async {
                var res = await ksClient.postApi('/user/unfollow/${post.owner.id}');
                if (res != null) {
                  if (res is! HttpResult) {}
                }
              },
            );
          },
        ),
        KSTextButtonBottomSheet(
          title: 'Block ${post.owner.getFullname()}',
          icon: LineIcons.ban,
          iconSize: 24.0,
          onTab: () {
            dismissScreen(context);
            showKSConfirmDialog(
              context,
              message: 'Are you sure you want to block ${post.owner.getFullname()}?',
              onYesPressed: () {
                showKSLoading(context);
                Future.delayed(Duration(seconds: 1), () {
                  _homeCubit.onBlockUser(post.owner.id);
                  _meetupCubit.onBlockUser(post.owner.id);
                  dismissScreen(context);
                });
              },
            );
          },
        ),
      ],
      if (!isMe(post.owner.id))
        KSTextButtonBottomSheet(
          title: 'Report Post',
          icon: Feather.info,
          onTab: () {
            dismissScreen(context);
            showReportScreen(context);
          },
        ),
    ]);
  }

  KSHttpClient ksClient = KSHttpClient();

  void deletePost(int postId) async {
    showKSLoading(context);
    var result = await ksClient.postApi('/delete/post/$postId');
    if (result != null) {
      await Future.delayed(Duration(milliseconds: 500));
      dismissScreen(context);
      if (result is! HttpResult) {
        _homeCubit.onDeletePostFeed(postId);
      }
    }
  }

  void reactPost() async {
    var result = await ksClient.postApi('/create/post/reaction/${_post.id}');
    if (result != null) {
      if (result is! HttpResult) {
        print('success!!!!');
      }
    }
  }
}
