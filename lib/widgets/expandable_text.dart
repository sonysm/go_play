import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key? key,
    this.trimLines = 2,
  }) : super(key: key);

  final String text;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;

  Color? get whiteColor => null;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final colorClickableText = Colors.blue;
    final widgetColor = Colors.black;

    TextSpan link = TextSpan(
        text: _readMore ? "... See more" : "",
        style: TextStyle(
          color: colorClickableText,
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl, //better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset)!;
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore ? widget.text.substring(0, endIndex) : widget.text,
            style: TextStyle(
              color: widgetColor,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
            style: TextStyle(color: Colors.black),
          );
        }
        return GestureDetector(
          onTap: _onTapLink,
          child: RichText(
            softWrap: true,
            overflow: TextOverflow.clip,
            text: textSpan,
          ),
        );
      },
    );
    return result;
  }

  showCopyDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(.3),
      builder: (_) {
        return Container(
          child: Stack(
            children: [
              Positioned(
                left: 24.0,
                top: kToolbarHeight + 16.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(whiteColor),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16.0)),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.text));
                    Navigator.pop(context);
                    // Fluttertoast.showToast(
                    //   msg: "Text Copied",
                    //   toastLength: Toast.LENGTH_SHORT,
                    //   gravity: ToastGravity.BOTTOM,
                    //   timeInSecForIosWeb: 1,
                    //   backgroundColor: Colors.grey[200].withOpacity(0.9),
                    //   textColor: Colors.black,
                    //   fontSize: 14.0,
                    // );
                  },
                  child: Text(
                    'Copy Text',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
