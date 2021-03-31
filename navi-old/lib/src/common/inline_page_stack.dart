import 'package:flutter/widgets.dart';

import '../main.dart';

typedef PagesBuilder = List<Page> Function(BuildContext context);

/// A PageStack without state,
/// which allows to define pages directly without creating new Stack class.
class InlinePageStack extends PageStack<void> {
  InlinePageStack({required PagesBuilder pages})
      : _pagesBuilder = pages,
        super(initialState: null);

  final PagesBuilder _pagesBuilder;

  @override
  List<Page> pages(BuildContext context) => _pagesBuilder(context);

  @override
  void beforePop(BuildContext context, Route<dynamic> route, dynamic result) {}
}
