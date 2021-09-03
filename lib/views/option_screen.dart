import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/tools.dart';

class OptionMainScreen extends StatefulWidget {
  OptionMainScreen({Key? key}) : super(key: key);

  @override
  _OptionMainScreenState createState() => _OptionMainScreenState();
}

class _OptionMainScreenState extends State<OptionMainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
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
                      colors: [
                        Colors.white,
                        Colors.white70,
                        Color(0x000FFFFFF),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (_, child) {
                  return Positioned(
                    left: (AppSize(context).appWidth(50) - 24.0) -
                        (_animation.value * 70),
                    bottom: 0 + (_animation.value * 100),
                    child: FadeTransition(
                      opacity: _animation,
                      child: ActionButton(
                        icon: Icon(
                          FeatherIcons.activity,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // AnimatedBuilder(
              //   animation: _animation,
              //   builder: (_, child) {
              //     return Positioned(
              //       right: (AppSize(context).appWidth(50) - 24.0) -
              //           (_animation.value * 70),
              //       bottom: 0 + (_animation.value * 100),
              //       child: ActionButton(
              //         icon: Icon(
              //           FeatherIcons.bookmark,
              //           color: whiteColor,
              //         ),
              //       ),
              //     );
              //   },
              // )
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
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          color: theme.accentColor,
          elevation: 4.0,
          child: IconTheme.merge(
            data: theme.accentIconTheme,
            child: IconButton(
              onPressed: onPressed,
              icon: icon,
            ),
          ),
        ),
        SizedBox(height: 4.0),
        Text('Book a venue')
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
