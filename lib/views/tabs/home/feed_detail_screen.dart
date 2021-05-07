import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/comment.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/widget/comment_cell.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';

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
  FocusNode _commentTextNode = FocusNode();
  ScrollController _scrollController = ScrollController();
  KSHttpClient ksClient = KSHttpClient();

  late Post post;
  List<Comment> commentList = [];

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Post Detail'),
      elevation: 0.5,
      forceElevated: true,
      pinned: true,
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
                    iconSize: 22.0,
                    onTap: () => showOptionActionBottomSheet(widget.post),
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
                  KSIconButton(
                    icon: FeatherIcons.heart,
                    onTap: () {},
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
                  Text('99 likes'),
                  8.width,
                  Text('27 comments'),
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

            //commentList.isNotEmpty
            //    ? ListView.builder(
            //        itemBuilder: (context, index) {
            //          return CommentCell(comment: commentList.elementAt(index));
            //        },
            //        itemCount: commentList.length,
            //        shrinkWrap: true,
            //      )
            //    : SizedBox(),
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
                        ?.copyWith(color: Colors.blueGrey)),
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
    );
  }

  @override
  void initState() {
    super.initState();
    post = widget.post;
    getPostDetail();
  }

  void showOptionActionBottomSheet(Post post) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
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
                            deletePost();
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

  void getPostDetail() async {
    var data = await ksClient.getApi('/view/post/${widget.post.id}');
    if (data != null) {
      if (data is! HttpResult) {
        post = Post.fromJson(data['post']);
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
        //var newComment = Comment.fromJson(result);

        var newCmt = Comment(
          id: 0,
          user: KS.shared.user,
          type: 'text',
          comment: _commentController.text,
          createdAt: DateTime.now(),
          post: post.id,
        );

        commentList.insert(commentList.length, newCmt);
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
}
