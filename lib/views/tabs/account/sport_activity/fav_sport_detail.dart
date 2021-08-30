import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:toggle_switch/toggle_switch.dart';

class FavoriteSportDetailScreen extends StatefulWidget {
  static const String tag = '/favoriteSportDetailScreen';

  final FavoriteSport favSport;
  final bool? isMe;

  FavoriteSportDetailScreen({
    Key? key,
    required this.favSport,
    this.isMe,
  }) : super(key: key);

  @override
  _FavoriteSportDetailScreenState createState() =>
      _FavoriteSportDetailScreenState();
}

class _FavoriteSportDetailScreenState extends State<FavoriteSportDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  KSHttpClient ksClient = KSHttpClient();

  late FavoriteSport _favSport;
  late int skillLevel;

  late bool _isMe;

  Widget buildNavbar() {
    return SliverAppBar(
      elevation: 0,
      forceElevated: true,
      title: Text(
        widget.favSport.sport.name,
        style: TextStyle().copyWith(color: whiteColor),
      ),
      iconTheme: IconThemeData().copyWith(color: whiteColor),
      // actions: [
      //   CupertinoButton(
      //     child: Icon(FeatherIcons.moreHorizontal,
      //         color: Theme.of(context).brightness == Brightness.light
      //             ? Colors.grey[600]
      //             : whiteColor),
      //     onPressed: () => showOptionActionBottomSheet(),
      //   ),
      // ],
      expandedHeight: 270,
      floating: true,
      pinned: true,
      backgroundColor: Color(0xFF1D976C),
      flexibleSpace: FlexibleSpaceBar(
        // collapseMode: CollapseMode.pin,
        background: FavSportFlexibleAppbar(
          favSport: widget.favSport,
          isMe: widget.isMe ?? true,
          playLevel: _favSport.playLevel != null ? _favSport.playLevel! - 1 : 0,
          onToggleChange: (level) {
            updatePlayLevel(playLevel: level + 1);
            widget.favSport.playLevel = level + 1;
          },
        ),
      ),
    );
  }

  Widget emptyActivity() {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            top: (MediaQuery.of(context).size.height / 2) -
                AppBar().preferredSize.height),
        child: Text('No activity yet'),
      ),
    );
  }

  /*Widget buildSkillLevel() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            SvgPicture.asset(
              svgSoccerBall2,
              width: 80,
              height: 80,
            ),
            24.height,
            Text(
              'Skill Level',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            8.height,
            ToggleSwitch(
              minHeight: 50,
              minWidth: AppSize(context).appWidth(90 / 3),
              fontSize: 16.0,
              initialLabelIndex: skillLevel,
              activeBgColor: [mainColor],
              activeFgColor: Colors.white,
              cornerRadius: 8.0,
              inactiveBgColor: Colors.grey[200],
              inactiveFgColor: Colors.grey[900]!.withOpacity(0.5),
              totalSwitches: 3,
              labels: ['Begineer', 'Intermediate', 'Advanced'],
              onToggle: (index) {
                print('switched to: $index');
              },
            ),
          ],
        ),
      ),
    );
  }*/

  Widget buildPreferPosition() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            final attributeData = _favSport.sport.attribute!.elementAt(index);
            List? selectedList;
            if (_favSport.playAttribute != null) {
              if (_favSport.playAttribute![attributeData.slug] != null) {
                selectedList = _favSport.playAttribute![attributeData.slug];
              } else {
                // selectedList = [];
                _favSport.playAttribute![attributeData.slug] = [];
                selectedList = _favSport.playAttribute![attributeData.slug];
              }
            } else {
              _favSport.playAttribute = Map();
              _favSport.sport.attribute!.forEach((element) {
                _favSport.playAttribute!.addAll({element.slug: []});
              });
              selectedList = [];
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attributeData.title!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Column(
                    children: List.generate(
                      attributeData.data!.length,
                      (index) {
                        final attr = attributeData.data![index];
                        bool isSwitched = false;

                        if (_favSport.playAttribute != null) {
                          isSwitched = selectedList!.indexOf(attr.slug) > -1;
                        }

                        return Container(
                          height: 44.0,
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              attr.title!,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                if (isSwitched) {
                                  if (selectedList != null) {
                                    selectedList.remove(attr.slug);
                                  }

                                  removePlayAttribute(
                                      slug: attributeData.slug!,
                                      addSlug: attr.slug!);
                                } else {
                                  // if (_favSport.playAttribute != null && _favSport.playAttribute![attributeData.slug] != null) {
                                  //   selectedList!.add(attr.slug);
                                  // } else {

                                  //   _favSport.playAttribute = {attributeData.slug: [attr.slug]};
                                  // }

                                  selectedList!.add(attr.slug);

                                  addPlayAttribute(
                                      slug: attributeData.slug!,
                                      addSlug: attr.slug!);
                                }

                                setState(() {});
                              },
                              activeTrackColor: Colors.green[200],
                              activeColor: Colors.green,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: _favSport.sport.attribute!.length,
        ),
      ),
    );
  }

  Widget buildFriendPreferPosition() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: _favSport.sport.attribute!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  final attributeData =
                      _favSport.sport.attribute!.elementAt(index);
                  List? fav;
                  if (_favSport.playAttribute != null &&
                      _favSport.playAttribute![attributeData.slug] != null) {
                    fav = _favSport.playAttribute![attributeData.slug];
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attributeData.title!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        fav != null
                            ? Column(
                                children: List.from(
                                  attributeData.data!.map(
                                    (e) {
                                      if (fav!.indexOf(e.slug) > -1) {
                                        return Container(
                                          height: 44.0,
                                          child: ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              e.title!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                height: 44.0,
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Not set',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  );
                },
                itemCount: _favSport.sport.attribute!.length,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 50.0, horizontal: 16.0),
                child: Text('No information', textAlign: TextAlign.center),
              ),
      ),
    );
  }

  Widget removeSportButton() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: SizedBox(
          height: 48.0,
          child: ElevatedButton(
            onPressed: () {
              showKSConfirmDialog(
                context,
                message:
                    'Are you sure you want to remove ${_favSport.sport.name} from your favorite?',
                onYesPressed: () => removeFavSport(),
              );
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                      color: isLight(context)
                          ? Colors.blueGrey
                          : Colors.grey[300]!),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              foregroundColor: MaterialStateProperty.all(
                  isLight(context) ? Colors.blueGrey : Colors.grey[300]),
            ),
            child: Text(
              'Remove ${_favSport.sport.name} from my profile',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Metropolis',
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        slivers: [
          buildNavbar(),
          // emptyActivity(),
          // buildSkillLevel(),
          _isMe ? buildPreferPosition() : buildFriendPreferPosition(),
          _isMe ? removeSportButton() : SliverToBoxAdapter(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isMe = widget.isMe ?? true;
    _favSport = widget.favSport;
    skillLevel = widget.favSport.playLevel!;
  }

  void showOptionActionBottomSheet() {
    showKSBottomSheet(context, children: [
      KSTextButtonBottomSheet(
        title: 'Remove from favorite sport',
        icon: Feather.info,
        onTab: () {
          dismissScreen(context);
          showKSConfirmDialog(
            context,
            message:
                'Are you sure you want to remove this sport from your favorite?',
            onYesPressed: () => removeFavSport(),
          );
        },
      ),
    ]);
  }

  void removeFavSport() async {
    showKSLoading(context);
    var data = await ksClient
        .postApi('/user/remove/favorite/sport/${_favSport.sport.id}');
    if (data != null) {
      await Future.delayed(Duration(milliseconds: 300));
      dismissScreen(context);
      if (data is! HttpResult) {
        dismissScreen(context, true);
      }
    }
  }

  void addPlayAttribute({
    required String slug,
    required String addSlug,
  }) async {
    var res = await ksClient.postApi(
      '/user/add/sport/play_attribute/${_favSport.sport.id}',
      body: {
        'slug': slug,
        'add_slug': addSlug,
      },
    );
    if (res != null) {
      if (res is! HttpResult) {}
    }
  }

  void removePlayAttribute({
    required String slug,
    required String addSlug,
  }) async {
    var res = await ksClient.postApi(
      '/user/remove/sport/play_attribute/${_favSport.sport.id}',
      body: {
        'slug': slug,
        'remove_slug': addSlug,
      },
    );
    if (res != null) {
      if (res is! HttpResult) {}
    }
  }

  void updatePlayLevel({
    required int playLevel,
  }) async {
    var res = await ksClient.postApi(
      '/user/update/sport/level/${_favSport.sport.id}',
      body: {
        'play_level': playLevel,
      },
    );
    if (res != null) {
      if (res is! HttpResult) {}
    }
  }
}

class FavSportFlexibleAppbar extends StatelessWidget {
  const FavSportFlexibleAppbar({
    Key? key,
    this.isMe = true,
    required this.favSport,
    required this.playLevel,
    required this.onToggleChange,
  }) : super(key: key);

  final FavoriteSport favSport;
  final bool isMe;
  final int playLevel;
  final Function(int) onToggleChange;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    String mapPlayLevel() {
      switch (playLevel) {
        case 0:
          return 'Beginner';
        case 1:
          return 'Intermediate';
        case 2:
          return 'Advanced';
        default:
          return 'Beginner';
      }
    }

    return Container(
      padding: new EdgeInsets.only(top: statusBarHeight, bottom: 16.0),
      height: statusBarHeight + AppBar().preferredSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1D976C),
            Color(0xFF93F9B9),
          ],
          // begin: Alignment.topCenter,
          // end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            favSport.sport.icon != null
                ? SizedBox(
                    width: 80,
                    height: 80,
                    child: CacheImage(url: favSport.sport.icon!),
                  )
                : SvgPicture.asset(
                    svgSoccerBall2,
                    width: 80,
                    height: 80,
                  ),
            24.height,
            Text(
              'Skill Level',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600, color: whiteColor),
            ),
            8.height,
            isMe
                ? ToggleSwitch(
                    minHeight: 50,
                    minWidth: AppSize(context).appWidth(90 / 3),
                    fontSize: 16.0,
                    initialLabelIndex: playLevel,
                    activeBgColor: [Color(0xFF953553)],
                    activeFgColor: Colors.white,
                    cornerRadius: 8.0,
                    inactiveBgColor: Colors.grey[200]!.withOpacity(0.3),
                    inactiveFgColor: Colors.grey[800],
                    totalSwitches: 3,
                    labels: ['Beginner', 'Intermediate', 'Advanced'],
                    radiusStyle: true,
                    onToggle: (index) {
                      onToggleChange(index);
                    },
                  )
                : Text(
                    mapPlayLevel(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: whiteColor),
                  ),
          ],
        ),
      ),
    );
  }
}
