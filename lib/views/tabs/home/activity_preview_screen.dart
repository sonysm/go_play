import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/account.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/main.dart';
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

  var originalHeight;
  var originalWidth;

  double? imgHeight;

  @override
  Widget build(BuildContext context) {
    if (widget.activityData['photo'] != null) {
      imgHeight = AppSize(context).appWidth(100) *
          double.parse(originalHeight.toString()) /
          double.parse(originalWidth.toString());
    }

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
                          height: imgHeight,
                          child: AssetThumb(
                            asset: widget.activityData['photo'],
                            width: originalWidth,
                            height: originalHeight,
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
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 8.0, top: 26.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black87,
                            Color(0x00000000),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: AppSize(context).appWidth(50),
                            child: Text(
                              widget.activityData['name'],
                              style: TextStyle(
                                fontSize: 14.0,
                                color: whiteColor,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (widget.activityData['sport'] as Sport)
                                    .name
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Feather.clock,
                                    color: whiteColor,
                                    size: 18.0,
                                  ),
                                  4.width,
                                  Text(
                                    '${widget.activityData['minute']}mn',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: whiteColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    strutStyle: StrutStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 24, child: Image.asset(imgVplayText)),
                            ],
                          ),
                        ],
                      ),
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
                        //KSIconButton(icon: FeatherIcons.share2),
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

  @override
  void initState() {
    super.initState();

    if (widget.activityData['photo'] != null) {
      originalHeight = (widget.activityData['photo'] as Asset).originalHeight!;
      originalWidth = (widget.activityData['photo'] as Asset).originalWidth!;
    }
  }

  void createActivity() async {
    FocusScope.of(context).unfocus();
    Map<String, String> fields = Map<String, String>();
    var image;

    if (widget.activityData['photo'] != null) {
      ByteData byteData =
          await (widget.activityData['photo'] as Asset).getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      image = MultipartFile.fromBytes(
        'photo',
        imageData,
        filename:
            'AC' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg',
      );
    }

    if (widget.activityData['description'] != null) {
      fields['description'] = widget.activityData['description'];
    }

    if (widget.activityData['locationName'] != null) {
      fields['location_name'] = widget.activityData['locationName'];
    }

    if (widget.activityData['latitude'] != null) {
      fields['latitude'] = widget.activityData['latitude'];
    }

    if (widget.activityData['longitude'] != null) {
      fields['longitude'] = widget.activityData['longitude'];
    }

    fields['name'] = widget.activityData['name'];
    fields['date'] = widget.activityData['date'];
    fields['from_time'] = widget.activityData['startTime'];
    fields['to_time'] = widget.activityData['endTime'];
    fields['sport'] = (widget.activityData['sport'] as Sport).id.toString();

    showKSLoading(context);
    var data =
        await ksClient.postFile('/create/activity', image, fields: fields);
    if (data != null) {
      dismissScreen(context);
      if (data is! HttpResult) {
        dismissScreen(context);
        var newActivity = Post.fromJson(data);
        BlocProvider.of<HomeCubit>(context).onPostFeed(newActivity);
        BlocProvider.of<AccountCubit>(context).onAddPost(newActivity);
        Navigator.popUntil(context, ModalRoute.withName(MainView.tag));
      } else {
        showKSMessageDialog(
          context,
          message:
              'Something went wrong with the content! Image size might be too large!',
        );
      }
    }
  }
}
