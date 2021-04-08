import 'package:flutter/widgets.dart';

class InheritedPageActivation extends InheritedWidget {
  const InheritedPageActivation({
    Key? key,
    required Widget child,
    required this.active,
  }) : super(key: key, child: child);

  final bool active;

  static bool of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedPageActivation>()!.active;
  }

  @override
  bool updateShouldNotify(covariant InheritedPageActivation oldWidget) {
    return active != oldWidget.active;
  }
}
