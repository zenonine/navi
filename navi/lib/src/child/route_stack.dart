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

  ChildBackButtonDispatcher? _backButtonDispatcher;
  BackButtonDispatcher? _parentBackButtonDispatcher;

  @override
  void initState() {
    super.initState();

    final stateController = widget.controller;
    stateController?.addListener(() {
      _stackState?.state = stateController.state;
    });

    final activationController = widget.controller?.activationController;
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

    // handle stack state
    if (context.internalNavi.newRouteCount != _newRouteCount) {
      _newRouteCount = context.internalNavi.newRouteCount;

      final initialRouteInfo = context.internalNavi.parentStack.childRouteInfo;

      if (_stackState == null) {
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
      } else {
        _stackState!.setStateWithoutNotifyRouter(
            widget.updateStateOnNewRoute(initialRouteInfo));
      }

      _stackState!.parentRouteInfos =
          context.internalNavi.parentStack.parentRouteInfos +
              [context.internalNavi.parentStack.routeInfo];

      final currentRouteInfo = _stackState!.routeInfo;

      _stackState!.childRouteInfo = initialRouteInfo - currentRouteInfo;

      // avoid error setState() or markNeedsBuild() called during build.
      // TODO: might need to control https://api.flutter.dev/flutter/scheduler/SchedulingStrategy.html
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        RouterState().state = _stackState;
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
    widget.controller?.dispose();
    _stackState?.dispose();
    _stackState = null;
    _routerDelegate?.dispose();
    _routerDelegate = null;
    _backButtonDispatcher = null;
    _parentBackButtonDispatcher = null;
    super.dispose();
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
