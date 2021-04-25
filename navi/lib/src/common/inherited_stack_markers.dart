import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

class InheritedStackMarkers extends InheritedWidget {
  const InheritedStackMarkers({
    Key? key,
    required Widget child,
    required this.markers,
  }) : super(key: key, child: child);

  final List<StackMarker> markers;

  static List<StackMarker> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedStackMarkers>()!
        .markers;
  }

  @override
  bool updateShouldNotify(covariant InheritedStackMarkers oldWidget) {
    return !(const ListEquality<StackMarker>()
        .equals(markers, oldWidget.markers));
  }
}
