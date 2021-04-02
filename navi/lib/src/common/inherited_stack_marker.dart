import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

class InheritedStackMarker extends InheritedModel<StackMarker> {
  const InheritedStackMarker({
    Key? key,
    required Widget child,
    required this.states,
  }) : super(key: key, child: child);

  final List<StackState> states;

  @override
  bool updateShouldNotify(covariant InheritedStackMarker oldWidget) {
    return states != oldWidget.states;
  }

  @override
  bool updateShouldNotifyDependent(covariant InheritedStackMarker oldWidget,
      Set<StackMarker> dependencies,) {
    final filteredStates =
        states.where((state) => dependencies.contains(state.marker));
    final oldFilteredStates =
        states.where((state) => dependencies.contains(state.marker));

    return !(const IterableEquality<StackState>()
        .equals(filteredStates, oldFilteredStates));
  }

  static List<StackState> of(BuildContext context) {
    return InheritedModel.inheritFrom<InheritedStackMarker>(context)!.states;
  }

  static StackState<T> singleOf<T>(BuildContext context, StackMarker marker) {
    return InheritedModel.inheritFrom<InheritedStackMarker>(context,
        aspect: marker)!
        .states
        .lastWhere((stackState) => stackState.marker == marker)
    as StackState<T>;
  }
}
