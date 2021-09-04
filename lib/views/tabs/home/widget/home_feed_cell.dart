import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/bloc/user.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/account/view_user_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/report_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/ks_link_preview.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class HomeFeedCell extends StatefulWidget {
  final Post post;
  final bool isAvatarSelectable;
  final bool isHomeFeed;
  final int index;

  const HomeFeedCell(
      {Key? key,
      required this.post,
      this.isAvatarSelectable = true,
      this.isHomeFeed = true,
      required this.index})
      : super(key: key);

  @override
  _HomeFeedCellState createState() => _HomeFeedCellState();
}

class _HomeFeedCellState extends State<HomeFeedCell>
    with SingleTickerProviderStateMixin {
  String? _url;
  late Post _post;

  KSHttpClient ksClient = KSHttpClient();

  final RegExp urlRegExp = RegExp(
    r"((https?:www\.)|(https?:\/\/)|(www\.))?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?",
    caseSensitive: false,
  );

  final _protocolIdentifierRegex = RegExp(
    r'^(https?:\/\/)',
    caseSensitive: false,
  );

  late HomeCubit _homeCubit;
  late MeetupCubit _meetupCubit;

  late AnimationController controller;
  Animation<double>? animation;

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

    return FadeTransition(
      opacity: animation!,
      child: InkWell(
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
                  children: [
                    Avatar(
                      radius: Dimensions.AVATAR_SIZE_DEFAULT,
                      user: _post.owner,
                      isSelectable: widget.isAvatarSelectable,
                      onTap: (user) {
                        _post.owner = user;
                        setState(() {});
                      },
                    ),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (_post.owner.id != KS.shared.user.id) {
                              var data = await launchScreen(
                                  context, ViewUserProfileScreen.tag,
                                  arguments: {'user': _post.owner});
                              if (data != null) {
                                _post.owner = data;
                                setState(() {});
                              }
                            } else {
                              launchScreen(context, AccountScreen.tag);
                            }
                          },
                          child: Text(_post.owner.getFullname(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Metropolis')),
                        ),
                        Text(
                          _post.createdAt.toString().timeAgoString,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                color: ColorResources.getSecondaryText(context),
                              ),
                          strutStyle:
                              StrutStyle(fontSize: Dimensions.FONT_SIZE_SMALL),
                        ),
                      ],
                    ),
                    Spacer(),
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
                      child: SelectableLinkify(
                        text: _post.description!,
                        style: Theme.of(context).textTheme.bodyText1,
                        strutStyle: StrutStyle(
                          fontSize: 20.0,
                        ),
                        onOpen: (link) async {
                          if (await canLaunch(link.url)) {
                            // await launch(link.url);
                            FlutterWebBrowser.openWebPage(url: link.url);
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                        linkifiers: [UrlLinkifier()],
                        options: LinkifyOptions(looseUrl: true),
                        linkStyle:
                            Theme.of(context).textTheme.bodyText1?.copyWith(
                                  color: isLight(context)
                                      ? Colors.blue
                                      : Colors.grey[100],
                                  decoration: TextDecoration.underline,
                                ),
                      ),
                    )
                  : SizedBox(height: 8.0),
              _post.photo != null && !_post.isExternal
                  ? InkWell(
                      onTap: () => launchFeedDetailScreen(),
                      child: SizedBox(
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: _post.photo!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : SizedBox(),
              _post.image != null && _post.image!.length > 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'See more images',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18.0,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.blueGrey
                                    : whiteColor,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              _post.isExternal ? KSLinkPreview(post: _post) : SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        KSIconButton(
                          icon: _post.reacted!
                              ? Icons.favorite
                              : FeatherIcons.heart,
                          iconColor: _post.reacted!
                              ? ColorResources.getActiveIconColor(context)
                              : ColorResources.getInactiveIconColor(context),
                          onTap: () {
                            _post.reacted = !_post.reacted!;
                            if (_post.reacted!) {
                              _post.totalReaction += 1;
                            } else {
                              _post.totalReaction -= 1;
                            }
                            setState(() {});
                            reactPost(widget.isHomeFeed);
                          },
                        ),
                        4.width,
                        KSIconButton(
                          icon: FeatherIcons.messageSquare,
                          iconColor: ColorResources.getInactiveIconColor(context),
                          onTap: () =>
                              launchFeedDetailScreen(isCommentTap: true),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<UserCubit, User>(
                            builder: (context, user) {
                              return Avatar(
                                radius: Dimensions.AVATAR_SIZE_SMALL,
                                user: user,
                                isSelectable: widget.isAvatarSelectable,
                              );
                            },
                          ),
                          8.width,
                          Expanded(
                            child: InkWell(
                              onTap: () =>
                                  launchFeedDetailScreen(isCommentTap: true),
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
                                    color: ColorResources.getBlueGrey(context),
                                  ),
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
      ),
    );
  }

  void launchFeedDetailScreen({bool isCommentTap = false}) {
    launchScreen(context, FeedDetailScreen.tag, arguments: {
      'post': _post,
      'isCommentTap': isCommentTap,
      'postIndex': widget.index,
      'postCallback': (Post p) {
        setState(() => _post = p);
      }
    });
  }

  void showOptionActionBottomSheet(Post post) {
    showKSBottomSheet(context, children: [
      if (isMe(post.owner.id))
        KSTextButtonBottomSheet(
          title: 'Edit Post',
          icon: LineIcons.edit,
          iconSize: 24.0,
          onTab: () {
            dismissScreen(context);
            launchScreen(context, CreatePostScreen.tag, arguments: post);
          },
        ),
      if (isMe(post.owner.id))
        KSTextButtonBottomSheet(
          title: 'Delete Post',
          icon: LineIcons.trash,
          iconSize: 24.0,
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
          title: 'Hide Post',
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
                    _homeCubit.onUndoHidingPost(
                        index: widget.index, post: post);
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
              message:
                  'Are you sure you want to unfollow ${post.owner.getFullname()}?',
              onYesPressed: () async {
                var res =
                    await ksClient.postApi('/user/unfollow/${post.owner.id}');
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
              message:
                  'Are you sure you want to block ${post.owner.getFullname()}?',
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
          icon: LineIcons.infoCircle,
          iconSize: 24.0,
          onTab: () {
            dismissScreen(context);
            showReportScreen(context);
          },
        ),
    ]);
  }

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

  void reactPost(bool home) async {
    var result = await ksClient.postApi('/create/post/reaction/${_post.id}');
    if (result != null) {
      if (result is! HttpResult) {
        _homeCubit.reactPost(_post.id, _post.reacted!, home: home);
      }
    }
  }

  void checkLinkPreview() {
    if (_post.description == null) {
      return;
    }
    final urlMatches = urlRegExp.allMatches(_post.description!);

    List<String> urls = urlMatches
        .map((urlMatch) =>
            _post.description!.substring(urlMatch.start, urlMatch.end))
        .toList();

    if (urls.isNotEmpty) {
      _url = urls.elementAt(0);

      if (!_url!.startsWith(_protocolIdentifierRegex)) {
        _url =
            (LinkifyOptions().defaultToHttps ? "https://" : "http://") + _url!;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _homeCubit = context.read<HomeCubit>();
    _meetupCubit = context.read<MeetupCubit>();
    _post = widget.post;
    checkLinkPreview();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
