import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';

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

  bool isConnection = true;

  Widget buildNavbar() {
    return SliverAppBar(
      elevation: 0.5,
      forceElevated: true,
      pinned: true,
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
        ? SliverPadding(
          padding: const EdgeInsets.only(bottom: 16.0),
          sliver: SliverList(
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
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withOpacity(0.1),
                              blurRadius: 8,
                            )
                          ]),
                      child: ListTile(
                        leading: SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: sport.icon != null
                                ? CacheImage(url: sport.icon!)
                                : null),
                        title: Text(
                          sport.name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.only(left: 16.0, right: 8),
                        trailing: !sport.fav!
                            ? KSIconButton(
                                icon: Feather.plus_circle,
                                iconSize: 24.0,
                                iconColor: ColorResources.getBlueGrey(context),
                                onTap: () {
                                  addFavSport(sportList.elementAt(index).id);
                                  sportList.elementAt(index).fav = true;
                                  setState(() {});
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  FeatherIcons.check,
                                  color: mainColor,
                                ),
                              ),
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
        backgroundColor: Theme.of(context).primaryColor,
        body: CustomScrollView(
          slivers: [
            buildNavbar(),
            isConnection
                ? buildSportList()
                : SliverFillRemaining(
                    child: KSNoInternet(),
                  )
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
