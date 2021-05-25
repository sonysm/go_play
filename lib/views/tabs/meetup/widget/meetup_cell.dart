import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/utils/circle_border.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';

class MeetupCell extends StatefulWidget {
  final Post post;
  MeetupCell({Key? key, required this.post}) : super(key: key);

  @override
  _MeetupCellState createState() => _MeetupCellState();
}

class _MeetupCellState extends State<MeetupCell> {
  Widget buildTotalReaction(int total) {
    return total > 0
        ? Text(total > 1 ? '$total likes' : '$total like')
        : SizedBox();
  }

  Widget buildTotalComment(int total) {
    return total > 0
        ? Text(total > 1 ? '$total comments' : '$total comment')
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final meetup = widget.post;

    return InkWell(
      onTap: () {},
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
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
                    user: KS.shared.user,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: ' is hosting ',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    TextSpan(
                                      text: widget.post.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.post.createdAt.toString().timeAgoString,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color: isLight(context)
                                  ? Colors.blueGrey[400]
                                  : Colors.blueGrey[100]),
                        ),
                      ],
                    ),
                  ),
                  KSIconButton(
                    icon: FeatherIcons.moreHorizontal,
                    iconSize: 24.0,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meetup.sport!.name + ' Meetup',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  widget.post.description != null
                      ? SelectableText(
                          widget.post.description!,
                          style: Theme.of(context).textTheme.bodyText1,
                          onTap: () {},
                        )
                      : SizedBox(height: 8.0),
                  CircularBorder(
                    width: 2,
                    size: 32,
                    color: Colors.grey,
                    //icon: Icon(Icons.access_alarm, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           KSIconButton(
            //             icon: widget.post.reacted!
            //                 ? Icons.favorite
            //                 : FeatherIcons.heart,
            //             iconColor:
            //                 Theme.of(context).brightness == Brightness.light
            //                     ? widget.post.reacted!
            //                         ? Colors.green
            //                         : Colors.blueGrey
            //                     : widget.post.reacted!
            //                         ? Colors.green
            //                         : Colors.white,
            //             onTap: () {
            //               if (widget.post.reacted!) {
            //                 widget.post.totalReaction -= 1;
            //               } else {
            //                 widget.post.totalReaction += 1;
            //               }
            //               setState(() {
            //                 widget.post.reacted = !widget.post.reacted!;
            //                 reactPost();
            //               });
            //             },
            //           ),
            //           4.width,
            //           KSIconButton(
            //             icon: FeatherIcons.messageSquare,
            //             onTap: () {},
            //           ),
            //           4.width,
            //           KSIconButton(
            //             icon: FeatherIcons.share2,
            //             onTap: () {},
            //           ),
            //           Spacer(),
            //           buildTotalReaction(widget.post.totalReaction),
            //           8.width,
            //           buildTotalComment(widget.post.totalComment),
            //         ],
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 8.0, vertical: 8.0),
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Avatar(
            //               radius: 12.0,
            //               user: KS.shared.user,
            //             ),
            //             8.width,
            //             Expanded(
            //               child: InkWell(
            //                 onTap: () {},
            //                 child: Container(
            //                   height: 32.0,
            //                   padding:
            //                       const EdgeInsets.symmetric(horizontal: 8.0),
            //                   decoration: BoxDecoration(
            //                     border: Border.all(color: Color(0XFFB0BEC5)),
            //                     borderRadius: BorderRadius.circular(16.0),
            //                   ),
            //                   alignment: Alignment.centerLeft,
            //                   child: Text(
            //                     'Add a comment',
            //                     style: TextStyle(
            //                         color: isLight(context)
            //                             ? Colors.blueGrey[300]
            //                             : Colors.blueGrey[100]),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void reactPost() async {
    // var result =
    //     await ksClient.postApi('/create/post/reaction/${widget.post.id}');
    // if (result != null) {
    //   if (result is! HttpResult) {
    //     print('success!!!!');
    //   }
    // }
  }
}
