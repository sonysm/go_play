import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/view_user_screen.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/search/search_result_cell.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class SearchScreen extends StatefulWidget {
  static const tag = '/search';
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textController = TextEditingController();
  late FocusNode _searchFocusScop;
  bool? _isSearching;

  KSHttpClient _ksHttpClient = KSHttpClient();
  List<dynamic> _resultList = [];

  Widget searchingWidget() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38.0,
              height: 38.0,
              color: Colors.transparent,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getMainColor(context)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Loading...',
                // style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget resultListWidget() {
    return _resultList.isNotEmpty
        ? ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16.0),
            itemBuilder: (context, index) {
              final result = _resultList.elementAt(index);

              final avatarBgColor = Color.fromARGB(
                Random().nextInt(256),
                Random().nextInt(256),
                Random().nextInt(256),
                Random().nextInt(256),
              );

              if (result is Post) {
                return SearchResultCell(
                  post: result,
                  onTap: () async {
                    var res = await launchScreen(context, FeedDetailScreen.tag, arguments: {
                      'post': result,
                      'postIndex': -1,
                      'isCommentTap': false,
                    });
                    if (res != null && res == 1) {
                      onSearch(_textController.text);
                    }
                  },
                );
              } else if (result is User) {
                return InkWell(
                  onTap: () {
                    launchScreen(context, ViewUserProfileScreen.tag, arguments: {'user': result, 'backgroundColor': avatarBgColor});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Avatar(radius: 20, user: result, backgroundcolor: avatarBgColor,),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(result.getFullname(), style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SizedBox();
            },
            separatorBuilder: (context, index) {
              return Divider(height: 0);
            },
            itemCount: _resultList.length,
          )
        : Center(
            child: Text('No result found.'),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorResources.getPrimary(context),
      appBar: AppBar(
        elevation: 0.3,
        titleSpacing: 0,
        title: Container(
          height: 38,
          margin: const EdgeInsets.only(right: 16.0),
          child: TextField(
            controller: _textController,
            focusNode: _searchFocusScop,
            onSubmitted: onSearch,
            textInputAction: TextInputAction.search,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(fontFamily: 'OpenSans', color: blackColor),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              hintText: "Search",
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Colors.transparent,
          child: _isSearching != null
              ? _isSearching!
                  ? searchingWidget()
                  : resultListWidget()
              : SizedBox(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchFocusScop = FocusNode();
    _searchFocusScop.requestFocus();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void dispose() {
    _searchFocusScop.dispose();
    super.dispose();
  }

  void onSearch(String? keyword) {
    FocusScope.of(context).unfocus();
    _isSearching = true;
    setState(() {});
    _ksHttpClient.getApi('/user/activity/search', queryParameters: {'keyword': keyword}).then((data) {
      if (data != null && data is! HttpResult) {
        _resultList = (data as List).map((e) {
          if (e['owner'] != null) {
            return Post.fromJson(e);
          } else {
            return User.fromJson(e);
          }
        }).toList();
      }

      Future.delayed(Duration(seconds: 0), () {
        setState(() => _isSearching = false);
      });
    });
  }
}

class SearchResultWidget extends StatelessWidget {
  const SearchResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('No result found'),
      ),
    );
  }
}
