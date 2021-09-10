import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';

class SearchScreen extends StatefulWidget {
  static const tag = '/search';
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textController = TextEditingController();
  late FocusNode _searchFocusScop;
  bool? _isSearched;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
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
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                ),
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
          ),
        )
        /*SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  decoration:
                      BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: isLight(context) ? Colors.black12 : Colors.white12))),
                  child: Row(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.only(right: 16.0),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isLight(context) ? Colors.blueGrey[50] : Colors.blueGrey,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            FeatherIcons.arrowLeft,
                            size: 20.0,
                            color: Theme.of(context).brightness == Brightness.light ? Colors.grey[600] : whiteColor,
                          ),
                        ),
                        onPressed: () {
                          dismissScreen(context);
                        },
                      ),
                      Expanded(
                        child: Container(
                          height: 44.0,
                          decoration:
                              BoxDecoration(color: isLight(context) ? Colors.blueGrey[50] : Colors.blueGrey, borderRadius: BorderRadius.circular(50)),
                          child: TextField(
                            controller: _textController,
                            focusNode: _searchFocusScop,
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 5),
                              hintText: 'Search',
                              hintStyle: TextStyle(fontSize: 16.0),
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: onSearch,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(child: _isSearched != null ? SearchResultWidget() : SizedBox()),
              ],
            ),
          ),
        ),
      ),*/
        );
  }

  @override
  void initState() {
    super.initState();
    _searchFocusScop = FocusNode();
    _searchFocusScop.requestFocus();
  }

  @override
  void dispose() {
    _searchFocusScop.dispose();
    super.dispose();
  }

  void onSearch(String? text) {
    print('________$text');
    showKSLoading(context, message: 'Loading...');
    Future.delayed(Duration(seconds: 1), () {
      dismissScreen(context);
      setState(() => _isSearched = true);
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
