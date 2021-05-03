
import 'package:flutter/widgets.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/widgets/spinkit/delay_tween.dart';

class AnimationBounce extends StatefulWidget {
  const AnimationBounce({
    Key? key,
    this.color = mainColor,
    this.size = 30.0,
    this.duration = const Duration(milliseconds: 1400),
  }): super(key: key);

  final Color color;
  final double size;
  final Duration duration;

  @override
  _AnimationBounceState createState() => _AnimationBounceState();
}

class _AnimationBounceState extends State<AnimationBounce> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (i) {
            return ScaleTransition(
              scale: DelayTween( i * .2, begin: 0.0, end: 1.0).animate(_controller),
              child: SizedBox.fromSize(size: Size.square(widget.size * 0.5), child: _itemBuilder(i)),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => DecoratedBox(decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle));
}