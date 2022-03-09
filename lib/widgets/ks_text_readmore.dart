import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:url_launcher/url_launcher.dart';

class KSTextReadMore extends StatefulWidget {
  final Post post;

  const KSTextReadMore({Key? key, required this.post}) : super(key: key);

  @override
  _KSTextReadMoreState createState() => _KSTextReadMoreState();
}

class _KSTextReadMoreState extends State<KSTextReadMore> {
  Size getTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  double? textWidth;
  bool showReadMore = true;

  double calculateLineText(String text, TextStyle style) {
    double line = 0;

    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);

    line = textPainter.size.width / (AppSize(context).appWidth(100) - 32);

    if (line < 2) {
      line = '\n'.allMatches(text).length + line;
    }

    return line;
  }

  @override
  Widget build(BuildContext context) {
    final textWidth = calculateLineText(
        widget.post.description ?? '', Theme.of(context).textTheme.bodyText1!);
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableLinkify(
                  enableInteractiveSelection: false,
                  text: widget.post.description!,
                  style: Theme.of(context).textTheme.bodyText1,
                  strutStyle: StrutStyle(height: 1.5),
                  scrollPhysics: NeverScrollableScrollPhysics(),
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
                  linkStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: isLight(context)
                            ? Colors.blue
                            : Colors.lightBlue[400],
                        decoration: TextDecoration.underline,
                      ),
                  onTap: () {
                    setState(() => showReadMore = !showReadMore);
                  },
                  // minLines: 1,
                  maxLines: (textWidth > 2 && showReadMore) ? 2 : null,
                ),
                if (textWidth > 2 && showReadMore)
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ).copyWith(
                      overlayColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.grey[200]),
                    ),
                    onPressed: () => setState(() => showReadMore = false),
                    child: Text(
                      "... Read more",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            isLight(context) ? Colors.grey : Colors.grey[300],
                      ),
                    ),
                  )
              ],
            ),
          ),
        )
        /*Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SelectableLinkify(
                    enableInteractiveSelection: false,
                    text: widget.post.description!,
                    style: Theme.of(context).textTheme.bodyText1,
                    strutStyle: StrutStyle(height: 1.5),
                    scrollPhysics: NeverScrollableScrollPhysics(),
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
                    linkStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: isLight(context)
                              ? Colors.blue
                              : Colors.lightBlue[400],
                          decoration: TextDecoration.underline,
                        ),
                    onTap: () {
                      setState(() => showReadMore = !showReadMore);
                    },
                    // minLines: 1,
                    maxLines: (textWidth > 2 && showReadMore) ? 2 : null,
                  ),
                ),
              ),
              if (textWidth > 2 && showReadMore)
              TextSpan(
                text: "... Read more",
                style: TextStyle(
                  fontSize: 16,
                  color: isLight(context) ? Colors.grey : Colors.grey[300],
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() => showReadMore = false);
                  },
              ),
            ],
          ),
        ),
      ),*/
        );
  }
}
