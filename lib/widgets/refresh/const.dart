

const double kDefaultRefreshTriggerPullDistance = 60.0;
const double kDefaultRefreshIndicatorExtent = 60.0;
const double kDefaultTopRefreshPaintOriginYOffset = 0.0;

enum RefreshState{
    inactive,
    drag,
    armed,
    refresh,
    done
}
