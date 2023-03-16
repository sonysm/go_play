import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'const.dart';
import 'package:kroma_sport/widgets/spinkit/animation_bounce.dart';

typedef Future<void> RefreshCallback();

class TopRefresher extends StatefulWidget {
  final double paintOriginYOffset;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;
  final RefreshCallback? onRefresh;

  const TopRefresher(
      {Key? key,
      this.refreshTriggerPullDistance: kDefaultRefreshTriggerPullDistance,
      this.refreshIndicatorExtent: kDefaultRefreshIndicatorExtent,
      this.paintOriginYOffset: kDefaultTopRefreshPaintOriginYOffset,
      this.onRefresh})
      : super(key: key);

  @override
  _TopRefresherState createState() => _TopRefresherState();
}

class _TopRefresherState extends State<TopRefresher> {
  static const double _kInactiveResetOverscrollFraction = 0.1;

  RefreshState refreshState = RefreshState.inactive;
  Future<void>? refreshTask;

  double lastIndicatorExtent = 0.0;
  bool hasSliverLayoutExtent = false;

  @override
  void initState() {
    super.initState();
    refreshState = RefreshState.inactive;
  }

  RefreshState transitionNextState() {
    RefreshState nextState;
    void goToDone() {
      nextState = RefreshState.done;
      if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
        setState(() => hasSliverLayoutExtent = false);
      } else {
        SchedulerBinding.instance!.addPostFrameCallback((Duration timestamp) {
          setState(() => hasSliverLayoutExtent = false);
        });
      }
    }

    switch (refreshState) {
      case RefreshState.inactive:
        if (lastIndicatorExtent <= 0) {
          return RefreshState.inactive;
        } else {
          nextState = RefreshState.drag;
        }
        continue drag;
      drag:
      case RefreshState.drag:
        if (lastIndicatorExtent == 0) {
          return RefreshState.inactive;
        } else if (lastIndicatorExtent < widget.refreshTriggerPullDistance) {
          return RefreshState.drag;
        } else {
          if (widget.onRefresh != null) {
            HapticFeedback.mediumImpact();
            // Call onRefresh after this frame finished since the function is
            // user supplied and we're always here in the middle of the sliver's
            // performLayout.
            SchedulerBinding.instance
                .addPostFrameCallback((Duration timestamp) {
              refreshTask = widget.onRefresh!()
                ..then((_) {
                  if (mounted) {
                    setState(() => refreshTask = null);
                    refreshState = transitionNextState();
                  }
                });
              setState(() => hasSliverLayoutExtent = true);
            });
          }
          return RefreshState.armed;
        }
      case RefreshState.armed:
        if (refreshState == RefreshState.armed && refreshTask == null) {
          goToDone();
          continue done;
        }

        if (lastIndicatorExtent > widget.refreshIndicatorExtent) {
          return RefreshState.armed;
        } else {
          nextState = RefreshState.refresh;
        }
        continue refresh;
      refresh:
      case RefreshState.refresh:
        if (refreshTask != null) {
          return RefreshState.refresh;
        } else {
          goToDone();
        }
        continue done;
      done:
      case RefreshState.done:
        if (lastIndicatorExtent >
            widget.refreshTriggerPullDistance *
                _kInactiveResetOverscrollFraction) {
          return RefreshState.done;
        } else {
          nextState = RefreshState.inactive;
        }
        break;
    }

    return nextState;
  }

  @override
  Widget build(BuildContext context) {
    return _RefreshSliver(
        paintOriginYOffset: widget.paintOriginYOffset,
        refreshIndicatorLayoutExtent: widget.refreshIndicatorExtent,
        hasLayoutExtent: hasSliverLayoutExtent,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            lastIndicatorExtent = constraints.maxHeight;
            refreshState = transitionNextState();
            if (refreshState != RefreshState.inactive) {
              return _DefaultRefresherIndicator(
                  refreshState: refreshState,
                  pulledExtent: lastIndicatorExtent,
                  refreshTriggerPullDistance: widget.refreshTriggerPullDistance,
                  refreshIndicatorExtent: widget.refreshIndicatorExtent);
            } else {
              return Container();
            }
          },
        ));
  }
}

class _DefaultRefresherIndicator extends StatelessWidget {
  final RefreshState? refreshState;
  final double pulledExtent;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;

