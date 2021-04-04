import 'package:flutter/widgets.dart';

import '../main.dart';

// TODO: PageStack is RouteStack, where updateStateOnNewRoute, updateRouteOnNewState are replaced with initialState.
class RouteStack<T> extends StatefulWidget {
  const RouteStack({
    Key? key,
    this.navigatorKey,
    this.marker,
    this.controller,
    required this.pages,
    required this.updateStateOnNewRoute,
    this.updateRouteOnNewState,
    this.updateStateBeforePop,
    // TODO: this.beforeSetState, // ex. redirection by change the guard or navigate to another stack
  }) : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final StackMarker<T>? marker;
  final StackController<T>? controller;
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

  late bool _activated;

  int _newRouteCount = 0;
  final _newRouteCountNotifier = NewRouteCountNotifier();
  late final VoidCallback _newRouteCountListener;

  ChildBackButtonDispatcher? _backButtonDispatcher;
  BackButtonDispatcher? _parentBackButtonDispatcher;

  @override
  void initState() {
    super.initState();

    _newRouteCountListener = () {
      if (_stackState != null &&
          mounted &&
          _newRouteCount != _newRouteCountNotifier.count) {
        _newRouteCount = _newRouteCountNotifier.count;
        _handleNewRoute();
      }
    };
    _newRouteCountNotifier.addListener(_newRouteCountListener);

    final stateController = widget.controller;
    stateController?.addListener(() {
      _stackState?.state = stateController.state;
    });

    final activationController = widget.controller?.activation;
    _activated = activationController?.activated ?? true;
    activationController?.addListener(() {
      _activated = activationController.activated;

      // TODO: how to deal with RouterState?

      if (_activated) {
        _backButtonDispatcher?.takePriority();
      } else {
        _backButtonDispatcher?.parent.forget(_backButtonDispatcher!);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // handle stack state for the first time
    if (_stackState == null) {
      _newRouteCount = _newRouteCountNotifier.count;

      final initialRouteInfo = context.internalNavi.parentStack.childRouteInfo;

      _stackState = StackState<T>(
        marker: widget.marker,
        initialState: widget.updateStateOnNewRoute(initialRouteInfo),
        routeInfoBuilder: widget.updateRouteOnNewState,
      );

      if (widget.controller != null) {
        _stackState!.addListener(() {
          widget.controller?.state = _stackState!.state;
        });
      }

      _stackState!.parentRouteInfos =
          context.internalNavi.parentStack.parentRouteInfos +
              [context.internalNavi.parentStack.routeInfo];

      final currentRouteInfo = _stackState!.routeInfo;

      _stackState!.childRouteInfo = initialRouteInfo - currentRouteInfo;

      // avoid error setState() or markNeedsBuild() called during build.
      // TODO: might need to control https://api.flutter.dev/flutter/scheduler/SchedulingStrategy.html
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (_stackState != null) {
          // TODO: it would be better, if RouterState is updated only at the last RouteStack widget
          RouterState().state = _stackState;
          // reset childRouteInfo immediately, so next time it doesn't use the old value?
          context.internalNavi.parentStack.childRouteInfo = const RouteInfo();
        }
      });
    }

    // handle router delegate
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
    }

    return true;
  }

  @override
  void dispose() {
    _routerDelegate?.dispose();
    _routerDelegate = null;

    _stackState?.dispose();
    _stackState = null;

    _newRouteCountNotifier.removeListener(_newRouteCountListener);

    widget.controller?.dispose();

    _backButtonDispatcher = null;
    _parentBackButtonDispatcher = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_activated) {
      _backButtonDispatcher?.takePriority();
    }
    return Router<dynamic>(
      routerDelegate: _routerDelegate!,
      backButtonDispatcher: _backButtonDispatcher,
    );
  }

  void _handleNewRoute() {
    final initialRouteInfo = context.internalNavi.parentStack.childRouteInfo;

    _stackState!.state = widget.updateStateOnNewRoute(initialRouteInfo);

    _stackState!.parentRouteInfos =
        context.internalNavi.parentStack.parentRouteInfos +
            [context.internalNavi.parentStack.routeInfo];

    final currentRouteInfo = _stackState!.routeInfo;

    _stackState!.childRouteInfo = initialRouteInfo - currentRouteInfo;

    // reset childRouteInfo immediately, so next time it doesn't use the old value.
    // the problem is that, this reset would introduce again https://github.com/zenonine/navi/issues/29
    // context.internalNavi.parentStack.childRouteInfo = const RouteInfo();
  }
}
