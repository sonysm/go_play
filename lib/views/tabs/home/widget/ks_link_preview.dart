import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:url_launcher/url_launcher.dart';

class KSLinkPreview extends StatelessWidget {
  final Post post;
  const KSLinkPreview({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(post.externalLink!)) {
          // await launch(post.externalLink!);
          FlutterWebBrowser.openWebPage(url: post.externalLink!);
        } else {
          try {
            // await launch(post.externalLink!);
            FlutterWebBrowser.openWebPage(url: post.externalLink!);
          } catch (err) {
            throw 'Could not launch ${post.externalLink!}. Error: $err';
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: blackColor.withOpacity(0.3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: post.photo!,
                fit: BoxFit.cover,
              ),
            ),
            4.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                post.title ?? '',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                post.externalDesc ?? '',
                maxLines: 2,
                style: TextStyle(
                    color: isLight(context) ? Colors.grey : Colors.grey[100]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
