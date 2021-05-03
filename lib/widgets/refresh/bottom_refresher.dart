import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:kroma_sport/widgets/spinkit/animation_bounce.dart';
import 'const.dart';

typedef Future<void> RefreshCallback();
typedef _RefreshStateCallback(RefreshState state);
typedef _ExtentChangeCallback(double extent);



class BottomRefresher extends StatefulWidget {
  final RefreshCallback onRefresh;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;

  const BottomRefresher({Key? key, required this.onRefresh, this.refreshTriggerPullDistance: kDefaultRefreshTriggerPullDistance,
      this.refreshIndicatorExtent: kDefaultRefreshIndicatorExtent,}) : 
  assert(refreshTriggerPullDistance > 0.0),
  assert(refreshIndicatorExtent >= 0.0),
  assert(refreshTriggerPullDistance >= refreshIndicatorExtent,),
  super(key: key);

  @override
  _BottomRefresherState createState() => _BottomRefresherState();
}

class _BottomRefresherState extends State<BottomRefresher> {
  double lastIndicatorExtent = 0.0;
  RefreshState? refreshState;

  @override
  Widget build(BuildContext context) {
   return _SliverToBoxAdapter(
      refreshTriggerPullDistance:  widget.refreshTriggerPullDistance,
      refreshIndicatorExtent:  widget.refreshIndicatorExtent,
      onRefresh: widget.onRefresh,
      onScrollExtentChange: (extent) {
        setState(() {
          lastIndicatorExtent = extent;
        });
      },
      onRefreshStateChange: (state) {
        setState(() {
          refreshState = state;
        });
      },
      child: _DefaultBottomRefresher(
          refreshState: refreshState,
          pulledExtent: lastIndicatorExtent,
          refreshTriggerPullDistance: widget.refreshTriggerPullDistance,
          refreshIndicatorExtent: widget.refreshIndicatorExtent),
    );
  }
}

class _DefaultBottomRefresher extends StatelessWidget
{
    final  RefreshState? refreshState;
    final  double pulledExtent;
    final  double refreshTriggerPullDistance;
    final  double refreshIndicatorExtent;

  const _DefaultBottomRefresher({Key? key, this.refreshState, this.pulledExtent = 0, this.refreshTriggerPullDistance = 0, this.refreshIndicatorExtent = 0}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    const Curve opacityCurve =
        const Interval(0.4, 0.8, curve: Curves.easeInOut);
    return SizedBox(
      height: refreshIndicatorExtent,
      child: refreshState == RefreshState.drag
          ? Padding(
              padding: const EdgeInsets.only(bottom: 14.0, top: 0.0),
              child: Opacity(
                opacity: opacityCurve.transform(
                    min(pulledExtent / refreshTriggerPullDistance, 1.0)),
                child: const Icon(
                  CupertinoIcons.up_arrow,
                  color: CupertinoColors.inactiveGray,
                  size: 36.0,
                ),
              ),
            )
            // : Padding(
            //   padding: const EdgeInsets.only(bottom: 14.0, top: 14.0),
            //   child: AnimationBounce(color: Theme.of(context).accentColor, size: 25.0,),
            // )
          : Padding(
              padding: const EdgeInsets.only(bottom: 14.0, top: 14.0),
              child: Opacity(
                opacity: opacityCurve
                    .transform(min(pulledExtent / refreshIndicatorExtent, 1.0)),
                child: AnimationBounce(color: Theme.of(context).accentColor, size: 25.0,),
              ),
            ),
    );
  }
  
}

class _SliverToBoxAdapter extends SingleChildRenderObjectWidget {
  final RefreshCallback onRefresh;
  final _ExtentChangeCallback onScrollExtentChange;
  final double? refreshTriggerPullDistance;
  final double? refreshIndicatorExtent;
  final _RefreshStateCallback onRefreshStateChange;

  /// Creates a sliver that contains a single box widget.
  const _SliverToBoxAdapter(
      {Key? key,
      Widget? child,
      this.refreshTriggerPullDistance,
      this.refreshIndicatorExtent,
      required this.onRefresh,
      required this.onScrollExtentChange,
      required this.onRefreshStateChange})
      : super(key: key, child: child);

