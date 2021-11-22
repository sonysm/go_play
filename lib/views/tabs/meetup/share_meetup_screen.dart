import 'dart:io';
import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/models/member.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/capture.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:clipboard/clipboard.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;

class ShareMeetupScreen extends StatefulWidget {
  final Post post;
  const ShareMeetupScreen({Key? key, required this.post}) : super(key: key);

  @override
  _ShareMeetupScreenState createState() => _ShareMeetupScreenState();
}

class _ShareMeetupScreenState extends State<ShareMeetupScreen> {
  Uint8List? shareImage;
  late String shareUrl;
  GlobalKey captureKey = GlobalKey();
  late List<Member> joinMember;

  @override
  void initState() {
    super.initState();
    shareUrl =
        'https://v-play.cc?shared=${widget.post.createdAt!.millisecondsSinceEpoch}&aid=${widget.post.id}';
    joinMember = widget.post.meetupMember!
        .where((element) => element.status == 1)
        .toList();
  }

  _showPhotoAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Photo disable'),
            // insetPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            content: Text(
              'Please enable your photo.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
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

  bool isMeetupAvailable() {
    var meetupDate = DateFormat('yyyy-MM-dd').parse(widget.post.activityDate!);
    if (DateTime.now().isAfter(meetupDate)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RepaintBoundary(
            key: captureKey,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                  
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    margin:
                        const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Avatar(
                                radius: 18.0,
                                user: widget.post.owner,
                                isSelectable: false,
                                onTap: (user) {},
                              ),
                              8.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: widget.post.owner
                                                      .getFullname(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                                TextSpan(
                                                  text: ' is hosting ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                TextSpan(
                                                  text: widget.post.title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    4.height,
                                    Text(
                                      widget.post.createdAt
                                          .toString()
                                          .timeAgoString,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                              color: isLight(context)
                                                  ? Colors.blueGrey[400]
                                                  : Colors.blueGrey[100]),
                                    ),
                                  ],
                                ),
                              ),
                              // KSIconButton(
                              //   icon: FeatherIcons.moreHorizontal,
                              //   iconSize: 24.0,
                              //   onTap: () => showOptionActionBottomSheet(widget.post),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  widget.post.sport!.name + ' Meetup',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isLight(context)
                                              ? mainColor
                                              : Colors.white70),
                                ),
                              ),
                              Divider(),
                              widget.post.description != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 24.0),
                                      child: SelectableText(
                                        widget.post.description!,
                                        style:
                                            Theme.of(context).textTheme.bodyText1,
                                        onTap: () {},
                                      ),
                                    )
                                  : SizedBox(),
                              // Divider(),
                              Text(
                                'Members Joined',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: isLight(context)
                                            ? Colors.grey[600]
                                            : Colors.white70),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List.generate(widget.post.maxPeople!,
                                      (index) {
                                    if (index <= joinMember.length - 1) {
                                      return CircleAvatar(
                                        radius: 18,
                                        backgroundColor: isLight(context)
                                            ? Colors.amber
                                            : whiteColor,
                                        child: Avatar(
                                          radius: 16,
                                          user: joinMember.elementAt(index).user,
                                          isSelectable: false,
                                        ),
                                      );
                                    }

                                    return DottedBorder(
                                      color: isLight(context)
                                          ? Colors.blueGrey
                                          : whiteColor,
                                      strokeWidth: 1.5,
                                      dashPattern: [3, 4],
                                      borderType: BorderType.Circle,
                                      strokeCap: StrokeCap.round,
                                      padding: EdgeInsets.zero,
                                      radius: Radius.circular(0),
                                      child: Container(
                                        width: 32.0,
                                        height: 32.0,
                                        decoration: BoxDecoration(
                                          color: isLight(context)
                                              ? Colors.grey[100]
                                              : Colors.blueGrey[400],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              widget.post.price! > 0
                                  ? RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: widget.post.price.toString() +
                                                ' USD',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: ' /person',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                ?.copyWith(
                                                    color: isLight(context)
                                                        ? Colors.blueGrey
                                                        : Colors.white70),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              Divider(),
                              // 8.height,
                              // Text(
                              //   meetup.sport!.name + ' Meetup',
                              //   style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              //       fontWeight: FontWeight.w600
                              //       color: isLight(context)
                              //           ? Colors.blueGrey[600]
                              //           : Colors.white70),
                              // ),
                              // 16.height,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Feather.clock,
                                    size: 16.0,
                                    color: isLight(context)
                                        ? Colors.grey[700]
                                        : Colors.grey[300]!,
                                  ),
                                  8.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${DateFormat('EEE dd MMM').format(DateTime.parse(widget.post.activityDate!))}, ${DateFormat('h:mm a').format(DateTime.parse(widget.post.activityDate! + ' ' + widget.post.activityStartTime!))} - ${DateFormat('h:mm a').format(DateTime.parse(widget.post.activityDate! + ' ' + widget.post.activityEndTime!))}',
                                        style:
                                            Theme.of(context).textTheme.bodyText2,
                                      ),
                                      Text(
                                        'One time activity',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            ?.copyWith(
                                                color: isLight(context)
                                                    ? Colors.blueGrey
                                                    : Colors.white70),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (widget.post.activityLocation != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Feather.map_pin,
                                        size: 16.0,
                                        color: isLight(context)
                                            ? Colors.grey[700]
                                            : Colors.grey[300]!,
                                      ),
                                      8.width,
                                      Flexible(
                                        child: Text(
                                          widget.post.activityLocation!.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          strutStyle: StrutStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              widget.post.book != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Feather.bookmark,
                                            size: 16.0,
                                            color: isLight(context)
                                                ? Colors.grey[700]
                                                : Colors.grey[300]!,
                                          ),
                                          8.width,
                                          Text(
                                            'Field booked',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                            strutStyle: StrutStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              16.height,
                              Row(
                                children: [
                                  Icon(
                                    Feather.pocket,
                                    size: 16.0,
                                    color: isLight(context)
                                        ? Colors.grey[700]
                                        : Colors.grey[300]!,
                                  ),
                                  8.width,
                                  widget.post.status == PostStatus.active
                                      ? Text(
                                          isMeetupAvailable()
                                              ? 'Meetup Available'
                                              : 'Meetup Expired',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.copyWith(
                                                  color: isMeetupAvailable()
                                                      ? mainColor
                                                      : Colors.amber[700]),
                                          strutStyle: StrutStyle(fontSize: 14.0),
                                        )
                                      : Text(
                                          'Meetup Canceled',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.copyWith(color: Colors.red),
                                          strutStyle: StrutStyle(fontSize: 14.0),
                                        ),
                                ],
                              ),
                              8.height,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    right: 8,
                    bottom: 8,
                    child: Opacity(
                      opacity: 0.5,
                      child: QrImage(
                        padding: EdgeInsets.all(1.5),
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
            padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KSIconButton(
                  onTap: () async {
                    if (shareImage == null)
                      shareImage = await Capture.toPngByte(captureKey);
                    if (shareImage != null) {
                      if (Platform.isAndroid) {
                        PermissionHandler.PermissionStatus photoPermission =
                            await PermissionHandler.Permission.photos.status;
                        if (photoPermission !=
                            PermissionHandler.PermissionStatus.granted) {
                          final status = await PermissionHandler
                              .Permission.photos
                              .request()
                              .isGranted;
                          if (!status) {
                            _showPhotoAlert();
                            return;
                          }
                        }
                      }
                      final result = await ImageGallerySaver.saveImage(
                          shareImage!,
                          quality: 100);
                      if (result != null && result['isSuccess'] == true) {
                        final snackBar = SnackBar(
                            duration: Duration(seconds: 2),
                            content: const Text(
                              'Image has been saved to device.',
                              style: TextStyle(color: Colors.white),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  icon: FeatherIcons.download,
                ),
                KSIconButton(
                    onTap: () async {
                      if (shareImage == null)
                        shareImage = await Capture.toPngByte(captureKey);
                      if (shareImage != null) {
                        final directory =
                            (await getApplicationDocumentsDirectory()).path;
                        File imgFile = new File('$directory/photo.png');
                        await imgFile.writeAsBytes(shareImage!);
                        Share.shareFiles(['${imgFile.path}'],
                            text: 'VPlay', subject: shareUrl);
                      }
                    },
                    icon: Icons.share),
                KSIconButton(
                    onTap: () {
                      FlutterClipboard.copy(shareUrl).then((value) {
                        final snackBar = SnackBar(
                            duration: Duration(seconds: 1),
                            content: const Text(
                              'Link copied to clipboard',
                              style: TextStyle(color: Colors.white),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    },
                    icon: FeatherIcons.link)
              ],
            ),
          )
        ],
      ),
    );
  }
}
