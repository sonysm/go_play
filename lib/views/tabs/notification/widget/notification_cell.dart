import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/models/notification.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/detail_screen.dart';
import 'package:kroma_sport/views/tabs/account/view_user_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_detail_screen.dart';
import 'package:kroma_sport/views/tabs/venue/booking_history_detail.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class NotificationCell extends StatelessWidget {
  final KSNotification notification;

  const NotificationCell({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 54.0,
            child: Icon(Icons.notifications_none),
          ),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title!,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w600),
              ),
              4.height,
              Text(
                notification.createdAt.toString().timeAgoString,
                style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BookingNotificationCell extends StatelessWidget {
  final KSNotification notification;
  final Function onClick;
  const BookingNotificationCell({Key? key, required this.notification, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () {
            launchScreen(context, BookingHistoryDetailScreen.tag, arguments: {'id': notification.otherId});
            onClick(notification.id);
        },
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 54.0,
                child: Icon(FeatherIcons.info),
              ),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title!,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  4.height,
                  Text(
                    notification.createdAt.toString().timeAgoString,
                    style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FollowingNoticationCell extends StatelessWidget {
  final KSNotification notification;
  final Function onClick;
  const FollowingNoticationCell({Key? key, required this.notification, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () {
            launchScreen(context, ViewUserProfileScreen.tag, arguments: {'user': notification.actor});
            onClick(notification.id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 54.0,
                height: 54.4,
                child: Avatar(
                  radius: 32.0,
                  user: notification.actor!,
                  isSelectable: false,
                ),
              ),
              10.width,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title!,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      notification.createdAt.toString().timeAgoString,
                      style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.grey),
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
}

class InviteNoticationCell extends StatelessWidget {
  final KSNotification notification;
  final Function onClick;
  const InviteNoticationCell({Key? key, required this.notification, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: (){
            launchScreen(context, MeetupDetailScreen.tag, arguments: notification.post);
            onClick(notification.id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 54.0,
                height: 54.4,
                child: Avatar(
                  radius: 32.0,
                  user: notification.actor!,
                  isSelectable: false,
                ),
              ),
              10.width,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title!,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      notification.updatedAt.toString().timeAgoString,
                      style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.grey),
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
}

class CommentNoticationCell extends StatelessWidget {
  final KSNotification notification;
  final Function onClick;
  const CommentNoticationCell({Key? key, required this.notification, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: (){
            launchScreen(context, DetailScreen.tag, arguments: {'postId': notification.post});
            onClick(notification.id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 54.0,
                height: 54.4,
                child: Avatar(
                  radius: 32.0,
                  user: notification.actor!,
                  isSelectable: false,
                ),
              ),
              10.width,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title!,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      notification.updatedAt.toString().timeAgoString,
                      style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.grey),
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
}


class LikeNoticationCell extends StatelessWidget {
  final KSNotification notification;
  final Function onClick;
  const LikeNoticationCell({Key? key, required this.notification, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () {
            launchScreen(context, DetailScreen.tag, arguments: {'postId': notification.post});
            onClick(notification.id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 54.0,
                height: 54.4,
                child: Avatar(
                  radius: 32.0,
                  user: notification.actor!,
                  isSelectable: false,
                ),
              ),
              10.width,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title!,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      notification.updatedAt.toString().timeAgoString,
                      style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.grey),
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
}