import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class ActivityPreviewScreen extends StatefulWidget {
  static const tag = '/activityPreviewScreen';

  final Map<String, dynamic> activityData;

  ActivityPreviewScreen({Key? key, required this.activityData})
      : super(key: key);

  @override
  _ActivityPreviewScreenState createState() => _ActivityPreviewScreenState();
}

class _ActivityPreviewScreenState extends State<ActivityPreviewScreen> {
  KSHttpClient ksClient = KSHttpClient();

  @override
  Widget build(BuildContext context) {
    print('date : ${widget.activityData['date']}');
    print('start time : ${widget.activityData['startTime']}');
    print('end time : ${widget.activityData['endTime']}');

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.5,
        title: Text('Activity preview'),
        actions: [
          TextButton(
            onPressed: createActivity,
            child: Text(
              'Done',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: mainColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: SingleChildScrollView(
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
                      user: KS.shared.user,
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
                                        text: KS.shared.user.getFullname(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                      widget.activityData['locationName'] !=
                                              null
                                          ? TextSpan(
                                              text:
                                                  ' added an activity at ${widget.activityData['locationName']}.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            )
                                          : TextSpan(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'a moment',
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
                  ],
                ),
              ),
              widget.activityData['description'] != null &&
                      (widget.activityData['description'] as String).isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: SelectableText(
                        widget.activityData['description'],
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  : SizedBox(height: 8.0),
              Stack(
                children: [
                  widget.activityData['photo'] != null
                      ? SizedBox(
                          width: double.infinity,
                          child: AssetThumb(
                            asset: widget.activityData['photo'],
                            width: (widget.activityData['photo'] as Asset)
                                .originalWidth!,
                            height: (widget.activityData['photo'] as Asset)
                                .originalWidth!,
                          ),
                        )
                      : SizedBox(
                          width: AppSize(context).appWidth(100),
                          height: AppSize(context).appWidth(100),
                          child: CacheImage(
                              url: (widget.activityData['sport'] as Sport).id ==
                                      1
                                  ? 'https://images.unsplash.com/photo-1589487391730-58f20eb2c308?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1353&q=80'
                                  : 'https://images.unsplash.com/photo-1592656094267-764a45160876?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                        ),
                  Positioned(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (widget.activityData['sport'] as Sport)
                                  .name
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: whiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.activityData['name'],
                              style: TextStyle(
                                fontSize: 22.0,
                                color: whiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          'Sport',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16.0,
                    bottom: 16.0,
                    child: Row(
                      children: [
                        Icon(Feather.clock, color: whiteColor),
                        4.width,
                        Text(
                          '${widget.activityData['minute']}mn',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        KSIconButton(
                          icon: FeatherIcons.heart,
                          iconColor:
                              isLight(context) ? Colors.blueGrey : whiteColor,
                        ),
                        4.width,
                        KSIconButton(icon: FeatherIcons.messageSquare),
                        4.width,
                        KSIconButton(icon: FeatherIcons.share2),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createActivity() async {
    Map<String, String> fields = Map<String, String>();
    var image;

    if (widget.activityData['photo'] != null) {
      ByteData byteData =
          await (widget.activityData['photo'] as Asset).getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      if (widget.activityData['description'] != null) {
        fields['description'] = widget.activityData['description'];
      }

      fields['name'] = widget.activityData['name'];
      fields['date'] = widget.activityData['date'];
      fields['from_time'] = widget.activityData['startTime'];
      fields['to_time'] = widget.activityData['endTime'];
      fields['location_name'] = widget.activityData['locationName'];
      fields['latitude'] = widget.activityData['latitude'];
      fields['longitude'] = widget.activityData['longitude'];
      fields['sport'] = (widget.activityData['sport'] as Sport).id.toString();

      image = MultipartFile.fromBytes(
        'photo',
        imageData,
        filename:
            'AC' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg',
      );
    }

    showKSLoading(context);
    var data =
        await ksClient.postFile('/create/activity', image, fields: fields);
    if (data != null) {
      dismissScreen(context);
      if (data is! HttpResult) {
        dismissScreen(context);
      } else {
        showKSMessageDialog(
            context,
            'Something went wrong with the content! Image size might be too large!',
            () {});
      }
    }
  }
}
