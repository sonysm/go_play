import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/member.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';

class MeetupDetailScreen extends StatefulWidget {
  static const tag = '/meetUpDetailScreen';

  final Post meetup;

  MeetupDetailScreen({Key? key, required this.meetup}) : super(key: key);

  @override
  _MeetupDetailScreenState createState() => _MeetupDetailScreenState();
}

class _MeetupDetailScreenState extends State<MeetupDetailScreen> {
  late Post meetup;
  late List<Member> joinMember;

  late GoogleMapController _mapController;
  KSHttpClient ksClient = KSHttpClient();

  Widget buildMainInfo() {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            ListTile(
              dense: true,
              leading: Icon(Feather.align_left),
              title: Text(meetup.sport!.name,
                  style: Theme.of(context).textTheme.bodyText2),
              subtitle: Text(meetup.title,
                  style: Theme.of(context).textTheme.headline6),
            ),
            ListTile(
              dense: true,
              leading: Icon(Feather.calendar),
              title: Text(
                  '${DateFormat('EEE dd MMM').format(DateTime.parse(meetup.activityDate!))}, ${DateFormat('h:mm a').format(DateTime.parse(meetup.activityDate! + ' ' + meetup.activityStartTime!))} - ${DateFormat('h:mm a').format(DateTime.parse(meetup.activityDate! + ' ' + meetup.activityEndTime!))}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.w600)),
              subtitle: Text(
                'One time activity',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: isLight(context) ? Colors.blueGrey : Colors.white70),
              ),
            ),
            ListTile(
              dense: true,
              leading: Icon(Feather.map_pin),
              title: Text(meetup.activityLocation!.name,
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            ListTile(
              dense: true,
              leading: Icon(Feather.dollar_sign),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: meetup.price.toString() + ' USD',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: ' /person',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: isLight(context)
                              ? Colors.blueGrey
                              : Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            16.height,
          ],
        ),
      ),
    );
  }

  Widget buildMap() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200.0,
        width: AppSize(context).appWidth(100),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              double.parse(meetup.activityLocation!.latitude),
              double.parse(meetup.activityLocation!.longitude),
            ),
            zoom: 15.0,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
          },
          zoomGesturesEnabled: false,
          scrollGesturesEnabled: false,
          markers: <Marker>{
            Marker(
                markerId: MarkerId('venue'),
                position: LatLng(
                    double.parse(meetup.activityLocation!.latitude),
                    double.parse(meetup.activityLocation!.longitude))),
          },
        ),
      ),
    );
  }

  Widget buildMember() {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Text(
                'Going(${meetup.meetupMember!.length}/${meetup.maxPeople})',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 130.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                itemBuilder: (context, index) {
                  if (index <= joinMember.length - 1) {
                    return SizedBox(
                      // width: 80,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 33,
                            backgroundColor:
                                isLight(context) ? Colors.blueGrey : whiteColor,
                            child: Avatar(
                              radius: 32,
                              user: joinMember.elementAt(index).user,
                            ),
                          ),
                          4.height,
                          Text(
                            joinMember.elementAt(index).user.firstName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                          joinMember.elementAt(index).user.id == meetup.owner.id
                              ? Text(
                                  '(Host)',
                                  textAlign: TextAlign.center,
                                )
                              : SizedBox(),
                        ],
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      DottedBorder(
                        color: isLight(context) ? Colors.blueGrey : whiteColor,
                        strokeWidth: 1.5,
                        dashPattern: [3, 4],
                        borderType: BorderType.Circle,
                        strokeCap: StrokeCap.round,
                        padding: EdgeInsets.zero,
                        radius: Radius.circular(0),
                        child: Container(
                          width: 64.0,
                          height: 64.0,
                          decoration: BoxDecoration(
                            color: isLight(context)
                                ? Colors.grey[100]
                                : Colors.white60,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return 16.width;
                },
                itemCount: meetup.maxPeople!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  late bool isJoined;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dismissScreen(context, widget.meetup);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(meetup.title),
          elevation: 0.5,
          actions: [
            CupertinoButton(
              child: Icon(FeatherIcons.moreVertical,
                  color: isLight(context) ? Colors.grey[600] : whiteColor),
              onPressed: () => showMeetupBottomSheet(widget.meetup),
            )
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            EasyRefresh.custom(
              header: MaterialHeader(
                valueColor: AlwaysStoppedAnimation<Color>(mainColor),
              ),
              slivers: [
                buildMainInfo(),
                buildMap(),
                buildMember(),
              ],
              onRefresh: () async {
                fetchMeetup();
              },
            ),
            (meetup.owner.id != KS.shared.user.id &&
                        joinMember.length < meetup.maxPeople!) ||
                    (meetup.owner.id != KS.shared.user.id && isJoined)
                ? Positioned(
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
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: isJoined ? leaveGame : joinGame,
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: MaterialStateProperty.all(
                              isJoined ? Colors.grey[200] : mainColor),
                        ),
                        child: Text(
                          isJoined ? 'Leave Game' : 'Join Game',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: isJoined ? Colors.red : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    meetup = widget.meetup;

    joinMember =
        meetup.meetupMember!.where((element) => element.status == 1).toList();
    isJoined = joinMember.any((e) => e.user.id == KS.shared.user.id);
  }

  void fetchMeetup() {
    ksClient.getApi('/view/meetup/post/${meetup.id}').then((value) {
      if (value != null) {
        if (value is! HttpResult) {
          meetup = Post.fromJson(value['post']);
          widget.meetup.meetupMember = meetup.meetupMember;
          isJoined =
              meetup.meetupMember!.any((e) => e.user.id == KS.shared.user.id);
          setState(() {});
        }
      }
    });
  }

  void joinGame() {
    showKSConfirmDialog(context, 'Are you sure you want to join the game?',
        () async {
      showKSLoading(context);
      var result = await ksClient.postApi('/join/post/meetup/${meetup.id}');
      if (result != null) {
        if (result is! HttpResult) {
          var res = await ksClient.getApi('/view/meetup/post/${meetup.id}');
          if (res != null) {
            dismissScreen(context);
            if (res is! HttpResult) {
              meetup = Post.fromJson(res['post']);
              widget.meetup.meetupMember = meetup.meetupMember;
              joinMember = meetup.meetupMember!
                  .where((element) => element.status == 1)
                  .toList();
              isJoined = true;
              setState(() {});
            }
          }
        }
      }
    });
  }

  void leaveGame() {
    showKSConfirmDialog(context, 'Are you sure you want to leave the game?',
        () async {
      showKSLoading(context);
      var result = await ksClient.postApi('/leave/post/meetup/${meetup.id}');
      if (result != null) {
        if (result is! HttpResult) {
          var res = await ksClient.getApi('/view/meetup/post/${meetup.id}');
          if (res != null) {
            dismissScreen(context);
            if (res is! HttpResult) {
              meetup = Post.fromJson(res['post']);
              widget.meetup.meetupMember = meetup.meetupMember;
              joinMember = meetup.meetupMember!
                  .where((element) => element.status == 1)
                  .toList();
              isJoined = false;
              setState(() {});
            }
          }
        }
      }
    });
  }

  void showMeetupBottomSheet(Post meetup) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isMe(meetup.owner.id)
                    ? TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 0.0)),
                        ),
                        onPressed: () {
                          dismissScreen(context);
                          showKSConfirmDialog(context,
                              'Are you sure you want to delete this meetup?',
                              () {
                            deleteMeetup();
                          });
                        },
                        child: Container(
                          height: 54.0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 16.0, right: 16.0),
                                child: Icon(
                                  Feather.trash_2,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.blueGrey
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                'Delete Meetup',
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 0.0)),
                  ),
                  onPressed: () {
                    dismissScreen(context);
                  },
                  child: Container(
                    height: 54.0,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Icon(
                            Feather.info,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.blueGrey
                                    : Colors.white,
                          ),
                        ),
                        Text(
                          'Report Meetup',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  ),
                ),
                30.height,
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteMeetup() async {
    showKSLoading(context);
    var result = await ksClient.postApi('/delete/post/${widget.meetup.id}');
    if (result != null) {
      await Future.delayed(Duration(milliseconds: 500));
      dismissScreen(context);
      if (result is! HttpResult) {
        BlocProvider.of<MeetupCubit>(context).onDeleteMeetup(result['id']);
        dismissScreen(context);
      }
    }
  }
}
