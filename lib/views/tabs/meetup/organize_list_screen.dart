import 'package:flutter/material.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_activity_screen.dart';

class OrganizeListScreen extends StatefulWidget {
  static const tag = '/organizeListScreen';

  OrganizeListScreen({Key? key}) : super(key: key);

  @override
  _OrganizeListScreenState createState() => _OrganizeListScreenState();
}

class _OrganizeListScreenState extends State<OrganizeListScreen> {
  KSHttpClient ksClient = KSHttpClient();

  List<Sport> sportList = <Sport>[];

  bool isLoading = true;

  Widget emptySportList() {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            top: (MediaQuery.of(context).size.height / 2) -
                AppBar().preferredSize.height),
        child: Text('No sport'),
      ),
    );
  }

  Widget buildSportList() {
    return sportList.isNotEmpty
        ? SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                sportList.length,
                (index) {
                  final sport = sportList.elementAt(index);
                  return Container(
                    margin: const EdgeInsets.only(
                        left: 16.0, top: 10.0, right: 16.0),
                    decoration: BoxDecoration(
                      color: !sport.fav!
                          ? Theme.of(context).primaryColor
                          : Colors.green[100],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: ListTile(
                      title: Text(
                        sport.name,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      contentPadding: EdgeInsets.only(left: 16.0, right: 8),
                      onTap: () {
                        launchScreen(
                          context,
                          OragnizeActivityScreen.tag,
                          arguments: sport,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          )
        : isLoading
            ? SliverToBoxAdapter()
            : emptySportList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organize Activity'),
      ),
      body: CustomScrollView(
        slivers: [
          buildSportList(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getSportList();
  }

  void getSportList() async {
    var data = await ksClient.getApi('/user/all/sport');
    if (data != null) {
      isLoading = false;
      if (data is! HttpResult) {
        sportList = List.from((data as List).map((e) => Sport.fromJson(e)));
        setState(() {});
      }
    }
  }
}
