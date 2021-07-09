import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/user.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class HomeFeedCellLink extends StatefulWidget {
  final Post post;
  final bool isAvatarSelectable;
  final String? urlInfo;
  const HomeFeedCellLink({
    Key? key,
    required this.post,
    this.urlInfo,
    this.isAvatarSelectable = true,
  }) : super(key: key);

  @override
  _HomeFeedCellLinkState createState() => _HomeFeedCellLinkState();
}

class _HomeFeedCellLinkState extends State<HomeFeedCellLink> {
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
                    isSelectable: widget.isAvatarSelectable,
                    onTap: (user) {
                      widget.post.owner = user;
                      setState(() {});
                    },
                  ),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.post.owner.getFullname(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Metropolis')),
                      Text(
                        widget.post.createdAt.toString().timeAgoString +
                            widget.post.id.toString() +
                            '\n${widget.urlInfo}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            color: isLight(context)
                                ? Colors.blueGrey[400]
                                : Colors.blueGrey[100]),
                        maxLines: 2,
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
            widget.urlInfo != null
                ? AnyLinkPreview(
                    link: widget.urlInfo!,
                    borderRadius: 0,
                    cache: Duration(seconds: 0),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.3),
                      ),
                    ],
                    backgroundColor: Colors.grey[50],
                    errorTitle: '',
                    errorWidget: Container(
                      color: Colors.grey[300],
                      child: Text('Oops!'),
                    ),
                    placeholderWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation(Colors.grey[400]),
                          ),
                        ),
                        8.width,
                        Text(
                          'Fetching data...',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                    webInfoCallback: (_) {},
                  )
                : SizedBox(),
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
    setState(() {
      widget.post.owner = p.owner;
      widget.post.reacted = p.reacted;
    });
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
                          showKSConfirmDialog(
                            context,
                            message:
                                'Are you sure you want to delete this post?',
                            onYesPressed: () {
                              deletePost(post.id);
                            },
                          );
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
      if (result is! HttpResult) {}
    }
  }

  final RegExp urlRegExp = RegExp(
    r"((https?:www\.)|(https?:\/\/)|(www\.))?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?",
    caseSensitive: false,
  );

  final _protocolIdentifierRegex = RegExp(
    r'^(https?:\/\/)',
    caseSensitive: false,
  );

  // void checkLinkPreview() {
  //   if (widget.post.description == null) {
  //     return;
  //   }
  //   final urlMatches = urlRegExp.allMatches(widget.post.description!);

  //   List<String> urls = urlMatches
  //       .map((urlMatch) =>
  //           widget.post.description!.substring(urlMatch.start, urlMatch.end))
  //       .toList();

  //   // urls.forEach((x) => print(x));
  //   if (urls.isNotEmpty) {
  //     _urlInfo = urls.elementAt(0);

  //     if (!_urlInfo!.startsWith(_protocolIdentifierRegex)) {
  //       _urlInfo =
  //           (LinkifyOptions().defaultToHttps ? "https://" : "http://") + _urlInfo!;
  //     }
  //   }

  //   print("link ${widget.post.id}, $_urlInfo");
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    // checkLinkPreview();
  }

  @override
  void didUpdateWidget(HomeFeedCellLink oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post != oldWidget.post) {
      setState(() {});
    }
  }
}
