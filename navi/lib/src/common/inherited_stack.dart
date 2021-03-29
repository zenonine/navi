import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

// TODO: use InheritedModel to improve performance when listen for a Type and a name
class InheritedStack extends InheritedWidget {
  const InheritedStack({
    Key? key,
    required Widget child,
    required this.stacks,
  }) : super(key: key, child: child);

  final List<PageStack> stacks;

  static List<PageStack> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedStack>()!.stacks;

  @override
  bool updateShouldNotify(covariant InheritedStack oldWidget) {
    return stacks != oldWidget.stacks;
  }
}

extension InheritedStackExt on BuildContext {
  List<PageStack> get stacks => InheritedStack.of(this);

  T? stack<T extends PageStack<dynamic>>([String? name]) {
    final pageStack = stacks.lastWhereOrNull((stack) {
      return (name == null || stack.name == name) && stack.runtimeType == T;
    }) as T?;
    return pageStack;
  }
}
