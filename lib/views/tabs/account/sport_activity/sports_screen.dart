import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/sport_detail.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';

class SportsScreen extends StatefulWidget {
  static const String tag = '/sportsScreen';

  SportsScreen({Key? key}) : super(key: key);

  @override
  _SportsScreenState createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen> {
  KSHttpClient ksClient = KSHttpClient();
  List<FavoriteSport> favSportList = [];
  List<Sport> sportList = [];
  bool isLoading = true;
  bool isChanged = false;

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('What sport do you play?'),
    );
  }

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
                      trailing: !sport.fav!
                          ? KSIconButton(
                              icon: Feather.plus_circle,
                              iconSize: 24.0,
                              onTap: () {
                                addFavSport(sportList.elementAt(index).id);
                                sportList.elementAt(index).fav = true;
                                setState(() {});
                              },
                            )
                          : SizedBox(),
                      onTap: () async {
                        // var value = await launchScreen(
                        //   context,
                        //   SportDetailScreen.tag,
                        //   arguments: sport,
                        // );
                        // if (value != null && value) {
                        //   sportList.elementAt(index).fav = false;
                        //   isChanged = true;
                        //   setState(() {});
                        // }
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
    return WillPopScope(
      onWillPop: () async {
        if (isChanged) {
          dismissScreen(context, isChanged);
        }
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            buildNavbar(),
            buildSportList(),
          ],
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if (!mounted) return;
    super.setState(fn);
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

  void addFavSport(int sportId) async {
    var data = await ksClient.postApi('/user/add/favorite/sport/$sportId');
    if (data != null) {
      if (data is! HttpResult) {
        isChanged = true;
        setState(() {});
      }
    }
  }
}
