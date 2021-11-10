import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/utils/capture.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ShareFeedScreen extends StatefulWidget {
  final Uint8List? image;
  final Post post;
  const ShareFeedScreen({Key? key, this.image, required this.post}) : super(key: key);

  @override
  _ShareFeedScreenState createState() => _ShareFeedScreenState();
}

class _ShareFeedScreenState extends State<ShareFeedScreen> {
  Uint8List? shareImage;
  late String shareUrl;
  GlobalKey captureKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    shareUrl = 'https://v-play.cc?shared=${widget.post.createdAt!.millisecondsSinceEpoch}&aid=${widget.post.id}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            key: captureKey,
            child: Stack(
              children: [
                Container(
                  child: Image.memory(widget.image!),
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: QrImage(
                      data: shareUrl,
                      size: 80,
                      backgroundColor: Colors.white,
                      embeddedImage: AssetImage(icVplay),
                      embeddedImageStyle: QrEmbeddedImageStyle(size: Size(20, 20), color: Color(0xFF38ef7d)),
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.download)),
              IconButton(
                  onPressed: () async {
                    if (shareImage == null) shareImage = await Capture.toPngByte(captureKey);
                    if (shareImage != null) {
                      final directory = (await getApplicationDocumentsDirectory()).path;
                      File imgFile = new File('$directory/photo.png');
                      await imgFile.writeAsBytes(shareImage!);
                      Share.shareFiles(['${imgFile.path}'], text: 'VPlay', subject: shareUrl);
                    }
                    // final result = await ImageGallerySaver.saveImage(img, quality: 100);
                    // print(result);
                  },
                  icon: Icon(Icons.share)),
              IconButton(onPressed: () {}, icon: Icon(Icons.copy))
            ],
          )
        ],
      ),
    );
  }
}
