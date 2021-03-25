import 'package:flutter/widgets.dart';

import '../main.dart';

class StackOutlet<Stack extends PageStack> extends StatefulWidget {
  StackOutlet({
    required this.stack,
    this.backButtonController,
    this.navigatorKey,
  });

  final Stack stack;
  final BackButtonController? backButtonController;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  _StackOutletState createState() => _StackOutletState();
}

class _StackOutletState extends State<StackOutlet> {
  late final _routerDelegate = ChildRouterDelegate(
    stack: widget.stack,
    navigatorKey: widget.navigatorKey,
  );

  bool _takePriority = true;
  ChildBackButtonDispatcher? _backButtonDispatcher;
  BackButtonDispatcher? _parentBackButtonDispatcher;
  late final VoidCallback _backButtonListener;

  @override
  void initState() {
    super.initState();

    _backButtonListener = () {
      _takePriority = widget.backButtonController?.priority ?? true;
      if (_takePriority) {
        _backButtonDispatcher?.takePriority();
      } else {
        _backButtonDispatcher?.parent.forget(_backButtonDispatcher!);
      }
    };

    widget.backButtonController?.addListener(_backButtonListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final parentBackButtonDispatcher = Router.of(context).backButtonDispatcher;
    if (parentBackButtonDispatcher != _parentBackButtonDispatcher) {
      _backButtonDispatcher?.parent.forget(_backButtonDispatcher!);
      _backButtonDispatcher =
          parentBackButtonDispatcher?.createChildBackButtonDispatcher();
    }
  }

  @override
  void dispose() {
    widget.backButtonController?.removeListener(_backButtonListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_takePriority) {
      _backButtonDispatcher?.takePriority();
    }
    return Router(
      routerDelegate: _routerDelegate,
      backButtonDispatcher: _backButtonDispatcher,
    );
  }
}
