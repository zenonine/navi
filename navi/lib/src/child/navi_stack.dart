import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

class NaviStack extends StatefulWidget {
  const NaviStack({
    Key? key,
    this.navigatorKey,
    this.marker,
    required this.pages,
    this.active = true,
    this.onPopPage,
  }) : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final StackMarker? marker;
  final NaviPagesBuilder pages;
  final bool active;
  final NaviPopPageCallback? onPopPage;

  @override
  _NaviStackState createState() => _NaviStackState();
}

class _NaviStackState extends State<NaviStack> {
  late final log = logger(this, widget.marker == null ? [] : [widget.marker!]);

  late final ChildRouterDelegate _routerDelegate;

  late bool _isActiveRouteBranch;
  bool _hasNestedRouteStack = false;

  ChildBackButtonDispatcher? _backButtonDispatcher;
  BackButtonDispatcher? _parentBackButtonDispatcher;

  @override
  void initState() {
    super.initState();
    log.finest('initState');

    _routerDelegate = ChildRouterDelegate(
      navigatorKey: widget.navigatorKey,
      marker: widget.marker,
      naviPagesBuilder: widget.pages,
      onBuiltNaviPages: (context, naviPages) {
        _notifyNewRoute(context, naviPages.last.route);
      },
      onPopPage: widget.onPopPage,
    );
  }

  @override
  void didUpdateWidget(covariant NaviStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    log.finest('didUpdateWidget');

    if (widget.active != oldWidget.active) {
      _isActiveRouteBranch =
          widget.active && context.internalNavi.isActiveRouteBranch;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log.finest('didChangeDependencies');

    _isActiveRouteBranch =
        widget.active && context.internalNavi.isActiveRouteBranch;

    // handle back button dispatcher
    final parentBackButtonDispatcher = Router.of(context).backButtonDispatcher;
    if (parentBackButtonDispatcher != _parentBackButtonDispatcher) {
      _backButtonDispatcher?.parent.forget(_backButtonDispatcher!);
      _backButtonDispatcher =
          parentBackButtonDispatcher?.createChildBackButtonDispatcher();
    }
  }

  @override
  void dispose() {
    _routerDelegate.dispose();

    _backButtonDispatcher = null;
    _parentBackButtonDispatcher = null;

    super.dispose();
  }

  void _notifyNewRoute(BuildContext context, NaviRoute pageRoute) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      log.finest('conditions before notifying new route: '
          '_isActivatedRouteBranch = $_isActiveRouteBranch'
          ', _hasNestedRouteStack = $_hasNestedRouteStack');

      if (_isActiveRouteBranch && !_hasNestedRouteStack) {
        // notify root router to change the current route
        log.finer('notified new route $pageRoute');
        ActiveNestedRoutesNotification(routes: [pageRoute]).dispatch(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log.finest('build');

    if (_isActiveRouteBranch) {
      _backButtonDispatcher?.takePriority();
    } else {
      _backButtonDispatcher?.parent.forget(_backButtonDispatcher!);
    }

    _hasNestedRouteStack = false;
    const NewStackNotification().dispatch(context);

    return NotificationListener<NewStackNotification>(
      onNotification: (notification) {
        _hasNestedRouteStack = true;
        return false;
      },
      child: InheritedActiveRouteBranch(
        active: _isActiveRouteBranch,
        child: InheritedStackMarkers(
          markers: [...context.internalNavi.markers] +
              (widget.marker == null ? [] : [widget.marker!]),
          child: Router<dynamic>(
            routerDelegate: _routerDelegate,
            backButtonDispatcher: _backButtonDispatcher,
          ),
        ),
      ),
    );
  }
}
