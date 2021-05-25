import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class MeetupDetailScreen extends StatefulWidget {
  static const tag = '/meetUpDetailScreen';

  final Post meetup;

  MeetupDetailScreen({Key? key, required this.meetup}) : super(key: key);

  @override
  _MeetupDetailScreenState createState() => _MeetupDetailScreenState();
}

class _MeetupDetailScreenState extends State<MeetupDetailScreen> {
  late Post meetup;

  late GoogleMapController _mapController;

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
            zoom: 14.0,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
          },
          zoomGesturesEnabled: false,
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
                  if (index <= meetup.meetupMember!.length - 1) {
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 33,
                          backgroundColor:
                              isLight(context) ? Colors.blueGrey : whiteColor,
                          child: Avatar(
                            radius: 32,
                            user: meetup.meetupMember!.elementAt(index).owner,
                          ),
                        ),
                        4.height,
                        Text(
                          meetup.owner.firstName,
                          textAlign: TextAlign.center,
                        ),
                        meetup.meetupMember!.elementAt(index).owner.id ==
                                meetup.owner.id
                            ? Text(
                                '(Host)',
                                textAlign: TextAlign.center,
                              )
                            : SizedBox(),
                      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meetup.title),
        elevation: 0.5,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              buildMainInfo(),
              buildMap(),
              buildMember(),
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
                onPressed: () {},
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: MaterialStateProperty.all(mainColor),
                ),
                child: Text(
                  'Join Game',
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
    meetup = widget.meetup;
  }
}
