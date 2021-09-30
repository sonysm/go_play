import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/routes.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/auth/login_screen.dart';

class WalkThroughScreen extends StatefulWidget {
  WalkThroughScreen({Key? key}) : super(key: key);

  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  List<WalkthroughData> _walkthroughList = [
    WalkthroughData(title: 'Discover news feed, Find and meet new people.', image: 'assets/images/img_wt_home.png'),
    WalkthroughData(title: 'Discover Meetup and join with them to make fun.', image: 'assets/images/img_wt_meetup.png'),
    WalkthroughData(title: 'Discover Venues for your game.', image: 'assets/images/img_wt_venue.png'),
  ];

  late PageController _pageController;
  double _width = 0;
  double _stepWidth = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _stepWidth = MediaQuery.of(context).size.width / (_walkthroughList.length + 1);
      _width = _stepWidth;
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
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/img_ks_watermark.png',
                repeat: ImageRepeat.repeat,
                color: isLight(context) ? Colors.black.withOpacity(0.04) : Colors.white.withOpacity(0.04),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 3.0,
                      color: Colors.grey[350],
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: _width,
                      height: 3.0,
                      color: Colors.green,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                  child: SizedBox(
                    height: 56.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_pageController.page! > 0) {
                              _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                              if (_width > _stepWidth) setState(() => _width = _width - _stepWidth);
                            } else {
                              dismissScreen(context);
                            }
                          },
                          child: Icon(
                            FeatherIcons.arrowLeft,
                            color: ColorResources.getSecondaryIconColor(context),
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
                          onPressed: () async {
                            if (_pageController.page! == _walkthroughList.length - 1) {
                              setState(() => _width = _width + _stepWidth);
                              await Navigator.push(context, KSSlidePageRoute(builder: (_) => LoginScreen()));
                              await Future.delayed(Duration(milliseconds: 300));
                              setState(() => _width = _width - _stepWidth);
                            } else {
                              _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                              if (_pageController.page! < _walkthroughList.length) {
                                setState(() => _width = _width + _stepWidth);
                              }
                            }
                          },
                          child: Icon(
                            FeatherIcons.arrowRight,
                            color: whiteColor,
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.all(mainColor),
                            shape: MaterialStateProperty.all(CircleBorder()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    itemBuilder: (context, index) {
                      return WalkThroughContent(
                        title: _walkthroughList.elementAt(index).title,
                        image: _walkthroughList.elementAt(index).image,
                      );
                    },
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _walkthroughList.length,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WalkThroughContent extends StatelessWidget {
  const WalkThroughContent({Key? key, required this.title, required this.image}) : super(key: key);

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorResources.getPrimaryText(context),
                  fontSize: 32.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -150,
            child: SizedBox(
              child: Image.asset(image),
            ),
          )
        ],
      ),
    );
  }
}

class WalkthroughData {
  final String title;
  final String image;

  const WalkthroughData({required this.title, required this.image});
}
