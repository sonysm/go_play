import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/venue/venue_screen.dart';
import 'package:line_icons/line_icons.dart';

class OptionMainScreen extends StatefulWidget {
  OptionMainScreen({Key? key}) : super(key: key);

  @override
  _OptionMainScreenState createState() => _OptionMainScreenState();
}

class _OptionMainScreenState extends State<OptionMainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animationController.reverse().then((value) => dismissScreen(context));
      },
      child: Container(
        color: Colors.transparent,
        child: SizedBox.expand(
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 400.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: isLight(context)
                          ? [
                              Colors.white,
                              Colors.white,
                              Color(0x000FFFFFF),
                              Color(0x000FFFFFF),
                            ]
                          : [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor,
                              Color(0x000000000),
                              Color(0x000000000),
                            ],
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (_, child) {
                  return Positioned(
                    left: (AppSize(context).appWidth(50) - 50.0) - (_animation.value * 80),
                    bottom: 0 + (_animation.value * 70),
                    child: SizedBox(
                      width: 100.0,
                      child: FadeTransition(
                        opacity: _animation,
                        child: ActionButton(
                          title: 'Organize activity',
                          backgroundGradientColor: LinearGradient(
                            colors: [
                              Color(0xFFf46b45),
                              Color(0xFFeea849),
                            ],
                          ),
                          icon: Icon(
                            FeatherIcons.activity,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (_, child) {
                  return Positioned(
                    right: (AppSize(context).appWidth(50) - 50.0) - (_animation.value * 80),
                    bottom: 0 + (_animation.value * 70),
                    child: SizedBox(
                      width: 100.0,
                      child: FadeTransition(
                        opacity: _animation,
                        child: ActionButton(
                          title: 'Book a venue',
                          backgroundGradientColor: LinearGradient(
                            colors: [
                              Color(0xFF11998e),
                              Color(0xFF38ef7d),
                            ],
                          ),
                          icon: Icon(
                            FeatherIcons.bookmark,
                            color: whiteColor,
                          ),
                          onPressed: () 
                          {
                            dismissScreen(context);
                            launchScreen(context, VenueScreen.tag);
                          }
                        ),
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                  animation: _animation,
                  builder: (_, child) {
                    return Positioned(
                      right: 0,
                      left: 0,
                      bottom: -16 + (_animation.value * 32),
                      child: FadeTransition(
                        opacity: _animation,
                        child: ElevatedButton(
                          onPressed: () {
                            _animationController.reverse().then((value) => dismissScreen(context));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(ColorResources.getCloseButtonColor(context)),
                            shape: MaterialStateProperty.all(CircleBorder()),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          child: Icon(LineIcons.times, size: 22.0),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    this.title,
    this.backgroundColor = mainColor,
    this.backgroundGradientColor,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;
  final String? title;
  final Color? backgroundColor;
  final Gradient? backgroundGradientColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 3.0, color: whiteColor),
            shape: BoxShape.circle,
            color: backgroundGradientColor == null ? backgroundColor : null,
            gradient: backgroundGradientColor != null ? backgroundGradientColor : null,
            boxShadow: [BoxShadow(blurRadius: 4.0, color: Colors.black12)],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsetsDirectional.all(10.0)),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all(CircleBorder()),
              elevation: MaterialStateProperty.all(0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: icon,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          title ?? '',
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.clip,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

void showKSMainOption(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    enableDrag: false,
    barrierColor: Colors.black.withOpacity(.1),
    backgroundColor: Colors.transparent,
    builder: (_) => OptionMainScreen(),
  );
}
