import 'package:flutter/widgets.dart';

import '../main.dart';

typedef VoidPageBuilder = Page Function(BuildContext context);

typedef VoidPagesBuilder = List<Page> Function(BuildContext context);

typedef PagesBuilder<T> = List<Page> Function(BuildContext context, T state);

typedef NaviPopPageCallback = bool Function(
    BuildContext context, Route<dynamic> route, dynamic result);

typedef RouteInfoBuilder<T> = RouteInfo Function(T state);

typedef BeforePop<T> = T Function(
    BuildContext context, Route<dynamic> route, dynamic result, T state);

typedef OnNewRoute<T> = T Function(RouteInfo routeInfo);
