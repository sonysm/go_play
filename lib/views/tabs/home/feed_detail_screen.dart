import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/comment.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/capture.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/account/view_user_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/report_screen.dart';
import 'package:kroma_sport/views/tabs/home/share_feed_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/comment_cell.dart';
import 'package:kroma_sport/views/tabs/home/widget/ks_link_preview.dart';
import 'package:kroma_sport/views/tabs/home/widget/photo_view_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

typedef FeedCallback = void Function(Post);

class FeedDetailScreen extends StatefulWidget {
  static const String tag = '/feedDetailScreen';
  final Post post;
  final bool isCommentTap;
  final int postIndex;
  final FeedCallback? postCallback;

  FeedDetailScreen({
    Key? key,
    required this.post,
    required this.postIndex,
    this.isCommentTap = false,
    this.postCallback,
  }) : super(key: key);

  @override
  _FeedDetailScreenState createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  TextEditingController _commentController = TextEditingController();
  FocusNode _commentTextNode = FocusNode();
  ScrollController _scrollController = ScrollController();
  KSHttpClient ksClient = KSHttpClient();

  late Post post;
  late HomeCubit _homeCubit;

  List<Comment> commentList = [];

  List<User> likeUsers = [];

  Size? imageSize;

  var selectedIndex = 0;
  PageController pageController = PageController();

  PhotoViewController photoViewController = PhotoViewController();
  PhotoViewScaleStateController scaleStateController =
      PhotoViewScaleStateController();
  var state;

  GlobalKey captureKey = GlobalKey();

