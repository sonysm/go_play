import 'package:flutter/material.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_activity_screen.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

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
  bool isConnection = false;

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
    return !isLoading
        ? isConnection
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
                          color: Theme.of(context).primaryColor,
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
            : noInternet()
        : SliverToBoxAdapter();
  }

  Widget noInternet() {
    return SliverFillRemaining(
      child: noConnection(context),
    );
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
    Future.delayed(Duration(milliseconds: 300)).then((_) => getSportList());
  }

  void getSportList() async {
    var data = await ksClient.getApi('/user/all/sport');
    if (data != null) {
      isLoading = false;
      if (data is! HttpResult) {
        sportList = List.from((data as List).map((e) => Sport.fromJson(e)));
        isConnection = true;
      } else {
        if (data.code == -500) {
          isConnection = false;
        }
      }
      setState(() {});
    }
  }
}
