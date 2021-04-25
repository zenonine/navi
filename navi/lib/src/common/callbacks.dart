import 'package:flutter/widgets.dart';

import '../main.dart';

typedef VoidPageBuilder = Page Function(BuildContext context);

typedef PageBuilder = Page Function(LocalKey key, Widget child);

typedef NaviPagesBuilder = List<NaviPage> Function(BuildContext context);

typedef NaviPopPageCallback = void Function(
    BuildContext context, Route<dynamic> route, dynamic result);

typedef NaviRootPopPageCallback = void Function(BuildContext context,
    Route<dynamic> route, dynamic result, bool initiallized);

typedef OnBuiltNaviPages = void Function(
    BuildContext context, List<NaviPage> naviPages);