  Uint8List? uImage;

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Post Detail'),
      elevation: 0.3,
      forceElevated: true,
      pinned: true,
      titleSpacing: 0,
      titleTextStyle: Theme.of(context)
          .textTheme
          .headline6
          ?.copyWith(fontWeight: FontWeight.w400),
      actions: [
        if (post.type != PostType.feed || post.owner.id == KS.shared.user.id)
          CupertinoButton(
              onPressed: () async {
                if (uImage == null)
                  uImage = await Capture.toPngByte(captureKey);

                if (uImage != null) {
                  _showShareScreen();
                }
              },
              padding: EdgeInsets.zero,
              child: Icon(Icons.share,
                  color: isLight(context) ? Colors.grey[600] : whiteColor)),
      ],
    );
  }

  _showShareScreen() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        useRootNavigator: true,
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.9),
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ShareFeedScreen(
                image: uImage,
                post: post,
              ));
        });
  }

  Widget buildTotalReaction(int total) {
    return total > 0
        ? TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.grey[100]),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: MaterialStateProperty.all(Size(0, 0)),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                    vertical: 4.0, horizontal: 8.0))),
            onPressed: showUserLike,
            child: Text(
              total > 1 ? '$total likes' : '$total like',
              style: Theme.of(context).textTheme.bodyText2,
            ))
        : SizedBox();
  }

  Widget buildTotalComment(int total) {
    return total > 0
        ? Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(total > 1 ? '$total comments' : '$total comment'),
          )
        : SizedBox();
  }

  Widget buildDetailBody() {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                      child: Row(
                        children: [
                          Avatar(
                            radius: 18.0,
                            user: post.owner,
                            onTap: (u) {},
                          ),
                          8.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: post.owner.getFullname() + " ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                  children: [
                                    if (post.owner.isPublic)
                                      WidgetSpan(
                                        child: SvgPicture.asset(
                                            svgCheckVerified,
                                            width: 18),
                                      )
                                  ],
                                ),
                                strutStyle: StrutStyle(height: 1.5),
                              ),
                              Text(
                                post.createdAt.toString().timeAgoString,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.blueGrey[200]),
                                strutStyle: StrutStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Spacer(),
                          KSIconButton(
                            icon: FeatherIcons.moreHorizontal,
                            iconSize: 22.0,
                            onTap: () => showOptionActionBottomSheet(post),
                          ),
                        ],
                      ),
                    ),
                    post.description != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: SelectableLinkify(
                              text: post.description!,
                              style: Theme.of(context).textTheme.bodyText1,
                              linkStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: isLight(context)
                                        ? Colors.blue
                                        : Colors.grey[100],
                                    decoration: TextDecoration.underline,
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
                            ),
                          )
                        : SizedBox(height: 8.0),
                    if (post.type == PostType.feed) ...[
                      post.isExternal
                          ? KSLinkPreview(post: post)
                          : post.photo != null && imageSize != null
                              ? RepaintBoundary(
                                  key: captureKey,
                                  child: SizedBox(
                                    height: (MediaQuery.of(context).size.width *
                                            imageSize!.height) /
                                        imageSize!.width,
                                    child: PageView(
                                      controller: pageController,
                                      children: List.generate(
                                        post.image!.length,
                                        (index) {
                                          return InkWell(
                                            onTap: () {
                                              launchScreen(
                                                  context, ViewPhotoScreen.tag,
                                                  arguments: {
                                                    'post': post,
                                                    'index': index
                                                  });
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: post.image!
                                                  .elementAt(index)
                                                  .name,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                    ] else ...[
                      Stack(
                        children: [
                          RepaintBoundary(
                            key: captureKey,
                            child: Stack(
                              children: [
                                post.photo != null
                                    ? SizedBox(
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: post.photo!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : SizedBox(
                                        width: AppSize(context).appWidth(100),
                                        height: AppSize(context).appWidth(100),
                                        child: CacheImage(
                                            url: post.sport!.id == 1
                                                ? 'https://images.unsplash.com/photo-1589487391730-58f20eb2c308?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1353&q=80'
                                                : 'https://images.unsplash.com/photo-1592656094267-764a45160876?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                                      ),
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16.0,
                                        bottom: 8.0,
                                        top: 26.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: AppSize(context).appWidth(70),
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                if (widget.post.sport!.icon !=
                                                    null) ...[
                                                  WidgetSpan(
                                                    child: SizedBox(
                                                      height: 16,
                                                      width: 16,
                                                      child: CacheImage(
                                                          url: widget.post
                                                              .sport!.icon!),
                                                    ),
                                                  ),
                                                  WidgetSpan(
                                                      child: Container(
                                                        height: 4,
                                                        width: 4,
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 6),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle),
                                                      ),
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle),
                                                ],
                                                TextSpan(
                                                  text: widget.post.title,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: whiteColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Feather.calendar,
                                                        color: whiteColor,
                                                        size: 12.0,
                                                      ),
                                                      const SizedBox(
                                                        width: 4.0,
                                                      ),
                                                      Text(
                                                        DateFormat('dd MMM yyyy')
                                                                .format(DateTime
                                                                    .parse(widget
                                                                        .post
                                                                        .activityDate!)) +
                                                            '  ',
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: whiteColor,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Feather.clock,
                                                        color: whiteColor,
                                                        size: 12.0,
                                                      ),
                                                      4.width,
                                                      Text(
                                                        calcMinuteDuration(),
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: whiteColor,
                                                        ),
                                                        strutStyle: StrutStyle(
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // Row(
                                              //   children: [
                                              //     Icon(
                                              //       Feather.clock,
                                              //       color: whiteColor,
                                              //       size: 18.0,
                                              //     ),
                                              //     4.width,
                                              //     Text(
                                              //       calcMinuteDuration(),
                                              //       style: TextStyle(
                                              //         fontSize: 18.0,
                                              //         color: whiteColor,
                                              //         fontWeight: FontWeight.w600,
                                              //       ),
                                              //       strutStyle: StrutStyle(
                                              //         fontSize: 18.0,
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),

                                              // SizedBox(
                                              //   height: 24,
                                              //   child: Image.asset(imgVplayText),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 16,
                            bottom: 8,
                            child: SizedBox(
                              height: 20,
                              child: Image.asset(imgVplayText),
                            ),
                          )
                        ],
                      )
                    ],
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      KSIconButton(
                        icon: (post.reacted != null && post.reacted!)
                            ? Icons.favorite
                            : FeatherIcons.heart,
                        iconColor: (post.reacted != null && post.reacted!)
                            ? ColorResources.getActiveIconColor(context)
                            : ColorResources.getInactiveIconColor(context),
                        onTap: () {
                          if (post.reacted!) {
                            post.totalReaction -= 1;
                          } else {
                            post.totalReaction += 1;
                          }
                          setState(() {
                            post.reacted = !post.reacted!;
                          });
                          reactPost();
                          widget.postCallback!(post);
                        },
                      ),
                      4.width,
                      KSIconButton(
                        icon: FeatherIcons.messageSquare,
                        iconColor: ColorResources.getInactiveIconColor(context),
                        onTap: () {
                          _commentTextNode.requestFocus();
                          scrollToBottom();
                        },
                      ),
                      // 4.width,
                      // KSIconButton(
                      //   icon: FeatherIcons.share2,
                      //   onTap: onShare,
                      // ),
                      Spacer(),
                      buildTotalReaction(post.totalReaction),
                      buildTotalComment(post.totalComment),
                    ],
                  ),
                  post.image != null && post.image!.length > 1
                      ? Center(
                          child: SmoothPageIndicator(
                            controller: pageController,
                            count: post.image!.length,
                            effect: ScrollingDotsEffect(
                              dotHeight: 5.0,
                              dotWidth: 5.0,
                              spacing: 6.0,
                              activeDotScale: 1.5,
                              maxVisibleDots: 5,
                              activeDotColor: mainColor,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            if (commentList.isNotEmpty)
              Column(
                children: List.generate(commentList.length, (index) {
                  return CommentCell(comment: commentList.elementAt(index));
                }),
              ),
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
                focusNode: _commentTextNode,
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
                      ?.copyWith(color: ColorResources.getBlueGrey(context)),
                ),
                onChanged: (value) {
                  setState(() {});
                },
                onTap: () {
                  scrollToBottom();
                },
              ),
            ),
          ),
          CupertinoButton(
            child: _commentController.text.trim().isNotEmpty
                ? Icon(Icons.send, color: mainColor)
                : Text('👍', style: Theme.of(context).textTheme.headline5),
            padding: EdgeInsets.zero,
            onPressed: () => commentOnPost(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
          systemNavigationBarColor:
              Theme.of(context).brightness == Brightness.light
                  ? Color.fromRGBO(113, 113, 113, 1)
                  : Color.fromRGBO(15, 15, 15, 1),
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    buildNavbar(),
                    buildDetailBody(),
                    SliverPadding(padding: EdgeInsets.only(bottom: 60.0)),
                  ],
                ),
                Positioned(bottom: 0, child: _bottomCommentAction())
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    post = widget.post;
    _homeCubit = context.read<HomeCubit>();

    getImageSize();
    getPostDetail();

    if (widget.isCommentTap) {
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        _commentTextNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentTextNode.unfocus();
    _commentTextNode.dispose();
    super.dispose();
  }

  void getImageSize() async {
    if (post.photo != null) {
      imageSize = await calculateImageDimension(post.photo!);
      setState(() {});
    }
  }

  void showOptionActionBottomSheet(Post post) {
    showKSBottomSheet(context, children: [
      if (isMe(post.owner.id))
        KSTextButtonBottomSheet(
          title: 'Edit Post',
          icon: Feather.edit,
          onTab: () {
            dismissScreen(context);
            launchScreen(context, CreatePostScreen.tag, arguments: post);
          },
        ),
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
                deletePost();
              },
            );
          },
        ),
      if (!isMe(post.owner.id)) ...[
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
                if (widget.postIndex != -1) {
                  _homeCubit.onHidePost(post.id);
                } else {
                  ksClient
                      .postApi('/user/activity/hide_post/${post.id}')
                      .then((value) {
                    if (value != null) {
                      _homeCubit.onRefresh();
                    }
                  });
                }

                dismissScreen(context, 1);
                if (widget.postIndex != -1) {
                  showKSSnackBar(
                    context,
                    title: 'This post is no longer show to you.',
                    action: true,
                    actionTitle: 'Undo',
                    onAction: () {
                      if (widget.postIndex != -1) {
                        _homeCubit.onUndoHidingPost(
                            index: widget.postIndex, post: post);
                      } else {
                        ksClient
                            .postApi(
                                '/user/activity/show/hidden_post/${post.id}')
                            .then((value) {
                          if (value != null) {
                            _homeCubit.onRefresh();
                          }
                        });
                      }
                    },
                  );
                }
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
        /*KSTextButtonBottomSheet(
          title: 'Block ${post.owner.getFullname()}',
          icon: LineIcons.ban,
          iconSize: 24.0,
          onTab: () {
            dismissScreen(context);
            showKSConfirmDialog(
              context,
              message: 'Are you sure you want to block ${post.owner.getFullname()}?',
              onYesPressed: () {
                // var res =
                //     await ksClient.postApi('/user/unfollow/${post.owner.id}');
                // if (res != null) {
                //   if (res is! HttpResult) {}
                // }
                showKSLoading(context);
                Future.delayed(Duration(seconds: 1), () {
                  _homeCubit.onBlockUser(post.owner.id);
                  dismissScreen(context);
                  dismissScreen(context);
                });
              },
            );
          },
        ),*/
        KSTextButtonBottomSheet(
          title: 'Report Post',
          icon: LineIcons.infoCircle,
          iconSize: 24.0,
          onTab: () {
            dismissScreen(context);
            showReportScreen(context);
          },
        ),
      ]
    ]);
  }

  void getPostDetail() async {
    var data = await ksClient.getApi('/view/post/${post.id}');
    if (data != null) {
      if (data is! HttpResult) {
        post = Post.fromJson(data['post']);
        post.owner = post.owner;
        commentList = List.from(
            (data['comment'] as List).map((e) => Comment.fromJson(e)));
        if (widget.postCallback != null) {
          widget.postCallback!(post);
        }
        setState(() {});
      }
    }
    getUserLike();
  }

  void deletePost() async {
    showKSLoading(context);
    var result = await ksClient.postApi('/delete/post/${post.id}');
    if (result != null) {
      await Future.delayed(Duration(milliseconds: 500));
      dismissScreen(context);
      if (result is! HttpResult) {
        BlocProvider.of<HomeCubit>(context).onDeletePostFeed(post.id);
        dismissScreen(context);
      }
    }
  }

  void commentOnPost() async {
    if (_commentController.text.trim().isEmpty) {
      _commentController.text = '👍';
    }
    Map<String, dynamic> fields = Map<String, dynamic>();
    fields['comment'] = _commentController.text;
    fields['type'] = 1;

    var result =
        await ksClient.postApi('/create/post/comment/${post.id}', body: fields);
    if (result != null) {
      if (result is! HttpResult) {
        var newComment = Comment.fromJson(result);
        commentList.insert(commentList.length, newComment);
        post.totalComment += 1;
        _commentController.clear();
        setState(() {});
        scrollToBottom();
        widget.postCallback!(post);
      }
    }
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void reactPost() async {
    var result = await ksClient.postApi('/create/post/reaction/${post.id}');
    if (result != null) {
      if (result is! HttpResult) {}
    }
  }

  void viewImage() {
    showMaterialModalBottomSheet(
      context: context,
      expand: true,
      barrierColor: Colors.black.withOpacity(0.5),
      backgroundColor: Colors.black,
      enableDrag: state == PhotoViewScaleState.initial,
      builder: (context) {
        var showDescription = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  showDescription = !showDescription;
                });
              },
              child: Container(
                child: Stack(
                  children: [
                    Center(
                      child: PhotoViewGestureDetectorScope(
                        axis: Axis.vertical,
                        child: PhotoView(
                          controller: photoViewController,
                          scaleStateController: scaleStateController,
                          backgroundDecoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          tightMode: true,
                          gestureDetectorBehavior: HitTestBehavior.opaque,
                          minScale: PhotoViewComputedScale.contained,
                          maxScale: 1.5,
                          imageProvider:
                              CachedNetworkImageProvider(post.photo!),
                          loadingBuilder: (context, event) {
                            return CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(whiteColor),
                            );
                          },
                          scaleStateChangedCallback: (photoScaleState) {
                            state = photoScaleState;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16.0,
                      top: 28.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 28.0,
                          height: 28.0,
                          decoration: BoxDecoration(
                              color: whiteColor, shape: BoxShape.circle),
                          child: Icon(
                            Icons.close,
                            color: blackColor,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                    post.description != null
                        ? Positioned(
                            bottom: 0,
                            child: showDescription
                                ? ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 300.0,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      width: AppSize(context).appWidth(100),
                                      // height: 300.0,
                                      color: blackColor.withOpacity(0.5),
                                      child: SingleChildScrollView(
                                        child: Text(
                                          post.description!,
                                          style: TextStyle(color: whiteColor),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          )
                        : SizedBox()
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void openDialog(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              child: PhotoView(
                tightMode: true,
                imageProvider: CachedNetworkImageProvider(post.photo!),
                heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
              ),
            ),
          );
        },
      );

  void openBottomSheet(BuildContext context) => showBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        shape: const ContinuousRectangleBorder(),
        builder: (BuildContext context) {
          return PhotoViewGestureDetectorScope(
            axis: Axis.vertical,
            child: PhotoView(
              backgroundDecoration: BoxDecoration(
                color: Colors.black.withAlpha(240),
              ),
              imageProvider: CachedNetworkImageProvider(post.photo!),
              heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
            ),
          );
        },
      );

  void openBottomSheetModal(BuildContext context) => showModalBottomSheet(
        context: context,
        shape: const ContinuousRectangleBorder(),
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              height: 250,
              child: PhotoViewGestureDetectorScope(
                axis: Axis.vertical,
                child: PhotoView(
                  tightMode: true,
                  imageProvider: CachedNetworkImageProvider(post.photo!),
                  heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                ),
              ),
            ),
          );
        },
      );

  String calcMinuteDuration() {
    var s = DateTime.parse(post.activityDate! + ' ' + post.activityStartTime!);
    var e = DateTime.parse(post.activityDate! + ' ' + post.activityEndTime!);

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

  Future<void> getUserLike() async {
    var res = await ksClient.getApi('/view/post/reaction/${post.id}');
    if (res != null) {
      if (res is! HttpResult) {
        likeUsers =
            List.from((res as List).map((e) => User.fromJson(e['user'])));
        setState(() {});
      }
    }
  }

  void showUserLike() async {
    await getUserLike();
    showKSBottomSheet(
      context,
      title: 'Like by',
      children: likeUsers.isNotEmpty
          ? List.generate(
              likeUsers.length,
              (index) {
                final user = likeUsers[index];
                return InkWell(
                  onTap: () {
                    if (user.id != KS.shared.user.id) {
                      launchScreen(context, ViewUserProfileScreen.tag,
                          arguments: {'user': user});
                    } else {
                      launchScreen(context, AccountScreen.tag);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        Avatar(radius: 18, user: user),
                        8.width,
                        Text(
                          user.getFullname(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : [
              Container(
                height: 100,
              )
            ],
    );
  }

  void onShare() async {
    if (uImage == null) uImage = await Capture.toPngByte(captureKey);

    if (uImage != null) {
      showModalBottomSheet<void>(
          isScrollControlled: true,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9),
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          builder: (BuildContext context) {
            return Container(
                //height: MediaQuery.of(context).size.height * 0.9,
                padding: const EdgeInsets.all(16),
                child: ShareFeedScreen(
                  image: uImage,
                  post: post,
                ));
          });
    }
  }
}
