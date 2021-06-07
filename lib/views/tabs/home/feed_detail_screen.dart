import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/models/comment.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/widget/comment_cell.dart';
import 'package:kroma_sport/views/tabs/home/widget/photo_view_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FeedDetailScreen extends StatefulWidget {
  static const String tag = '/feedDetailScreen';
  final Post post;
  final bool isCommentTap;

  FeedDetailScreen({
    Key? key,
    required this.post,
    this.isCommentTap = false,
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
  List<Comment> commentList = [];

  var selectedIndex = 0;
  PageController pageController = PageController();

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Post Detail'),
      elevation: 0.5,
      forceElevated: true,
      pinned: true,
    );
  }

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
                    user: post.owner,
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
                            ?.copyWith(fontWeight: FontWeight.w600, fontFamily: 'Metropolis'),
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
                    iconSize: 22.0,
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
                      widget.post.description ?? '',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                : SizedBox(height: 8.0),
            if (widget.post.type == PostType.feed) ...[
              widget.post.photo != null && imageSize != null
                  ? SizedBox(
                      height: (MediaQuery.of(context).size.width *
                              imageSize!.height) /
                          imageSize!.width,
                      child: PageView(
                        controller: pageController,
                        children: List.generate(
                          widget.post.image!.length,
                          (index) {
                            return InkWell(
                              onTap: () {
                                launchScreen(context, ViewPhotoScreen.tag,
                                    arguments: {
                                      'post': widget.post,
                                      'index': index
                                    });
                              },
                              child: CachedNetworkImage(
                                  imageUrl:
                                      widget.post.image!.elementAt(index).name),
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox(),
            ] else ...[
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
              )
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                alignment: Alignment.center,
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
                        onTap: () {
                          _commentTextNode.requestFocus();
                          scrollToBottom();
                        },
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
                  widget.post.image != null && widget.post.image!.length > 1
                      ? Center(
                          child: SmoothPageIndicator(
                            controller: pageController,
                            count: widget.post.image!.length,
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
            commentList.isNotEmpty
                ? Column(
                    children: List.generate(commentList.length, (index) {
                      return CommentCell(comment: commentList.elementAt(index));
                    }),
                  )
                : SizedBox(),
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
                    hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: isLight(context)
                            ? Colors.blueGrey
                            : Colors.blueGrey[100])),
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.post);
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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

  Size? imageSize;

  @override
  void initState() {
    super.initState();
    getImageSize();
    post = widget.post;
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
    if (widget.post.photo != null) {
      imageSize = await calculateImageDimension(widget.post.photo!);
      setState(() {});
    }
  }

  void showOptionActionBottomSheet(Post post) {
    FocusScope.of(context).unfocus();
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
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                bottomSheetBar(context),
                isMe(post.owner.id)
                    ? KSTextButtonBottomSheet(
                        title: 'Delete Post',
                        icon: Feather.trash_2,
                        onTab: () {
                          dismissScreen(context);
                          showKSConfirmDialog(context,
                              'Are you sure you want to delete this post?', () {
                            deletePost();
                          });
                        },
                      )
                    : SizedBox(),
                KSTextButtonBottomSheet(
                  title: 'Report Post',
                  icon: Feather.info,
                  onTab: () {
                    dismissScreen(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void getPostDetail() async {
    var data = await ksClient.getApi('/view/post/${widget.post.id}');
    if (data != null) {
      if (data is! HttpResult) {
        post = Post.fromJson(data['post']);
        widget.post.owner = post.owner;
        commentList = List.from(
            (data['comment'] as List).map((e) => Comment.fromJson(e)));
        setState(() {});
      }
    }
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
        widget.post.totalComment += 1;
        _commentController.clear();
        setState(() {});
        scrollToBottom();
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
    var result =
        await ksClient.postApi('/create/post/reaction/${widget.post.id}');
    if (result != null) {
      if (result is! HttpResult) {
        print('success!!!!');
      }
    }
  }

  PhotoViewController photoViewController = PhotoViewController();
  PhotoViewScaleStateController scaleStateController =
      PhotoViewScaleStateController();
  var state;

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
                              CachedNetworkImageProvider(widget.post.photo!),
                          loadingBuilder: (context, event) {
                            return CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(whiteColor),
                            );
                          },
                          scaleStateChangedCallback: (photoScaleState) {
                            print('ssss: $photoScaleState');
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
                    widget.post.description != null
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
                                          widget.post.description!,
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
                imageProvider: CachedNetworkImageProvider(widget.post.photo!),
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
              imageProvider: CachedNetworkImageProvider(widget.post.photo!),
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
                  imageProvider: CachedNetworkImageProvider(widget.post.photo!),
                  heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                ),
              ),
            ),
          );
        },
      );

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

    return '$dur\mn';
  }
}
