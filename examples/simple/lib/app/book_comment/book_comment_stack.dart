import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class BookCommentStack extends PageStack<int> {
  BookCommentStack({required int initialState})
      : super(initialState: initialState);

  @override
  List<Page> pages(BuildContext context) => List.generate(
        state + 1,
        (index) => MaterialPage<dynamic>(
          key: ValueKey(index),
          child: LikeCounter(
            title: 'Comment #$index',
            onNextComment: () => state++,
          ),
        ),
      );

  @override
  void beforePop(context, route, dynamic result) => state--;
}
