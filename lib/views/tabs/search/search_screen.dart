import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/views/tabs/search/search_result_cell.dart';

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

  Widget searchingWidget() {
    return Container(
      // height: double.infinity,
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
    return ListView.separated(
      itemBuilder: (context, index) {
        return SearchResultCell();
      },
      separatorBuilder: (context, index) {
        return Divider(height: 0);
      },
      itemCount: 10,
    );
  }

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
  void dispose() {
    _searchFocusScop.dispose();
    super.dispose();
  }

  void onSearch(String? text) {
    FocusScope.of(context).unfocus();
    print('________$text');
    // showKSLoading(context, message: 'Loading...');
    _isSearching = true;
    setState(() {});
    Future.delayed(Duration(seconds: 2), () {
      // dismissScreen(context);
      setState(() => _isSearching = false);
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
