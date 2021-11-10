import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
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
           ): 
           Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
              child: SvgPicture.asset(
                svgError,
                height: 150,
                color: isLight(context) ? Colors.blueGrey[700] : Colors.white60,
              ),
            ),
            32.height,
            Text(
              'The content is unavailable',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: (isLight(context) ? Colors.blueGrey[700] : Colors.white60),
                  ),
            ),
            32.height,
            ElevatedButton(
              onPressed: () { 
                  Navigator.pop(context);
               },
                style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(
                      color: isLight(context) ? Colors.blueGrey :  Colors.grey[300]!,
                    ),
                  ),
                ),
                overlayColor: MaterialStateProperty.all(ColorResources.getOverlayIconColor(context)),
                backgroundColor: MaterialStateProperty.all(
                  isLight(context) ? Colors.blueGrey : Colors.transparent,
                ),
                foregroundColor: MaterialStateProperty.all(
                    isLight(context) ? whiteColor : Colors.grey[300]),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Text('OK'),
              ),
            ),
            SizedBox(height: AppBar().preferredSize.height + kToolbarHeight - 32),
          ],
        ),
    );
  }
}