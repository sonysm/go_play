import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:app_settings/app_settings.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/utils/capture.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:clipboard/clipboard.dart';
import 'package:permission_handler/permission_handler.dart' as PermissionHandler;

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

  Flushbar? flushbar;

  @override
  void initState() {
    super.initState();
    shareUrl = 'https://v-play.cc?shared=${widget.post.createdAt!.millisecondsSinceEpoch}&aid=${widget.post.id}';
  }

  _showPhotoAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Photo disable'),
            // insetPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            content: Text(
              'Please enable your photo.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    AppSettings.openAppSettings();
                  },
                  child: Text('Open settings')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Not now'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
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
                        right: 8,
                        top: 8,
                        child: Opacity(
                          opacity: 0.7,
                          child: QrImage(
                            padding: EdgeInsets.all(4),
                            data: shareUrl,
                            size: 64,
                            backgroundColor: Colors.white,
                            embeddedImage: AssetImage(icRound),
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size(16, 16),
                              // color: Color(0xFF38ef7d)
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KSIconButton(
                      onTap: () async {
                        if (shareImage == null) shareImage = await Capture.toPngByte(captureKey);
                        if (shareImage != null) {
                          if (Platform.isAndroid) {
                            PermissionHandler.PermissionStatus photoPermission = await PermissionHandler.Permission.photos.status;
                            if (photoPermission != PermissionHandler.PermissionStatus.granted) {
                              final status = await PermissionHandler.Permission.photos.request().isGranted;
                              if (!status) {
                                _showPhotoAlert();
                                return;
                              }
                            }
                          }
                          final result = await ImageGallerySaver.saveImage(shareImage!, quality: 100);
                          if (result != null && result['isSuccess'] == true) {
                            flushbar = Flushbar(
                              messageText: Text(
                                "Image has been saved to device.",
                                textAlign: TextAlign.center,
                              ),
                              flushbarStyle: FlushbarStyle.FLOATING,
                              borderRadius: BorderRadius.circular(8.0),
                              margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                              duration: const Duration(seconds: 3),
                              onTap: (_) {
                                flushbar!.dismiss();
                              },
                              backgroundColor: isLight(context) ? Colors.grey[400]! : Colors.blueGrey[400]!,
                            )..show(context);
                          }
                        }
                      },
                      icon: FeatherIcons.download,
                    ),
                    KSIconButton(
                        onTap: () async {
                          if (shareImage == null) shareImage = await Capture.toPngByte(captureKey);
                          if (shareImage != null) {
                            final directory = (await getApplicationDocumentsDirectory()).path;
                            File imgFile = new File('$directory/photo.png');
                            await imgFile.writeAsBytes(shareImage!);
                            Share.shareFiles(['${imgFile.path}'], text: 'VPlay', subject: shareUrl);
                          }
                        },
                        icon: Icons.share),
                    KSIconButton(
                        onTap: () {
                          FlutterClipboard.copy(shareUrl).then((value) {
                            flushbar = Flushbar(
                              messageText: Text(
                                "Link copied to clipboard",
                                textAlign: TextAlign.center,
                              ),
                              flushbarStyle: FlushbarStyle.FLOATING,
                              borderRadius: BorderRadius.circular(8.0),
                              margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                              duration: const Duration(seconds: 3),
                              onTap: (_) {
                                flushbar!.dismiss();
                              },
                              backgroundColor: isLight(context) ? Colors.grey[400]! : Colors.blueGrey[400]!,
                            )..show(context);
                          });
                        },
                        icon: FeatherIcons.link)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
