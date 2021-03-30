import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

// TODO: improve performance by checking for both Type and name
class InheritedStack extends InheritedModel<Type> {
  const InheritedStack({
    Key? key,
    required Widget child,
    required this.stacks,
  }) : super(key: key, child: child);

  final List<PageStack> stacks;

  static List<PageStack> of(BuildContext context, [Type? type]) {
    return InheritedModel.inheritFrom<InheritedStack>(context, aspect: type)!
        .stacks;
  }

  @override
  bool updateShouldNotify(covariant InheritedStack oldWidget) {
    return stacks != oldWidget.stacks;
  }

  @override
  bool updateShouldNotifyDependent(
      covariant InheritedStack oldWidget, Set<Type> dependencies) {
    final filteredStacks =
        stacks.where((stack) => dependencies.contains(stack.runtimeType));
    final oldFilteredStacks = oldWidget.stacks
        .where((stack) => dependencies.contains(stack.runtimeType));

    return !(const IterableEquality<PageStack>()
        .equals(filteredStacks, oldFilteredStacks));
  }
}

extension InheritedStackExt on BuildContext {
  List<PageStack> get stacks => InheritedStack.of(this);

  T stack<T extends PageStack<dynamic>>([String? name]) {
    final pageStack = InheritedStack.of(this, T).lastWhereOrNull((stack) {
      return (name == null || stack.name == name) && stack.runtimeType == T;
    }) as T?;

    assert(() {
      if (pageStack == null) {
        throw FlutterError(
            'Navi operation requested with a context that does not include stack $T${name == null ? '' : '(name: $name)'}.');
      }
      return true;
    }());

    return pageStack!;
  }
}
