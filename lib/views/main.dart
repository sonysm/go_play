import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/home/home_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_screen.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';

class MainView extends StatefulWidget {
  static const String tag = '/mainScreen';

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> _screens = [
    HomeScreen(),
    MeetupScreen(),
    NotificationScreen(),
    AccountScreen()
  ];

  List<IconData> _icons = [
    FeatherIcons.home,
    FeatherIcons.activity,
    FeatherIcons.plus,
    FeatherIcons.bell,
    FeatherIcons.user,
  ];
  int _tapIndex = 0;
  int _screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _icons.length,
      child: Scaffold(
        body: IndexedStack(
          index: _screenIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: Container(
              //color: Theme.of(context).primaryColor,
              height: 54.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey
                        : Color(0xFF455A64),
                    width: 0.1,
                  ),
                ),
              ),
              child: _CustomTabBar(
                icons: _icons,
                selectedIndex: _tapIndex,
                onTap: (index) {
                  if (index < 2) {
                    setState(() {
                      _tapIndex = index;
                      _screenIndex = index;
                    });
                  } else if (index > 2) {
                    setState(() {
                      _tapIndex = index;
                      _screenIndex = index - 1;
                    });
                  } else {
                    createActivityScreen();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  fetchLocation() async {
    if (KS.shared.currentPosition == null) {
      var service = await KS.shared.locationService.serviceEnabled();
      if (service) {
        try {
          var location = await KS.shared.locationService.getLocation();
          if (location.latitude != null && location.longitude != null) {
            KS.shared.setupLocationMintor();
          } else {}
        } catch (e) {}
      } else {}
    }
  }

  void createActivityScreen() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 0.0)),
                  ),
                  onPressed: () {},
                  child: Container(
                    height: 54.0,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Icon(
                            Feather.info,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.blueGrey
                                    : Colors.white,
                          ),
                        ),
                        Text(
                          'Create',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CustomTabBar extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;

  const _CustomTabBar(
      {Key? key,
      required this.icons,
      required this.selectedIndex,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons
            .asMap()
            .map(
              (key, value) => MapEntry(
                key,
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      elevation: MaterialStateProperty.all(0),
                      overlayColor: MaterialStateProperty.all(greyColor),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () => onTap(key),
                    child: Tab(
                      icon: key != 2
                          ? Icon(value,
                              color: key == selectedIndex
                                  ? mainColor
                                  : Theme.of(context).brightness ==
                                          Brightness.light
                                      ? darkColor
                                      : whiteColor)
                          : Container(
                              height: 40,
                              width: 40,
                              child: Material(
                                shape: CircleBorder(
                                    side: BorderSide(
                                        width: 0, color: Colors.transparent)),
                                clipBehavior: Clip.hardEdge,
                                color: mainColor,
                                child: Icon(
                                  value,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}
