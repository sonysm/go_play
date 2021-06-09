import 'package:flutter/material.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/discussion.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class DiscussionCell extends StatelessWidget {
  final Discussion discussion;

  const DiscussionCell({Key? key, required this.discussion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(radius: 20.0, user: discussion.sender),
          8.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: discussion.sender.getFullname() + ' ',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: discussion.content,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
                4.height,
                Text(discussion.createdAt.toString().timeAgoString,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(color: isLight(context) ? Colors.grey[600]: Colors.grey[400])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
