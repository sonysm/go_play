import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/account.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/member.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/report_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_detail_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_activity_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:line_icons/line_icons.dart';

class MeetupCell extends StatefulWidget {
  final Post post;
  final int index;
  final bool isAvatarSelectable;
  final bool isMeetupFeed;

  MeetupCell({
    Key? key,
    required this.post,
    required this.index,
    this.isAvatarSelectable = true,
    this.isMeetupFeed = true,
  }) : super(key: key);

  @override
  _MeetupCellState createState() => _MeetupCellState();
}

class _MeetupCellState extends State<MeetupCell> {
  late Post meetup;
  late List<Member> joinMember;

  // late HomeCubit _homeCubit;
  late MeetupCubit _meetupCubit;

  KSHttpClient ksClient = KSHttpClient();

  Widget buildTotalReaction(int total) {
    return total > 0 ? Text(total > 1 ? '$total likes' : '$total like') : SizedBox();
  }

  Widget buildTotalComment(int total) {
    return total > 0 ? Text(total > 1 ? '$total comments' : '$total comment') : SizedBox();
  }

  @override
  void didUpdateWidget(MeetupCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post != oldWidget.post) {
      meetup = widget.post;
      joinMember = widget.post.meetupMember!.where((element) => element.status == 1).toList();
      setState(() {});
    }
  }

  bool isMeetupAvailable() {
    var meetupDate = DateFormat('yyyy-MM-dd').parse(meetup.activityDate!);
    if (DateTime.now().isAfter(meetupDate)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: () async {
          var data = await launchScreen(context, MeetupDetailScreen.tag, arguments: widget.post);
          if (data != null) {
            meetup = data as Post;
            joinMember = data.meetupMember!.where((element) => element.status == 1).toList();
            setState(() {});
          }
        },
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
                    isSelectable: widget.isAvatarSelectable,
                    onTap: (user) {
                      widget.post.owner = user;
                      setState(() {});
                    },
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
                                      text: widget.post.owner.getFullname(),
                                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: ' is hosting ',
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                    TextSpan(
                                      text: widget.post.title,
                                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        4.height,
                        Text(
                          widget.post.createdAt.toString().timeAgoString,
                          style: Theme.of(context).textTheme.caption!.copyWith(color: isLight(context) ? Colors.blueGrey[400] : Colors.blueGrey[100]),
                        ),
                      ],
                    ),
                  ),
                  KSIconButton(
                    icon: FeatherIcons.moreHorizontal,
                    iconSize: 24.0,
                    onTap: () => showOptionActionBottomSheet(widget.post),
                  ),
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
                      meetup.sport!.name + ' Meetup',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.w600, color: isLight(context) ? mainColor : Colors.white70),
                    ),
                  ),
                  Divider(),
                  widget.post.description != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: SelectableText(
                            widget.post.description!,
                            style: Theme.of(context).textTheme.bodyText1,
                            onTap: () {},
                          ),
                        )
                      : SizedBox(),
                  // Divider(),
                  Text(
                    'Members Joined',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: isLight(context) ? Colors.grey[600] : Colors.white70),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(meetup.maxPeople!, (index) {
                        if (index <= joinMember.length - 1) {
                          return CircleAvatar(
                            radius: 18,
                            backgroundColor: isLight(context) ? Colors.amber : whiteColor,
                            child: Avatar(
                              radius: 16,
                              user: joinMember.elementAt(index).user,
                              isSelectable: joinMember.elementAt(index).user.id != KS.shared.user.id,
                            ),
                          );
                        }

                        return DottedBorder(
                          color: isLight(context) ? Colors.blueGrey : whiteColor,
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
                              color: isLight(context) ? Colors.grey[100] : Colors.blueGrey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  meetup.price! > 0
                      ? RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: meetup.price.toString() + ' USD',
                                style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: ' /person',
                                style: Theme.of(context).textTheme.bodyText2?.copyWith(color: isLight(context) ? Colors.blueGrey : Colors.white70),
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
                        color: isLight(context) ? Colors.grey[700] : Colors.grey[300]!,
                      ),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DateFormat('EEE dd MMM').format(DateTime.parse(meetup.activityDate!))}, ${DateFormat('h:mm a').format(DateTime.parse(meetup.activityDate! + ' ' + meetup.activityStartTime!))} - ${DateFormat('h:mm a').format(DateTime.parse(meetup.activityDate! + ' ' + meetup.activityEndTime!))}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            'One time activity',
                            style: Theme.of(context).textTheme.caption?.copyWith(color: isLight(context) ? Colors.blueGrey : Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (meetup.activityLocation != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Feather.map_pin,
                            size: 16.0,
                            color: isLight(context) ? Colors.grey[700] : Colors.grey[300]!,
                          ),
                          8.width,
                          Flexible(
                            child: Text(
                              meetup.activityLocation!.name,
                              style: Theme.of(context).textTheme.bodyText2,
                              strutStyle: StrutStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  meetup.book != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Feather.bookmark,
                                size: 16.0,
                                color: isLight(context) ? Colors.grey[700] : Colors.grey[300]!,
                              ),
                              8.width,
                              Text(
                                'Field booked',
                                style: Theme.of(context).textTheme.bodyText2,
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
                        color: isLight(context) ? Colors.grey[700] : Colors.grey[300]!,
                      ),
                      8.width,
                      meetup.status == PostStatus.active
                          ? Text(
                              isMeetupAvailable() ? 'Meetup Available' : 'Meetup Expired',
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(color: isMeetupAvailable() ? mainColor : Colors.amber[700]),
                              strutStyle: StrutStyle(fontSize: 14.0),
                            )
                          : Text(
                              'Meetup Canceled',
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.red),
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
    );
  }

  @override
  void initState() {
    super.initState();
    meetup = widget.post;

    // _homeCubit = context.read<HomeCubit>();
    _meetupCubit = context.read<MeetupCubit>();

    joinMember = meetup.meetupMember!.where((element) => element.status == 1).toList();
  }

  void showOptionActionBottomSheet(Post post) {
    showKSBottomSheet(context, children: [
      if (isMe(meetup.owner.id) && isMeetupAvailable())
        KSTextButtonBottomSheet(
          title: 'Edit',
          icon: Feather.edit,
          onTab: () {
            dismissScreen(context);
            launchScreen(context, OragnizeActivityScreen.tag, arguments: meetup);
          },
        ),
      if (isMe(post.owner.id) && meetup.status == PostStatus.active)
        KSTextButtonBottomSheet(
          title: 'Cancel Meetup',
          icon: Feather.x,
          onTab: () {
            dismissScreen(context);
            showKSConfirmDialog(
              context,
              message: 'Are you sure you want to cancel this Meetup?',
              onYesPressed: () {
                // deleteMeetup();
                cancelMeetup();
              },
            );
          },
        ),
      if (!isMe(post.owner.id) && widget.isMeetupFeed) ...[
        KSTextButtonBottomSheet(
          title: 'Hide Meetup',
          icon: LineIcons.minusCircle,
          iconSize: 24.0,
          onTab: () {
            dismissScreen(context);
            showKSConfirmDialog(
              context,
              message: 'Are you sure you want to hide this post?',
              onYesPressed: () {
                _meetupCubit.onHideMeetup(post.id);
                showKSSnackBar(
                  context,
                  title: 'This meetup is no longer show to you.',
                  action: true,
                  actionTitle: 'Undo',
                  onAction: () {
                    _meetupCubit.onUndoHidingMeetup(index: widget.index, post: post);
                  },
                );
              },
            );
          },
        ),
        KSTextButtonBottomSheet(
          title: 'Unfollow ${post.owner.getFullname()}',
          icon: LineIcons.userMinus,
          iconSize: 24.0,
          onTab: () {
            dismissScreen(context);
            showKSConfirmDialog(
              context,
              message: 'Are you sure you want to unfollow ${post.owner.getFullname()}?',
              onYesPressed: () async {
                var res = await ksClient.postApi('/user/unfollow/${post.owner.id}');
                if (res != null) {
                  if (res is! HttpResult) {}
                }
              },
            );
          },
        ),
        /*KSTextButtonBottomSheet(
          title: 'Block ${post.owner.getFullname()}',
          icon: LineIcons.ban,
          iconSize: 24.0,
          onTab: () {
            dismissScreen(context);
            showKSConfirmDialog(
              context,
              message: 'Are you sure you want to block ${post.owner.getFullname()}?',
              onYesPressed: () {
                // var res =
                //     await ksClient.postApi('/user/unfollow/${post.owner.id}');
                // if (res != null) {
                //   if (res is! HttpResult) {}
                // }
                showKSLoading(context);
                Future.delayed(Duration(seconds: 1), () {
                  _meetupCubit.onBlockUser(post.owner.id);
                  _homeCubit.onBlockUser(post.owner.id);
                  dismissScreen(context);
                });
              },
            );
          },
        ),*/
      ],
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
    var result = await ksClient.postApi('/delete/post/${widget.post.id}');
    if (result != null) {
      await Future.delayed(Duration(milliseconds: 300));
      dismissScreen(context);
      if (result is! HttpResult) {
        BlocProvider.of<MeetupCubit>(context).onDeleteMeetup(result['id']);
        BlocProvider.of<AccountCubit>(context).onDeleteMeetup(result['id']);
      }
    }
  }

  void cancelMeetup() async {
    if (!isMeetupAvailable()) {
      // dismissScreen(context);
      _showToast(context);
      return;
    }

    if (meetup.book != null) {
      showKSMessageDialog(
        context,
        message: 'Please disconnect booking from Meetup before cancel!',
        buttonTitle: 'OK',
      );
      return;
    }

    showKSLoading(context);
    var result = await ksClient.postApi('/cancel/post/meetup/${widget.post.id}');
    if (result != null) {
      await Future.delayed(Duration(milliseconds: 300));
      dismissScreen(context);
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
}
