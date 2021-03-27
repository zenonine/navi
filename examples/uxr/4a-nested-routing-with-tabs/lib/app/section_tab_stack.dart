import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class SectionTabStack extends PageStack<void> {
  SectionTabStack({
    required this.section,
    required this.tab,
  }) : super(initialState: null);

  final Section section;
  final SectionTab tab;

  @override
  List<Page> pages(BuildContext context) => [
        // TODO: multiple pages to check behavior of BackButtonDispatcher and "nested" in-app back button.
        MaterialPage<dynamic>(
          key: ValueKey(section.toString() + '/' + tab.toString()),
          child: SectionPage(
            section: section,
            tab: tab,
          ),
        )
      ];
}
