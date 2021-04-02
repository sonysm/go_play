import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class HomeFeedCell extends StatelessWidget {
  const HomeFeedCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Avatar(
                    radius: 18.0,
                    imageUrl:
                        'https://images.unsplash.com/photo-1581803118522-7b72a50f7e9f?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Logan Weaver',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    4.height,
                    Text(
                      'a day ago',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Colors.blueGrey[200]),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  FeatherIcons.moreHorizontal,
                  size: 18.0,
                ),
              ],
            ),
          ),
          // Flexible(
          //     child: Text(
          //   'Hello crush!',
          //   style: Theme.of(context).textTheme.bodyText2,
          // )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hello crush!',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: CachedNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1562552052-c72ceddf93dc?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
          ),
          HFButtomAction(),
        ],
      ),
    );
  }
}

class HFButtomAction extends StatelessWidget {
  const HFButtomAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget actionBtn({required IconData icon}) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: Colors.blueGrey),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FeatherIcons.heart, color: Colors.blueGrey),
                  ),
                ),
              ),
              4.width,
              actionBtn(icon: FeatherIcons.messageSquare),
              4.width,
              actionBtn(icon: FeatherIcons.share2),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(
                    radius: 12.0,
                    imageUrl:
                        'https://images.unsplash.com/photo-1581803118522-7b72a50f7e9f?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'),
                8.width,
                Expanded(
                  child: SizedBox(
                    height: 44.0,
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                        hintText: 'Add a comment',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
