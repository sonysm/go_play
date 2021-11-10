import 'package:flutter/material.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_detail_screen.dart';

class DetailScreen extends StatefulWidget {

  static const String tag = '/allDetailScreen';
  final int postId;

  const DetailScreen({ Key? key, required this.postId }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  Post? post;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  void fetchPost() {
    
    KSHttpClient ksClient = KSHttpClient();

    ksClient.getApi('/post/detail/${widget.postId}').then((value) {
      if (value != null) {
        if (value is! HttpResult) {
          post = Post.fromJson(value);
        }
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        child: 
        (post != null && !isLoading) ? 
            (post!.type == PostType.meetUp) ? MeetupDetailScreen(meetup: post): FeedDetailScreen(post: post!, postIndex: -1)
        : (isLoading) ? 
           Center(
             child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.greenAccent)),
           ): Center()
    );
  }
}