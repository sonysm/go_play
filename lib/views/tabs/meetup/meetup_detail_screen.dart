import 'dart:convert';

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
import 'package:kroma_sport/models/discussion.dart';
import 'package:kroma_sport/models/member.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/meetup/widget/discussion_cell.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_reason_dialog.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:web_socket_channel/io.dart';

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
  late bool isJoined;

  KSHttpClient ksClient = KSHttpClient();

  late IOWebSocketChannel channel;

  List<Discussion> discussionList = [];

  bool isShowMap = false;

  Widget buildMainInfo() {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            ListTile(
              dense: true,
              horizontalTitleGap: 0,
              leading: Icon(Feather.align_left),
              title: Text(meetup.sport!.name,
                  style: Theme.of(context).textTheme.bodyText2),
              subtitle: Text(meetup.title,
                  style: Theme.of(context).textTheme.headline6),
            ),
            ListTile(
              dense: true,
              horizontalTitleGap: 0,
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
              horizontalTitleGap: 0,
              leading: Icon(Feather.map_pin),
              title: Text(meetup.activityLocation!.name,
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            ListTile(
              dense: true,
              horizontalTitleGap: 0,
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
        color: Colors.grey[200],
        width: AppSize(context).appWidth(100),
        child: isShowMap ? GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              double.parse(meetup.activityLocation!.latitude),
              double.parse(meetup.activityLocation!.longitude),
            ),
            zoom: 15.0,
          ),
          onMapCreated: (controller) {},
          zoomGesturesEnabled: false,
          scrollGesturesEnabled: false,
          markers: <Marker>{
            Marker(
                markerId: MarkerId('venue'),
                position: LatLng(
                    double.parse(meetup.activityLocation!.latitude),
                    double.parse(meetup.activityLocation!.longitude))),
          },
        ) : SizedBox(),
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
                'Going(${joinMember.length}/${meetup.maxPeople})',
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
                              isSelectable:
                                  joinMember.elementAt(index).user.id !=
                                      KS.shared.user.id,
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

  Widget detailsTab() {
    return Stack(
      children: [
        EasyRefresh.custom(
          key: PageStorageKey('detailsTab'),
          header: MaterialHeader(
            valueColor: AlwaysStoppedAnimation<Color>(mainColor),
          ),
          slivers: [
            buildMainInfo(),
            buildMap(),
            buildMember(),
            SliverPadding(padding: EdgeInsets.only(bottom: 64.0))
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
                    hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: isLight(context)
                            ? Colors.blueGrey
                            : Colors.blueGrey[100])),
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
            header:
                MaterialHeader(valueColor: AlwaysStoppedAnimation(mainColor)),
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
    return WillPopScope(
      onWillPop: () async {
        dismissScreen(context, widget.meetup);
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
              title: Text(meetup.title),
              elevation: 0.5,
              actions: [
                CupertinoButton(
                  child: Icon(FeatherIcons.moreVertical,
                      color: isLight(context) ? Colors.grey[600] : whiteColor),
                  onPressed: () => showMeetupBottomSheet(widget.meetup),
                )
              ],
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                    ),
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
            body: TabBarView(
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
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    channel = IOWebSocketChannel.connect(
        'ws://165.232.160.96:8080/ws/meetup/message/${widget.meetup.id}/',
        headers: {'x-key': ksClient.token()});

    channel.stream.listen((message) {
      var data = jsonDecode(message.toString());
      var newDiscussion = Discussion.fromJson(data['message']);
      discussionList.add(newDiscussion);
      setState(() {});
    });

    getDiscussion();

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

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
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
              BlocProvider.of<MeetupCubit>(context).onRefresh();
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
      showKSReasonDialog(
        context,
        title: 'Tell the reason why you want to leave:',
        onSubmit: () async {
          showKSLoading(context);
          var result =
              await ksClient.postApi('/leave/post/meetup/${meetup.id}');
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
                  BlocProvider.of<MeetupCubit>(context).onRefresh();
                  setState(() {});
                }
              }
            }
          }
        },
      );
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
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                bottomSheetBar(context),
                isMe(meetup.owner.id)
                    ? KSTextButtonBottomSheet(
                        title: 'Delete Meetup',
                        icon: Feather.trash_2,
                        onTab: () {
                          dismissScreen(context);
                          showKSConfirmDialog(context,
                              'Are you sure you want to delete this meetup?',
                              () {
                            deleteMeetup();
                          });
                        },
                      )
                    : SizedBox(),
                KSTextButtonBottomSheet(
                  title: 'Report Meetup',
                  icon: Feather.info,
                  onTab: () {
                    dismissScreen(context);
                  },
                ),
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
        discussionList =
            (res as List).map((e) => Discussion.fromJson(e)).toList();
        discussionList = List.from(discussionList.reversed);
        isShowMap = true;
        Future.delayed(Duration(milliseconds: 300)).then((_) => setState(() {}));
      }
    }
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
            header:
                MaterialHeader(valueColor: AlwaysStoppedAnimation(mainColor)),
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
