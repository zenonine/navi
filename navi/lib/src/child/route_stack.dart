import 'package:flutter/widgets.dart';

import '../main.dart';

// TODO: PageStack is RouteStack, where updateStateOnNewRoute, updateRouteOnNewState are replaced with initialState.
class RouteStack<T> extends StatefulWidget {
  const RouteStack({
    Key? key,
    this.navigatorKey,
    required this.pages,
    required this.updateStateOnNewRoute,
    this.updateRouteOnNewState,
    this.updateStateBeforePop,
    // TODO: this.beforeSetState, // ex. local redirection
  }) : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final PagesBuilder<T> pages;
  final RouteInfoBuilder<T>? updateRouteOnNewState;
  final OnNewRoute<T> updateStateOnNewRoute;
  final BeforePop<T>? updateStateBeforePop;

  @override
  RouteStackState<T> createState() => RouteStackState<T>();
}

class RouteStackState<T> extends State<RouteStack<T>> {
  ChildRouterDelegate? _routerDelegate;
  StackState<T>? _stackState;

  int _newRouteCount = 0;

  ChildBackButtonDispatcher? _backButtonDispatcher;
  BackButtonDispatcher? _parentBackButtonDispatcher;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (context.newRouteCount != _newRouteCount) {
      _newRouteCount = context.newRouteCount;

      final initialRouteInfo = context.stackState.childRouteInfo;

      if (_stackState == null) {
        _stackState = StackState<T>(
          initialState: widget.updateStateOnNewRoute(initialRouteInfo),
          routeInfoBuilder: widget.updateRouteOnNewState,
        );
      } else {
        _stackState!.state = widget.updateStateOnNewRoute(initialRouteInfo);
      }

      _stackState!.parentRouteInfos =
          context.stackState.parentRouteInfos + [context.stackState.routeInfo];

      final currentRouteInfo = _stackState!.routeInfo;

      _stackState!.childRouteInfo = initialRouteInfo - currentRouteInfo;
      print('initialRouteInfo $initialRouteInfo');
      print('currentRouteInfo $currentRouteInfo');
      print('parentRouteInfos ${_stackState!.parentRouteInfos}');
      print('routeInfo ${_stackState!.routeInfo}');
      print('childRouteInfo ${_stackState!.childRouteInfo}');

      // avoid error setState() or markNeedsBuild() called during build.
      // TODO: might need to control https://api.flutter.dev/flutter/scheduler/SchedulingStrategy.html
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        RouterState().state = _stackState;
      });
    }

    _routerDelegate ??= ChildRouterDelegate<T>(
      navigatorKey: widget.navigatorKey,
      pages: widget.pages,
      stackState: _stackState!,
      onPopPage: onPopPage,
    );

    // handle back button dispatcher
    final parentBackButtonDispatcher = Router.of(context).backButtonDispatcher;
    if (parentBackButtonDispatcher != _parentBackButtonDispatcher) {
      _backButtonDispatcher?.parent.forget(_backButtonDispatcher!);
      _backButtonDispatcher =
          parentBackButtonDispatcher?.createChildBackButtonDispatcher();
    }
  }

  bool onPopPage(BuildContext context, Route<dynamic> route, dynamic result) {
    final didPopSuccess = route.didPop(result);

    if (!didPopSuccess) {
      return false;
    }

    if (route.isFirst) {
      // Forward pop to parent navigator
      Navigator.pop(context, result);
      return false;
    }

    if (widget.updateStateBeforePop != null) {
      final newState = widget.updateStateBeforePop!
          .call(context, route, result, _stackState!.state);
      _stackState!.state = newState;
      RouterState().state = _stackState;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    _backButtonDispatcher?.takePriority();
    return Router<dynamic>(
      routerDelegate: _routerDelegate!,
      backButtonDispatcher: _backButtonDispatcher,
    );
  }
}
