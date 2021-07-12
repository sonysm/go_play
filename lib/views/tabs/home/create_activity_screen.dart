import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/address.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/activity_preview_screen.dart';
import 'package:kroma_sport/views/tabs/home/choose_location_screen.dart';
import 'package:location/location.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;
import 'package:app_settings/app_settings.dart';

class CreateActivityScreen extends StatefulWidget {
  static const tag = '/createActivityScreen';

  CreateActivityScreen({Key? key}) : super(key: key);

  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  KSHttpClient ksClient = KSHttpClient();
  List<Sport> sportList = [];
  late Sport selectedSport;

  List<String> activityLevelList = ['Chill', 'Moderate', 'Intense'];
  late String selectedActivity;

  ExpandableController expandableController = ExpandableController();
  ExpandableController expandableTimeController = ExpandableController();
  String selectedDateString = 'Today';
  DateTime selectedDate = DateTime.now();

  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(hours: 2));

  Address? address;
  String locationName = 'Add location (Optional)';
  late int dourationInMinutes;

  TextEditingController activityNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text(
        'Add Activity',
        style: Theme.of(context).textTheme.headline6?.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Metropolis',
            ),
      ),
      backgroundColor: Colors.transparent,
      iconTheme: Theme.of(context).iconTheme.copyWith(color: whiteColor),
      pinned: true,
      elevation: 0.0,
    );
  }

  Widget buildAddPhotoWidget() {
    return Container(
      width: AppSize(context).appWidth(100),
      height: AppSize(context).appWidth(100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0ba360),
            Color(0xFF3cba92),
          ],
          // begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
        ),
      ),
      child: images.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                24.height,
                Icon(Feather.camera, color: whiteColor),
                8.height,
                Text(
                  'Add a photo',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 16.0,
                  ),
                ),
                8.height,
                Text(
                  'Selfies are always encouraged!',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 14.0,
                  ),
                ),
              ],
            )
          : AssetThumb(
              asset: images[0],
              width: images[0].originalWidth!,
              height: images[0].originalHeight!,
            ),
    );
  }

  Widget buildSportOption(Sport sport) {
    return ElevatedButton(
      onPressed: () {
        setState(() => selectedSport = sport);
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        foregroundColor: MaterialStateProperty.all(sport.id == selectedSport.id
            ? whiteColor
            : Theme.of(context).textTheme.bodyText2?.color),
        backgroundColor: MaterialStateProperty.all(sport.id == selectedSport.id
            ? mainColor
            : Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: sport.id == selectedSport.id
                ? BorderSide.none
                : BorderSide(color: Colors.blueGrey),
          ),
        ),
      ),
      child: Text(
        sport.name,
        style: TextStyle(fontFamily: 'Metropolis'),
      ),
    );
  }

  Widget buildActivityLevel(String activity) {
    return ElevatedButton(
      onPressed: () {
        setState(() => selectedActivity = activity);
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        foregroundColor: MaterialStateProperty.all(activity == selectedActivity
            ? whiteColor
            : Theme.of(context).textTheme.bodyText2?.color),
        backgroundColor: MaterialStateProperty.all(activity == selectedActivity
            ? mainColor
            : Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: activity == selectedActivity
                ? BorderSide.none
                : BorderSide(color: Colors.blueGrey),
          ),
        ),
      ),
      child: Text(activity),
    );
  }

  Widget buildScrollBody() {
    Color iconColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey
        : Colors.grey[300]!;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          InkWell(
            onTap: getImage,
            child: Container(
              width: AppSize(context).appWidth(100),
              height: AppSize(context).appWidth(100) -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  64.0,
              color: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Feather.clock, color: iconColor),
                          16.width,
                          Expanded(
                            child: InkWell(
                              onTap: showDateTimePicker,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedDateString,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    '${DateFormat('h:mm a').format(startTime)} to ${DateFormat('h:mm a').format(endTime)}  ' +
                                        calcHourDuration(
                                            startTime: startTime,
                                            endTime: endTime),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  16.height,
                                  Divider(
                                    color: Colors.blueGrey[100],
                                    thickness: 1,
                                    height: 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Feather.map_pin, color: iconColor),
                          16.width,
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (permissionStatus ==
                                    PermissionStatus.granted) {
                                  var location = await launchScreen(
                                      context, SetAddressScreen.tag);
                                  if (location != null) {
                                    address = location;
                                    locationName = address!.name;
                                    setState(() {});
                                  }
                                } else {
                                  checkGps();
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    locationName,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: isLight(context)
                                            ? Colors.blueGrey[600]
                                            : whiteColor),
                                  ),
                                  16.height,
                                  Divider(
                                    color: Colors.blueGrey[100],
                                    thickness: 1,
                                    height: 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          40.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sportList.isNotEmpty
                                    ? Wrap(
                                        spacing: 8.0,
                                        children: List.generate(
                                            sportList.length, (index) {
                                          final sport =
                                              sportList.elementAt(index);
                                          return buildSportOption(sport);
                                        }),
                                      )
                                    : SizedBox(),
                                // 16.height,
                                // Divider(
                                //   color: Colors.blueGrey[100],
                                //   thickness: 1,
                                //   height: 0,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Feather.bookmark, color: iconColor),
                          16.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                8.height,
                                TextField(
                                  controller: activityNameController,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: 'Name of activity (Required)',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  onChanged: (_) {
                                    setState(() {});
                                  },
                                ),
                                16.height,
                                Divider(
                                  color: Colors.blueGrey[100],
                                  thickness: 1,
                                  height: 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Feather.bookmark, color: iconColor),
                          16.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: descriptionController,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: 'Description (Optional)',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                16.height,
                                Divider(
                                  color: Colors.blueGrey[100],
                                  thickness: 1,
                                  height: 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () {
                      var activity = {
                        'photo': images.isNotEmpty ? images.elementAt(0) : null,
                        'date': DateFormat('yyyy-MM-dd').format(selectedDate),
                        'startTime': DateFormat('hh:mm:ss').format(startTime),
                        'endTime': DateFormat('hh:mm:ss').format(endTime),
                        'sport': selectedSport,
                        'locationName': address?.name,
                        'latitude': address?.latitude,
                        'longitude': address?.longitude,
                        'name': activityNameController.text,
                        'description':
                            descriptionController.text.trim().isNotEmpty
                                ? descriptionController.text
                                : null,
                        'minute': dourationInMinutes,
                      };
                      FocusScope.of(context).unfocus();
                      launchScreen(context, ActivityPreviewScreen.tag,
                          arguments: activity);
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                      backgroundColor: MaterialStateProperty.all(
                          availableNext() ? mainColor : Colors.green[200]),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: whiteColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Metropolis',
                      ),
                    ),
                  ),
                ),
                16.height,
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildAddPhotoWidget(),
          CustomScrollView(
            slivers: [
              buildNavbar(),
              buildScrollBody(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkGps();
    selectedActivity = activityLevelList[0];

    Future.delayed(Duration(milliseconds: 300)).then((_) {
      getSportList();
    });
  }

  void getSportList() async {
    var data = await ksClient.getApi('/user/all/sport');
    if (data != null) {
      // isLoading = false;
      if (data is! HttpResult) {
        sportList = List.from((data as List).map((e) => Sport.fromJson(e)));
        if (sportList.isNotEmpty) selectedSport = sportList.elementAt(0);
        setState(() {});
      }
    }
  }

  List<Asset> images = <Asset>[];

  Future getImage() async {
    //final pickedFile = await picker.getImage(source: ImageSource.gallery);

    //setState(() {
    //  if (pickedFile != null) {
    //    imageFile = File(pickedFile.path);
    //    reuseImage = File(pickedFile.path);
    //  } else {
    //    print('No image selected.');
    //  }
    //});

    if (Platform.isAndroid) {
      var permission = await checkAndRequestPhotoPermissions();
      if (!permission) {
        _showPhotoAlert();
      }
    }

    List<Asset>? assetList;
    //String imageKey = 'images';
    try {
      assetList = await MultiImagePicker.pickImages(
        maxImages: 1,
      );
    } on Exception catch (_) {}

    if (!mounted) return;

    if (assetList != null) {
      images = assetList;
      setState(() {});
    }

    //if (assetList != null) {
    //  Future.forEach(assetList, (element) async {
    //    {
    //      ByteData byteData = await (element as Asset).getByteData();
    //      List<int> imageData = byteData.buffer.asUint8List();

    //      files.add(MultipartFile.fromBytes(
    //        imageKey,
    //        imageData,
    //        filename: 'FD' +
    //            DateTime.now().millisecondsSinceEpoch.toString() +
    //            '.jpg',
    //      ));
    //    }
    //  }).then((value) {
    //    //showKSLoading(context);
    //    //TmsService().uploadPhotoGallery(files: files).then((user) {
    //    //  if (user != null) {
    //    //    widget.userDetails.user = user;
    //    //    TMS.shared.user = user;
    //    //    Navigator.pop(context);
    //    //    setState(() {});
    //    //  }
    //    //});
    //  });
    //}
  }

  void showDateTimePicker() {
    var sDate = selectedDate;
    var sDateString = selectedDateString;
    var sTime = startTime;
    var eTime = endTime;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.5),
      builder: (context) {
        Color icColor = Theme.of(context).brightness == Brightness.light
            ? Colors.grey
            : Colors.grey[300]!;
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExpandablePanel(
                        controller: expandableController,
                        header: Container(
                          height: 64.0,
                          child: TextButton(
                            onPressed: () {
                              expandableController.toggle();
                              if (expandableTimeController.value == true) {
                                expandableTimeController.toggle();
                              }
                            },
                            style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(4.0),
                                        bottom: Radius.circular(0.0)),
                                  ),
                                )),
                            child: Row(
                              children: [
                                Icon(Feather.calendar, color: icColor),
                                16.width,
                                Text(
                                  sDateString,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        expanded: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          child: SfDateRangePicker(
                            enablePastDates: false,
                            showNavigationArrow: true,
                            initialSelectedDate: selectedDate,
                            headerStyle: DateRangePickerHeaderStyle(
                              textAlign: TextAlign.center,
                              textStyle: Theme.of(context).textTheme.caption,
                            ),
                            monthCellStyle: DateRangePickerMonthCellStyle(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(fontSize: 10.0),
                              weekendTextStyle: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(fontSize: 10.0),
                              disabledDatesTextStyle: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(
                                      color: Colors.grey, fontSize: 10.0),
                            ),
                            onSelectionChanged: (args) {
                              sDate = args.value;
                              sDateString = dateString(args.value);
                              setState(() {});
                            },
                          ),
                        ),
                        collapsed: Container(),
                        theme: ExpandableThemeData(
                          hasIcon: false,
                        ),
                      ),
                      ExpandablePanel(
                        controller: expandableTimeController,
                        header: Container(
                          height: 64.0,
                          width: double.infinity,
                          color: Theme.of(context).primaryColor,
                          child: TextButton(
                            onPressed: () {
                              expandableTimeController.toggle();
                              if (expandableController.value == true) {
                                expandableController.toggle();
                              }
                            },
                            style: ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Row(
                              children: [
                                Icon(Feather.clock, color: icColor),
                                16.width,
                                Text(
                                  '${DateFormat('h:mm a').format(sTime)} - ${DateFormat('h:mm a').format(eTime)}  ' +
                                      calcHourDuration(
                                          startTime: sTime, endTime: eTime),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        expanded: Row(
                          children: [
                            TimePickerSpinner(
                              time: startTime,
                              is24HourMode: false,
                              normalTextStyle:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                              highlightedTextStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              spacing: 0,
                              itemHeight: 30,
                              isForce2Digits: true,
                              onTimeChange: (time) {
                                sTime = time;
                                setState(() {});
                              },
                            ),
                            Expanded(
                              child: Text(
                                '-',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            TimePickerSpinner(
                              time: endTime,
                              is24HourMode: false,
                              normalTextStyle:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                              highlightedTextStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              spacing: 0,
                              itemHeight: 30,
                              isForce2Digits: true,
                              onTimeChange: (time) {
                                eTime = time;
                                setState(() {});
                              },
                            ),
                            16.width,
                          ],
                        ),
                        collapsed: Container(),
                        theme: ExpandableThemeData(
                          hasIcon: false,
                        ),
                      ),
                      Container(
                        height: 64.0,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                MaterialStateProperty.all(mainColor),
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey[200]!.withOpacity(0.5)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(0),
                                    bottom: Radius.circular(4.0)),
                              ),
                            ),
                          ),
                          child: Text(
                            'Update',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      if (expandableController.value == true) {
        expandableController.toggle();
      }
      if (expandableTimeController.value == true) {
        expandableTimeController.toggle();
      }

      if (value != null && value) {
        selectedDate = sDate;
        selectedDateString = sDateString;
        startTime = sTime;
        endTime = eTime;
        setState(() {});
      }
    });
  }

  String dateString(DateTime date) {
    if (date.isSameDate(DateTime.now())) {
      return 'Today';
    } else if (date.difference(DateTime.now()).inDays == 0) {
      return 'Tomorrow';
    }

    return DateFormat('EEE dd MMM').format(date);
  }

  String calcHourDuration(
      {required DateTime startTime, required DateTime endTime}) {
    if (endTime.difference(startTime).inMinutes == 0) {
      dourationInMinutes = 24 * 60;
      return '24h';
    } else if (endTime.difference(startTime).isNegative) {
      int dur =
          (endTime.add(Duration(days: 1))).difference(startTime).inMinutes;
      int hour = dur ~/ 60;
      var min = dur % 60;
      dourationInMinutes = dur;

      return (hour > 0 ? '$hour\h ' : '') + (min > 0 ? '$min\mn' : '');
    }

    int dur = endTime.difference(startTime).inMinutes;
    int hour = dur ~/ 60;
    var min = dur % 60;
    dourationInMinutes = dur;

    return (hour > 0 ? '$hour\h ' : '') + (min > 0 ? '$min\mn' : '');
  }

  late PermissionStatus permissionStatus;

  checkGps() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print('____LOCATION___SERVICE__DISABLE_________');
      }
    }

    try {
      permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          _showLocationAlert();
          return;
        }
      }

      LocationData data = await location.getLocation();
      if (data.latitude != null && data.longitude != null) {
        KS.shared.setupLocationMintor();
      }
    } catch (e) {
      _showLocationAlert();
      print('____ERROR____GET___LOCATION_________$e');
    }
  }

  _showLocationAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Location disable'),
            // insetPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            content: Text(
              'Please enable your location.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    AppSettings.openLocationSettings();
                  },
                  child: Text('Open setting')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Not now'))
            ],
          );
        });
  }

  bool availableNext() {
    if (activityNameController.text.trim().length > 0) {
      return true;
    }
    return false;
  }

  Future<bool> checkAndRequestPhotoPermissions() async {
    permissionHandler.PermissionStatus photoPermission =
        await permissionHandler.Permission.photos.status;
    if (photoPermission != permissionHandler.PermissionStatus.granted) {
      var status =
          await permissionHandler.Permission.photos.request().isGranted;
      return status;
    } else {
      return true;
    }
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
                  child: Text('Open setting')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Not now'))
            ],
          );
        });
  }
}
