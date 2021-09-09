import 'package:flutter/material.dart';
import 'package:kroma_sport/models/notification.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_detail_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class NotificationCell extends StatelessWidget {
  const NotificationCell({Key? key}) : super(key: key);

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
            child: Image.asset(imgFootballField),
          ),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking success',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text('Downtown football club, court 2 for 1 hour'),
              4.height,
              Text(
                '25 mn ago',
                style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.grey),
              )
            ],
          )
        ],
      ),
    );
  }
}

class InviteNoticationCell extends StatelessWidget {
  final KSNotification notification;
  const InviteNoticationCell({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () => launchScreen(context, MeetupDetailScreen.tag, arguments: notification.post),
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
