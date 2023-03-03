
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/views/tabs/home/widget/activity_cell.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_feed_cell.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';

class SliverHomeFeedList extends StatelessWidget {
  final HomeData homeState;
  const SliverHomeFeedList({Key? key, required this.homeState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegExp urlRegExp = RegExp(
      r"((https?:www\.)|(https?:\/\/)|(www\.))?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?",
      caseSensitive: false,
    );

    final _protocolIdentifierRegex = RegExp(
      r'^(https?:\/\/)',
      caseSensitive: false,
    );

    if (homeState.status == DataState.ErrorSocket && homeState.data.isEmpty) {
      return SliverFillRemaining(
        child: KSNoInternet(),
      );
    }

    return homeState.status == DataState.Loading
        ? SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.greenAccent)),
            ),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var post = homeState.data.elementAt(index);

                if (post.type == PostType.feed) {
                  String? _urlInfo;
                  if (post.description != null) {
                    final urlMatches = urlRegExp.allMatches(post.description!);

                    List<String> urls = urlMatches.map((urlMatch) => post.description!.substring(urlMatch.start, urlMatch.end)).toList();
                    if (urls.isNotEmpty) {
                      _urlInfo = urls.elementAt(0);

                      if (!_urlInfo.startsWith(_protocolIdentifierRegex)) {
                        _urlInfo = (LinkifyOptions().defaultToHttps ? "https://" : "http://") + _urlInfo;
                      }
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: HomeFeedCell(
                      index: index,
                      post: post,
                      key: Key("home${post.id}"),
                      isHomeFeed: true,
                    ),
                  );
                } else if (post.type == PostType.activity) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ActivityCell(
                      index: index,
                      post: post,
                      key: Key(
                        post.id.toString(),
                      ),
                    ),
                  );
                }
                return SizedBox();
              },
              childCount: homeState.data.length,
            ),
          );
  }
}
