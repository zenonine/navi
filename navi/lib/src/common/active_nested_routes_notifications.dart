import 'package:flutter/widgets.dart';

import '../main.dart';

class ActiveNestedRoutesNotification extends Notification {
  const ActiveNestedRoutesNotification({required this.routes});

  final List<NaviRoute> routes;
}