  @override
  _RenderSliverToBoxAdapter createRenderObject(BuildContext context) =>
      _RenderSliverToBoxAdapter(
          refreshTriggerPullDistance: refreshTriggerPullDistance,
          refreshIndicatorExtent: refreshIndicatorExtent,
          onRefresh: onRefresh,
          onScrollExtentChange: onScrollExtentChange,
          onRefreshStateChange: onRefreshStateChange);
}

class _RenderSliverToBoxAdapter extends RenderSliverSingleBoxAdapter {
  /// Creates a [RenderSliver] that wraps a [RenderBox].
  RefreshState _refreshState = RefreshState.inactive;
  bool _loadComplete = false;
  RefreshCallback? onRefresh;
  RefreshCallback? _onRefreshTemp;
  _ExtentChangeCallback onScrollExtentChange;
  _RefreshStateCallback onRefreshStateChange;


  final double? refreshTriggerPullDistance;
  final double? refreshIndicatorExtent;


  _RenderSliverToBoxAdapter(
      {RenderBox? child,
      this.onRefresh,
      required this.onScrollExtentChange,
      required this.refreshTriggerPullDistance,
      required this.refreshIndicatorExtent,
      required this.onRefreshStateChange})
      : super(child: child);

  _getChildExtent() {
    switch (constraints.axis) {
      case Axis.horizontal:
        return child!.size.width;
      case Axis.vertical:
        return child!.size.height;
    }
  }

  _getScrollExtent() {
    if (_refreshState == RefreshState.refresh ||
        _refreshState == RefreshState.armed) {
      return _getChildExtent();
    } else {
      return 0.0;
    }
  }

  _runStateMachine() {
    bool underTriggerRefreshExtent =
        constraints.remainingPaintExtent <= refreshTriggerPullDistance! &&
            constraints.remainingPaintExtent > 0;
    bool beyondTriggerRefreshExtent =
        constraints.remainingPaintExtent > refreshTriggerPullDistance!;
    bool onRefreshExtent =
        (constraints.remainingPaintExtent - _getChildExtent()).abs() < 3;

    bool outOfViewport = constraints.remainingPaintExtent <= 0;
    switch (_refreshState) {
      case RefreshState.inactive:
        _loadComplete = false;
        if (underTriggerRefreshExtent) {
          _refreshState = RefreshState.drag;
        }
        if (beyondTriggerRefreshExtent) {
          _refreshState = RefreshState.armed;
        }
        break;
      case RefreshState.drag:
        if (outOfViewport) {
          _refreshState = RefreshState.inactive;
        }
        if (beyondTriggerRefreshExtent) {
          _refreshState = RefreshState.armed;
        }
        break;
      case RefreshState.armed:
        if (underTriggerRefreshExtent) {
          _refreshState = RefreshState.drag;
        }
        if (onRefreshExtent) {
          _refreshState = RefreshState.refresh;
        }
        if (_loadComplete) {
          _refreshState = RefreshState.done;
        }
        break;
      case RefreshState.refresh:
        if (_loadComplete) {
          _refreshState = RefreshState.done;
        }
        if (outOfViewport) {
          continue done;
        }
        break;
      done:
      case RefreshState.done:
        if (outOfViewport) {
          _refreshState = RefreshState.inactive;
          _loadComplete = false;
        }
        break;
    }
  }

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent = _getChildExtent();
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);

    _runStateMachine();

    geometry = SliverGeometry(
      scrollExtent: _getScrollExtent(),
      paintExtent: paintedChildSize,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );

    if (_refreshState == RefreshState.refresh && onRefresh != null) {
      onRefresh!().then((result) {
        _runStateMachine();
        _loadComplete = true;
        onRefresh = _onRefreshTemp!;
        markNeedsLayout();
      });
      _onRefreshTemp = onRefresh;
      onRefresh = null;
    }

    setChildParentData(child!, constraints, geometry!);

    SchedulerBinding.instance!.scheduleFrameCallback((timestamp) {
      onRefreshStateChange(_refreshState);
      onScrollExtentChange(paintedChildSize);
    });
  }
}
