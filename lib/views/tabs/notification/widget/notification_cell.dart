import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';

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
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontWeight: FontWeight.w600),
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