  const _DefaultRefresherIndicator(
      {Key? key,
      this.refreshState,
      this.pulledExtent = 0,
      this.refreshTriggerPullDistance = 0,
      this.refreshIndicatorExtent = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Curve opacityCurve =
        const Interval(0.4, 0.8, curve: Curves.easeInOut);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: (refreshIndicatorExtent - 14.0 * 2) / 2.0),
        child: refreshState == RefreshState.drag
            ? Opacity(
                opacity: opacityCurve.transform(
                    min(pulledExtent / refreshTriggerPullDistance, 1.0)),
                child: const Icon(
                  CupertinoIcons.chevron_down,
                  color: CupertinoColors.inactiveGray,
                  size: 36.0,
                ),
              )
            : refreshState == RefreshState.armed
                ? Opacity(
                    opacity: opacityCurve.transform(
                        min(pulledExtent / refreshIndicatorExtent, 1.0)),
                    child: const Icon(
                      CupertinoIcons.chevron_up,
                      color: CupertinoColors.inactiveGray,
                      size: 36.0,
                    ),
                  )
                : refreshState == RefreshState.refresh
                    ? Opacity(
                        opacity: opacityCurve.transform(
                            min(pulledExtent / refreshIndicatorExtent, 1.0)),
                        child: AnimationBounce(
                          color: Theme.of(context).colorScheme.secondary,
                          size: 25.0,
                        ))
                    : SizedBox.shrink(),
      ),
    );
  }
}

class _RefreshSliver extends SingleChildRenderObjectWidget {
  const _RefreshSliver(
      {this.refreshIndicatorLayoutExtent: 0.0,
      this.paintOriginYOffset: 0.0,
      this.hasLayoutExtent: false,
      Widget? child})
      : assert(refreshIndicatorLayoutExtent >= 0.0),
        super(child: child);

  final double paintOriginYOffset;

  final double refreshIndicatorLayoutExtent;

  final bool hasLayoutExtent;

  @override
  _RenderRefreshSliver createRenderObject(BuildContext context) {
    return _RenderRefreshSliver(
        paintOriginYOffset: paintOriginYOffset,
        refreshIndicatorExtent: refreshIndicatorLayoutExtent,
        hasLayoutExtent: hasLayoutExtent);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderRefreshSliver renderObject) {
    renderObject
      ..refreshIndicatorLayoutExtent = refreshIndicatorLayoutExtent
      ..hasLayoutExtent = hasLayoutExtent;
  }
}

class _RenderRefreshSliver extends RenderSliver
    with RenderObjectWithChildMixin<RenderBox> {
  _RenderRefreshSliver(
      {required double refreshIndicatorExtent,
      required bool hasLayoutExtent,
      RenderBox? child,
      this.paintOriginYOffset: 0.0})
      : assert(refreshIndicatorExtent >= 0.0),
        _refreshIndicatorExtent = refreshIndicatorExtent,
        _hasLayoutExtent = hasLayoutExtent {
    this.child = child;
  }
  double get refreshIndicatorLayoutExtent => _refreshIndicatorExtent;
  double _refreshIndicatorExtent;
  double paintOriginYOffset;
  set refreshIndicatorLayoutExtent(double value) {
    assert(value >= 0.0);
    if (value == _refreshIndicatorExtent) return;
    _refreshIndicatorExtent = value;
    markNeedsLayout();
  }

  bool get hasLayoutExtent => _hasLayoutExtent;
  bool _hasLayoutExtent;
  set hasLayoutExtent(bool value) {
    if (value == _hasLayoutExtent) return;
    _hasLayoutExtent = value;
    markNeedsLayout();
  }

  double layoutExtentOffsetCompensation = 0.0;

  @override
  void performLayout() {
    assert(constraints.axisDirection == AxisDirection.down);
    assert(constraints.growthDirection == GrowthDirection.forward);

    // The new layout extent this sliver should now have.
    final double layoutExtent =
        (_hasLayoutExtent ? 1.0 : 0.0) * _refreshIndicatorExtent;

    if (layoutExtent != layoutExtentOffsetCompensation) {
      geometry = SliverGeometry(
        scrollOffsetCorrection: layoutExtent - layoutExtentOffsetCompensation,
      );
      layoutExtentOffsetCompensation = layoutExtent;
      return;
    }

    bool active = constraints.overlap < 0.0 || layoutExtent > 0.0;
    final double overscrolledExtent =
        constraints.overlap < 0.0 ? constraints.overlap.abs() : 0.0;

    child!.layout(
      constraints.asBoxConstraints(
        maxExtent: layoutExtent + overscrolledExtent,
      ),
      parentUsesSize: true,
    );
    if (active) {
      var paintExtent = max(
        max(child!.size.height, layoutExtent) - constraints.scrollOffset,
        0.0,
      );
      var maxPaintExtent = max(
        max(child!.size.height, layoutExtent) - constraints.scrollOffset,
        0.0,
      );
      var layoutET = max(layoutExtent - constraints.scrollOffset, 0.0);
      var paintOrigin =
          -overscrolledExtent - constraints.scrollOffset + paintOriginYOffset;
      geometry = SliverGeometry(
        scrollExtent: layoutExtent,
        paintOrigin: paintOrigin,
        paintExtent: paintExtent,
        maxPaintExtent: maxPaintExtent,
        layoutExtent: layoutET,
      );
    } else {
      geometry = SliverGeometry.zero;
    }
  }

  @override
  void paint(PaintingContext paintContext, Offset offset) {
    if (constraints.overlap < 0.0 ||
        constraints.scrollOffset + child!.size.height > 0) {
      paintContext.paintChild(child!, offset);
    }
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {}
}
