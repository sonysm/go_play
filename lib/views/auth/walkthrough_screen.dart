import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/utils/tools.dart';

class WalkThroughScreen extends StatefulWidget {
  WalkThroughScreen({Key? key}) : super(key: key);

  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  List<String> titleList = [
    'Find and meet new people',
    'Discover Venues, Events & Gear for your Game',
    'Track your ratings and activities',
  ];

  late PageController _pageController;
  double _width = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _width = MediaQuery.of(context).size.width / titleList.length;
      setState(() {});
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 5.0,
                  color: Colors.grey[350],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: _width,
                  height: 5.0,
                  color: Colors.green,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_pageController.page != 0) {
                        _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                        setState(() {
                          _width = _width - (MediaQuery.of(context).size.width / titleList.length);
                        });
                      } else {
                        dismissScreen(context);
                      }
                    },
                    child: Icon(
                      FeatherIcons.arrowLeft,
                      color: Colors.blueGrey[800],
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      overlayColor: MaterialStateProperty.all(Colors.greenAccent[100]),
                      shape: MaterialStateProperty.all(CircleBorder()),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                      if (_pageController.page! < titleList.length - 1) {
                        setState(() {
                          _width = _width + (MediaQuery.of(context).size.width / titleList.length);
                        });
                      }
                    },
                    child: Icon(
                      FeatherIcons.arrowRight,
                      color: Colors.blueGrey[800],
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                        shape: MaterialStateProperty.all(CircleBorder())),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return WalkThroughContent(
                    title: titleList.elementAt(index),
                  );
                },
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: titleList.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WalkThroughContent extends StatelessWidget {
  const WalkThroughContent({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.blueGrey[800],
              fontSize: 32.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
