import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/account.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/config/env.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/discussion.dart';
import 'package:kroma_sport/models/member.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/report_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/connect_booking_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/invite_meetup_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_activity_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/share_meetup_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/widget/discussion_cell.dart';
import 'package:kroma_sport/views/tabs/venue/booking_history_detail.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';
import 'package:kroma_sport/widgets/ks_reason_dialog.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:marquee/marquee.dart';
import 'package:web_socket_channel/io.dart';

class MeetupDetailScreen extends StatefulWidget {
  static const tag = '/meetUpDetailScreen';

  final dynamic meetup;

  MeetupDetailScreen({Key? key, required this.meetup}) : super(key: key);

  @override
  _MeetupDetailScreenState createState() => _MeetupDetailScreenState();
}

class _MeetupDetailScreenState extends State<MeetupDetailScreen> {
  Post? meetup;
  late List<Member> joinMember;
  late bool isJoined;

  KSHttpClient ksClient = KSHttpClient();

  late IOWebSocketChannel channel;

  List<Discussion> discussionList = [];

  bool isShowMap = false;

  bool isLoading = true;

  Widget buildMainInfo() {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            ListTile(
              dense: true,
              horizontalTitleGap: 0,
              leading: Icon(Feather.align_left, size: 20.0),
              title: Text(meetup!.sport!.name, style: Theme.of(context).textTheme.bodyText2),
              subtitle: Text(meetup!.title, style: Theme.of(context).textTheme.headline6),
            ),
            ListTile(
              dense: true,
              horizontalTitleGap: 0,
              leading: Icon(Feather.calendar, size: 20.0),
              title: Text(
                  '${DateFormat('EEE dd MMM').format(DateTime.parse(meetup!.activityDate!))}, ${DateFormat('h:mm a').format(DateTime.parse(meetup!.activityDate! + ' ' + meetup!.activityStartTime!))} - ${DateFormat('h:mm a').format(DateTime.parse(meetup!.activityDate! + ' ' + meetup!.activityEndTime!))}',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600)),
              subtitle: Text(
                'One time activity',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(color: isLight(context) ? Colors.blueGrey : Colors.white70),
              ),
            ),
            if (meetup!.activityLocation != null)
              ListTile(
                dense: true,
                horizontalTitleGap: 0,
                leading: Icon(Feather.map_pin, size: 20.0),
                title: Text(meetup!.activityLocation!.name, style: Theme.of(context).textTheme.bodyText1),
              ),
            ListTile(
              dense: true,
              horizontalTitleGap: 0,
              leading: Icon(Feather.dollar_sign, size: 20.0),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: meetup!.price.toString() + ' USD',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: ' /person',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(color: isLight(context) ? Colors.blueGrey : Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            meetup!.book != null
                ? ListTile(
                    dense: true,
                    horizontalTitleGap: 0,
                    leading: Icon(Feather.bookmark, size: 20.0),
                    title: Text('Field Booked', style: Theme.of(context).textTheme.bodyText1),
                    trailing: TextButton(
                      onPressed: () {
                        launchScreen(
                          context,
                          BookingHistoryDetailScreen.tag,
                          arguments: {'id': meetup!.book},
                        );
                      },
                      style:
                          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[300]), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text('view', style: Theme.of(context).textTheme.bodyText2),
                    ),
                  )
                : SizedBox(),
            ListTile(
              dense: true,
              horizontalTitleGap: 0,
              leading: Icon(Feather.pocket, size: 20.0),
              title: RichText(
                text: TextSpan(
                  children: [
                    meetup!.status == PostStatus.active
                        ? TextSpan(
                            text: isMeetupAvailable() ? 'Meetup Available' : 'Meetup Expired',
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(color: isMeetupAvailable() ? mainColor : Colors.amber[700]))
                        : TextSpan(
                            text: 'Meetup Canceled',
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600, color: Colors.red),
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
      child: meetup!.activityLocation != null
          ? Container(
              height: 200.0,
              color: Colors.grey[200],
              width: AppSize(context).appWidth(100),
              child: isShowMap
                  ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          double.parse(meetup!.activityLocation!.latitude),
                          double.parse(meetup!.activityLocation!.longitude),
                        ),
                        zoom: 15.0,
                      ),
                      onMapCreated: (controller) {},
                      zoomGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: false,
                      markers: <Marker>{
                        Marker(
                          markerId: MarkerId('venue'),
                          position: LatLng(
                            double.parse(meetup!.activityLocation!.latitude),
                            double.parse(meetup!.activityLocation!.longitude),
                          ),
                        ),
                      },
                    )
                  : SizedBox(),
            )
          : SizedBox(),
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
                'Going(${joinMember.length}/${meetup!.maxPeople})',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 130.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                itemBuilder: (context, index) {
                  if (index <= joinMember.length - 1) {
                    return SizedBox(
                      // width: 80,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: isLight(context) ? Colors.amber : whiteColor,
                            child: Avatar(
                              radius: 32,
                              user: joinMember.elementAt(index).user,
                              isSelectable: joinMember.elementAt(index).user.id != KS.shared.user.id,
                              onTap: (_) {},
                            ),
                          ),
                          4.height,
                          Text(
                            joinMember.elementAt(index).user.firstName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                          joinMember.elementAt(index).user.id == meetup!.owner.id
                              ? Text(
                                  '(Host)',
                                  textAlign: TextAlign.center,
                                )
                              : SizedBox(),
                        ],
                      ),
                    );
                  }

                  return Opacity(
                    opacity: isMeetupAvailable() ? 1 : 0.3,
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            if (KS.shared.user.id == meetup!.owner.id) {
                              if (isMeetupAvailable()) {
                                launchScreen(
                                  context,
                                  InviteMeetupScreen.tag,
                                  arguments: {'joinMember': joinMember, 'meetup': meetup},
                                );
                              } else {
                                showKSMessageDialog(
                                  context,
                                  message: 'You cannot invite player.\nMeetup is expired.',
                                  buttonTitle: 'OK',
                                );
                              }
                            }
                          },
                          child: DottedBorder(
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
                                color: isLight(context) ? Colors.grey[100] : Colors.blueGrey[200],
                                shape: BoxShape.circle,
                              ),
                              child: KS.shared.user.id == meetup!.owner.id
                                  ? Icon(
                                      Feather.plus,
                                      color: isLight(context) ? Colors.blueGrey : Colors.white,
                                    )
                                  : SizedBox(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return 16.width;
                },
                itemCount: meetup!.maxPeople!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailsTab() {
    return Stack(
      children: [
        EasyRefresh.custom(
          key: PageStorageKey('detailsTab'),
          header: MaterialHeader(
            valueColor: AlwaysStoppedAnimation<Color>(mainColor),
          ),
          slivers: [buildMainInfo(), buildMap(), buildMember(), SliverPadding(padding: EdgeInsets.only(bottom: 64.0))],
          onRefresh: () async {
            fetchMeetup();
          },
        ),
        if (isMeetupAvailable()) ...[
          (meetup!.owner.id != KS.shared.user.id && joinMember.length < meetup!.maxPeople!) || (meetup!.owner.id != KS.shared.user.id && isJoined)
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 64.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border(top: BorderSide(width: 0.5, color: Colors.black.withOpacity(0.1))),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: isJoined ? leaveGame : joinGame,
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: MaterialStateProperty.all(isJoined ? Colors.grey[200] : mainColor),
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
        ]
      ],
    );
  }

  TextEditingController _commentController = TextEditingController();

  Widget bottomCommentAction() {
    return Container(
      height: 64.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border(top: BorderSide(width: 0.5, color: Colors.black12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.blueGrey[200]!),
              ),
              child: TextField(
                controller: _commentController,
                // focusNode: _commentTextNode,
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 6,
                minLines: 1,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Add a comment',
                    hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: isLight(context) ? Colors.blueGrey : Colors.blueGrey[100])),
                onChanged: (value) {
                  setState(() {});
                },
                onTap: () {},
              ),
            ),
          ),
          CupertinoButton(
            child: _commentController.text.trim().isNotEmpty
                ? Icon(Icons.send, color: mainColor)
                : Text('👍', style: Theme.of(context).textTheme.headline5),
            padding: EdgeInsets.zero,
            onPressed: sendComment,
          )
        ],
      ),
    );
  }

  Widget discussionTab() {
    return Stack(
      children: [
        CupertinoScrollbar(
          isAlwaysShown: true,
          child: EasyRefresh.custom(
            header: MaterialHeader(valueColor: AlwaysStoppedAnimation(mainColor)),
            slivers: [
              discussionList.isNotEmpty
                  ? SliverPadding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final discussion = discussionList[index];

                          return DiscussionCell(discussion: discussion);
                        }, childCount: discussionList.length),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(top: 100),
                        child: Center(child: Text('No any discussion yet!')),
                      ),
                    )
            ],
            onRefresh: () async {},
          ),
        ),
        Positioned(bottom: 0, child: bottomCommentAction()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container();
    }

    return WillPopScope(
      onWillPop: () async {
        dismissScreen(context, meetup);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: SizedBox(
                height: 44.0,
                child: Marquee(
                  text: meetup!.title,
                  // startPadding: 50.0,
                  blankSpace: 50.0,
                  startAfter: Duration(milliseconds: 1500),
                  pauseAfterRound: Duration(seconds: 1),
                  accelerationDuration: Duration(seconds: 2),
                ),
              ),
              titleTextStyle: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w400),
              elevation: 0.3,
              actions: [
                // CupertinoButton(
                //   child: Icon(FeatherIcons.moreVertical, color: isLight(context) ? Colors.grey[600] : whiteColor),
                //   onPressed: () => showMeetupBottomSheet(meetup!),
                // )
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(Icons.share, color: isLight(context) ? Colors.grey[600] : whiteColor),
                  onPressed: () {
                    if( meetup != null){
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.9),
                          context: context, builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: ShareMeetupScreen(post: meetup!));
                        });
                    }
                  },
                )
              ],
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                    indicatorColor: mainColor,
                    isScrollable: true,
                    tabs: [
                      Tab(text: 'Details'),
                      Tab(text: 'Discussion'),
                    ],
                    onTap: (index) {
                      // if (index == 1) {
                      //   scrollToBottom();
                      // }
                    },
                  ),
                ),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            body: meetup != null
                ? TabBarView(
                    // key: new PageStorageKey('myTabBarView'),
                    children: [
                      detailsTab(),
                      // discussionTab(),
                      isJoined
                          ? Stack(
                              children: [
                                discussionList.isNotEmpty
                                    ? DiscussionTab(
                                        discussionList: discussionList,
                                        controller: _scrollController,
                                      )
                                    : Container(
                                        child: Center(
                                          child: Text('No any discussion yet!'),
                                        ),
                                      ),
                                Positioned(bottom: 0, child: bottomCommentAction()),
                              ],
                            )
                          : Container(
                              child: Center(
                                child: Text('Only joined member can discuss here.'),
                              ),
                            ),
                    ],
                  )
                : SizedBox(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.meetup is Post) {
      isLoading = false;
      meetup = widget.meetup;

      channel = IOWebSocketChannel.connect((DEBUG ? DEV_WS : PRO_WS) + '/ws/meetup/message/${meetup!.id}/', headers: {'x-key': ksClient.token()});

      channel.stream.listen((message) {
        var data = jsonDecode(message.toString());
        var newDiscussion = Discussion.fromJson(data['message']);
        discussionList.add(newDiscussion);
        setState(() {});
      });

      getDiscussion();

      joinMember = meetup!.meetupMember!.where((element) => element.status == 1).toList();
      isJoined = joinMember.any((e) => e.user.id == KS.shared.user.id);
    } else if (widget.meetup is int) {
      isLoading = true;
      fetchMeetup(id: widget.meetup);
    }
  }

  bool isMeetupAvailable() {
    var meetupDate = DateFormat('yyyy-MM-dd').parse(meetup!.activityDate!);
    if (DateTime.now().isAfter(meetupDate)) {
      return false;
    }

    return true;
  }

  void fetchMeetup({int? id}) {
    var meetupId = id ?? meetup!.id;
    ksClient.getApi('/view/meetup/post/$meetupId').then((value) {
      if (value != null) {
        if (value is! HttpResult) {
          meetup = Post.fromJson(value['post']);

          joinMember = meetup!.meetupMember!.where((element) => element.status == 1).toList();

          isJoined = meetup!.meetupMember!.any((e) => e.user.id == KS.shared.user.id);
          isJoined = joinMember.any((e) => e.user.id == KS.shared.user.id);
          isLoading = false;
          isShowMap = true;
          setState(() {});
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void dispose() {
    if (widget.meetup is Post) {
      channel.sink.close();
    }
    super.dispose();
  }

  void joinGame() {
    showKSConfirmDialog(context, message: 'Are you sure you want to join the game?', onYesPressed: () async {
      showKSLoading(context);
      var result = await ksClient.postApi('/join/post/meetup/${meetup!.id}');
      if (result != null) {
        if (result is! HttpResult) {
          var res = await ksClient.getApi('/view/meetup/post/${meetup!.id}');
          if (res != null) {
            dismissScreen(context);
            if (res is! HttpResult) {
              meetup = Post.fromJson(res['post']);
              // widget.meetup.meetupMember = meetup.meetupMember;
              joinMember = meetup!.meetupMember!.where((element) => element.status == 1).toList();
              isJoined = true;
              BlocProvider.of<MeetupCubit>(context).onRefresh();
              setState(() {});
            }
          }
        }
      }
    });
  }

  void leaveGame() {
    showKSConfirmDialog(
      context,
      message: 'Are you sure you want to leave the game?',
      onYesPressed: () async {
        showKSReasonDialog(
          context,
          title: 'Tell the reason why you want to leave:',
          onSubmit: () async {
            showKSLoading(context);
            var result = await ksClient.postApi('/leave/post/meetup/${meetup!.id}');
            if (result != null) {
              if (result is! HttpResult) {
                var res = await ksClient.getApi('/view/meetup/post/${meetup!.id}');
                if (res != null) {
                  dismissScreen(context);
                  if (res is! HttpResult) {
                    meetup = Post.fromJson(res['post']);
                    // widget.meetup.meetupMember = meetup.meetupMember;
                    joinMember = meetup!.meetupMember!.where((element) => element.status == 1).toList();
                    isJoined = false;
                    BlocProvider.of<MeetupCubit>(context).onRefresh();
                    setState(() {});
                  }
                }
              }
            }
          },
        );
      },
    );
  }

  void showMeetupBottomSheet(Post meetup) {
    showKSBottomSheet(context, children: [
      if (isMeetupAvailable()) ...[
        isMe(meetup.owner.id)
            ? KSTextButtonBottomSheet(
                title: 'Connect with booking',
                icon: Feather.link_2,
                onTab: () async {
                  dismissScreen(context);
                  var booked = await launchScreen(context, ConnectBookingScreen.tag, arguments: meetup);
                  meetup.book = booked;
                  setState(() {});
                },
              )
            : SizedBox()
      ],
      if (isMe(meetup.owner.id) && isMeetupAvailable())
        KSTextButtonBottomSheet(
          title: 'Edit',
          icon: Feather.edit,
          onTab: () {
            dismissScreen(context);
            launchScreen(context, OragnizeActivityScreen.tag, arguments: meetup);
          },
        ),
      if (isMe(meetup.owner.id) && meetup.status == PostStatus.active)
        KSTextButtonBottomSheet(
          title: 'Cancel',
          icon: Feather.x,
          onTab: () {
            dismissScreen(context);
            showKSConfirmDialog(
              context,
              message: 'Are you sure you want to cancel this meetup?',
              onYesPressed: () {
                // deleteMeetup();
                cancelMeetup();
              },
            );
          },
        ),
      KSTextButtonBottomSheet(
        title: 'Report Meetup',
        icon: Feather.info,
        onTab: () {
          dismissScreen(context);
          showReportScreen(context, title: 'You reported a meetup.');
        },
      ),
    ]);
  }

  void deleteMeetup() async {
    showKSLoading(context);
    var result = await ksClient.postApi('/delete/post/${meetup!.id}');
    if (result != null) {
      await Future.delayed(Duration(milliseconds: 500));
      dismissScreen(context);
      if (result is! HttpResult) {
        BlocProvider.of<MeetupCubit>(context).onDeleteMeetup(result['id']);
        BlocProvider.of<AccountCubit>(context).onDeleteMeetup(result['id']);
        dismissScreen(context);
      }
    }
  }

  void cancelMeetup() async {
    if (!isMeetupAvailable()) {
      _showToast(context);
      return;
    }

    if (meetup!.book != null) {
      showKSMessageDialog(
        context,
        message: 'Please disconnect booking from Meetup before cancel!',
        buttonTitle: 'OK',
      );
      return;
    }

    showKSLoading(context);
    var result = await ksClient.postApi('/cancel/post/meetup/${meetup!.id}');
    if (result != null) {
      await Future.delayed(Duration(milliseconds: 300));
      dismissScreen(context);
      fetchMeetup();
    }
  }

  void sendComment() {
    if (_commentController.text.isNotEmpty) {
      channel.sink.add(jsonEncode({'message': _commentController.text}));
      _commentController.clear();
      FocusScope.of(context).unfocus();
    } else {
      channel.sink.add(jsonEncode({'message': '👍'}));
    }
  }

  void getDiscussion() async {
    var res = await ksClient.getApi('/meetup/message/${widget.meetup.id}');
    if (res != null) {
      if (res is! HttpResult) {
        discussionList = (res as List).map((e) => Discussion.fromJson(e)).toList();
        discussionList = List.from(discussionList.reversed);
        isShowMap = true;
        Future.delayed(Duration(milliseconds: 300)).then((_) => setState(() {}));
      }
    }
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.orange[400], //Color(0xFF696969),
        behavior: SnackBarBehavior.floating,
        content: Text('Meetup Expired', style: Theme.of(context).textTheme.bodyText2),
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        // action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  ScrollController _scrollController = ScrollController();

  // void scrollToBottom() {
  //   Future.delayed(Duration(milliseconds: 300)).then((value) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   });
  // }
}

class DiscussionTab extends StatelessWidget {
  final List<Discussion> discussionList;
  final ScrollController? controller;

  DiscussionTab({required this.discussionList, this.controller});

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: controller!,
      child: CupertinoScrollbar(
        isAlwaysShown: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 64.0),
          child: EasyRefresh.custom(
            header: MaterialHeader(valueColor: AlwaysStoppedAnimation(mainColor)),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 0.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final discussion = discussionList[index];

                    return DiscussionCell(discussion: discussion);
                  }, childCount: discussionList.length),
                ),
              )
            ],
            onRefresh: () async {},
          ),
        ),
      ),
    );
  }
}
