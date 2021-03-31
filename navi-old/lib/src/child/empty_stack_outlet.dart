import 'package:flutter/material.dart';

import '../main.dart';

/// A stack with single empty page
class EmptyStackOutlet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StackOutlet(stack: EmptyStack());
  }
}

class EmptyStack extends PageStack<void> {
  EmptyStack() : super(initialState: null);

  @override
  List<Page> pages(BuildContext context) {
    // TODO: use CupertinoPage on iOS
    return [MaterialPage<dynamic>(child: Container())];
  }

  @override
  void beforePop(BuildContext context, Route<dynamic> route, dynamic result) {}
}
