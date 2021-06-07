import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/models/address.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:kroma_sport/views/tabs/home/choose_location_screen.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class OragnizeActivityScreen extends StatefulWidget {
  static const tag = '/oragnizeActivityScreen';
  final Sport sport;
  OragnizeActivityScreen({Key? key, required this.sport}) : super(key: key);

  @override
  _OragnizeActivityScreenState createState() => _OragnizeActivityScreenState();
}

class _OragnizeActivityScreenState extends State<OragnizeActivityScreen> {
  late Sport sport;

  late GameType selectedGameType;

  Address? address;

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Widget buildTimeAndLocation() {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time & Location',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            8.height,
            InkWell(
              onTap: chooseDatetime,
              child: Container(
                height: 54.0,
                child: Row(
                  children: [
                    Icon(Feather.clock, size: 18.0),
                    16.width,
                    Text(
                      selectedDateString != null
                          ? selectedDateString! +
                              ', ${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}'
                          : 'Add time',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
            Divider(height: 0, indent: 32.0),
            InkWell(
              onTap: () async {
                var _address =
                    await launchScreen(context, SetAddressScreen.tag);
                if (_address != null) {
                  address = _address;
                  setState(() {});
                }
              },
              child: Container(
                height: 54.0,
                child: Row(
                  children: [
                    Icon(Feather.map_pin, size: 18.0),
                    16.width,
                    Flexible(
                      child: Text(
                        address != null ? address!.name : 'Add location',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget builGameType(GameType gameType) {
    return InkWell(
      onTap: () {
        selectedGameType = gameType;
        minPlayer = gameType.minPlayer;
        maxPlayer = gameType.minPlayer;
        setState(() {});
      },
      child: Container(
        width: 100.0,
        height: 90.0,
        decoration: BoxDecoration(
            color: selectedGameType.id == gameType.id
                ? mainColor
                : isLight(context)
                    ? whiteColor
                    : Colors.blueGrey[600],
            borderRadius: BorderRadius.circular(6.0),
            border: selectedGameType.id == gameType.id
                ? null
                : Border.all(
                    color: isLight(context)
                        ? Colors.blueGrey
                        : Colors.blueGrey[400]!)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              gameType.title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: selectedGameType.id == gameType.id
                    ? whiteColor
                    : isLight(context)
                        ? Colors.blueGrey
                        : Colors.blueGrey[100],
              ),
            ),
            Text(
              gameType.desc,
              style: TextStyle(
                fontSize: 14.0,
                color: selectedGameType.id == gameType.id
                    ? whiteColor
                    : isLight(context)
                        ? Colors.blueGrey
                        : Colors.blueGrey[100],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMeetupDetails() {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meetup Details',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            16.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Feather.terminal, size: 18.0),
                16.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      TextField(
                        controller: nameController,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          hintText: 'Name of game(required)',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 18, indent: 32.0),
            Row(
              children: [
                Icon(Feather.align_left, size: 18.0),
                16.width,
                Expanded(
                  child: TextField(
                    controller: descController,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                      hintText: '(Optional) Description',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 18, indent: 32.0),
            8.height,
            Row(
              children: [
                Icon(Feather.users, size: 18.0),
                16.width,
                Text(
                  'Game type',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGameTypeList() {
    return SliverToBoxAdapter(
      child: Container(
        height: 90.0,
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 50.0),
          itemBuilder: (context, index) {
            final gameType =
                GameType.mapGameTypeToSport(sport.id).elementAt(index);

            return builGameType(gameType);
          },
          separatorBuilder: (context, index) {
            return 8.width;
          },
          itemCount: GameType.mapGameTypeToSport(sport.id).length,
        ),
      ),
    );
  }

  Widget buildMeetupBottom() {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Min people',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Spacer(),
                minPlayer > 2
                    ? KSIconButton(
                        icon: Feather.minus_circle,
                        onTap: () {
                          minPlayer -= 1;
                          setState(() {});
                        },
                      )
                    : SizedBox(width: 36.0),
                4.width,
                Container(
                  width: 64.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: Colors.blueGrey[600]!),
                  ),
                  child: Text(
                    minPlayer.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                4.width,
                minPlayer < maxPlayer
                    ? KSIconButton(
                        icon: Feather.plus_circle,
                        onTap: () {
                          minPlayer += 1;
                          setState(() {});
                        },
                      )
                    : SizedBox(width: 36.0),
              ],
            ),
            Divider(height: 16),
            Row(
              children: [
                Text(
                  'Max people',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Spacer(),
                maxPlayer > minPlayer
                    ? KSIconButton(
                        icon: Feather.minus_circle,
                        onTap: () {
                          maxPlayer -= 1;
                          setState(() {});
                        },
                      )
                    : SizedBox(width: 36.0),
                4.width,
                Container(
                  width: 64.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: Colors.blueGrey[600]!),
                  ),
                  child: Text(
                    maxPlayer.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                4.width,
                maxPlayer <= 60
                    ? KSIconButton(
                        icon: Feather.plus_circle,
                        onTap: () {
                          maxPlayer += 1;
                          setState(() {});
                        },
                      )
                    : SizedBox(width: 36.0),
              ],
            ),
            Divider(),
            Row(
              children: [
                Icon(Feather.dollar_sign, size: 18.0),
                16.width,
                Expanded(
                  child: TextField(
                    controller: priceController,
                    style: Theme.of(context).textTheme.bodyText1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Price (Optional)',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'USD',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: '/person',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: isLight(context)
                                ? Colors.blueGrey
                                : Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organize ${sport.name}'),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              buildTimeAndLocation(),
              buildMeetupDetails(),
              buildGameTypeList(),
              buildMeetupBottom(),
              SliverPadding(padding: EdgeInsets.only(bottom: 70.0)),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 64.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, -1),
                      blurRadius: 4.0,
                      // spreadRadius: 2.0
                      color: Colors.black.withOpacity(0.1)),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // print('____min: $minPlayer');
                  // print('____max: $maxPlayer');
                  // print(
                  //     '____price: ${double.parse(priceController.text.replaceAll(',', ''))}');
                  createMeetup();
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: MaterialStateProperty.all(mainColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                ),
                child: Text(
                  'Organize ${sport.name}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    sport = widget.sport;
    selectedGameType = GameType.mapGameTypeToSport(sport.id).elementAt(0);
    minPlayer = selectedGameType.minPlayer;
    maxPlayer = selectedGameType.minPlayer;
  }

  late int minPlayer;
  late int maxPlayer;

  ExpandableController expandableController = ExpandableController();
  ExpandableController expandableTimeController = ExpandableController();
  DateTime selectedDate = DateTime.now();
  String? selectedDateString;

  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(hours: 2));

  late int dourationInMinutes;

  KSHttpClient ksClient = KSHttpClient();

  void chooseDatetime() {
    var sDate = selectedDate;
    var sDateString = selectedDateString ?? 'Today';
    var sTime = startTime;
    var eTime = endTime;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return SafeArea(
            maintainBottomViewPadding: true,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Choose Datetime'),
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: [
                  TextButton(
                    onPressed: () {
                      dismissScreen(context, true);
                    },
                    child: Text(
                      'Done',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: mainColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(
                      height: 0,
                      thickness: 1.0,
                      color: Colors.blueGrey[100],
                    ),
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
                            overlayColor:
                                MaterialStateProperty.all(Colors.grey[100]),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(4.0),
                                  bottom: Radius.circular(0.0),
                                ),
                              ),
                            ),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 16.0)),
                          ),
                          child: Row(
                            children: [
                              Icon(Feather.calendar,
                                  color: isLight(context)
                                      ? Colors.grey
                                      : Colors.grey[300]!),
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
                                ?.copyWith(color: Colors.grey, fontSize: 10.0),
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
                    Divider(
                        indent: 50.0, height: 0, color: Colors.blueGrey[200]),
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
                            overlayColor:
                                MaterialStateProperty.all(Colors.grey[100]),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 16.0)),
                          ),
                          child: Row(
                            children: [
                              Icon(Feather.clock,
                                  color: isLight(context)
                                      ? Colors.grey
                                      : Colors.grey[300]!),
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
                    Divider(
                        indent: 50.0, height: 0, color: Colors.blueGrey[200]),
                    32.height,
                  ],
                ),
              ),
            ),
          );
        });
      },
    ).then((value) {
      // if (expandableController.value == true) {
      //   expandableController.toggle();
      // }
      // if (expandableTimeController.value == true) {
      //   expandableTimeController.toggle();
      // }

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

  void createMeetup() async {
    Map<String, String> fields = Map<String, String>();
    if (selectedDateString == null) {
      showKSMessageDialog(context, 'Please set match time!', () {});
      return;
    }
    if (address == null) {
      showKSMessageDialog(context, 'Please set match location!', () {});
      return;
    }
    if (nameController.text.trim().length < 4) {
      showKSMessageDialog(context, 'Plese set match name properly!', () {});
      return;
    }

    if (descController.text.trim().isNotEmpty) {
      fields['description'] = descController.text;
    }

    if (priceController.text.trim().isNotEmpty) {
      fields['price'] =
          double.parse(priceController.text.replaceAll(',', '')).toString();
    } else {
      fields['price'] = '0';
    }

    fields['name'] = nameController.text;
    fields['date'] = DateFormat('yyyy-MM-dd').format(selectedDate);
    fields['from_time'] = DateFormat('hh:mm:ss').format(startTime);
    fields['to_time'] = DateFormat('hh:mm:ss').format(endTime);
    fields['sport'] = sport.id.toString();
    fields['location_name'] = address!.name;
    fields['latitude'] = address!.latitude;
    fields['longitude'] = address!.longitude;
    fields['min_people'] = minPlayer.toString();
    fields['max_people'] = maxPlayer.toString();

    showKSLoading(context);
    var data = await ksClient.postApi('/create/meetup', body: fields);
    if (data != null) {
      dismissScreen(context);
      if (data is! HttpResult) {
        dismissScreen(context);
        var newMeetup = Post.fromJson(data);
        BlocProvider.of<MeetupCubit>(context).onAddMeetup(newMeetup);
        Navigator.popUntil(context, ModalRoute.withName(MainView.tag));
      } else {
        showKSMessageDialog(
            context, 'Something went wrong! Please try again!', () {});
      }
    }
  }
}

class GameType {
  int id;
  String title;
  String desc;
  int minPlayer;

  GameType({
    required this.id,
    required this.title,
    required this.desc,
    required this.minPlayer,
  });

  static List<GameType> football = <GameType>[
    GameType(title: 'Futsal', desc: '8++ players', id: 1, minPlayer: 8),
    GameType(title: '11 Aside', desc: '22++ players', id: 2, minPlayer: 11),
  ];

  static List<GameType> volleyball = <GameType>[
    GameType(title: 'Pratice', desc: '2++ players', id: 1, minPlayer: 2),
    GameType(title: '3 Aside', desc: '6++ players', id: 2, minPlayer: 6),
    GameType(title: '4 Aside', desc: '8++ players', id: 3, minPlayer: 8),
    GameType(title: '6 Aside', desc: '12++ players', id: 4, minPlayer: 12),
  ];

  static List<GameType> mapGameTypeToSport(int sportId) {
    switch (sportId) {
      case 1:
        return football;
      case 2:
        return volleyball;
      default:
        return football;
    }
  }
}
