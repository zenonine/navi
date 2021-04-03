import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key, required this.book, this.tab}) : super(key: key);

  final Book book;
  final BookTab? tab;

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage>
    with SingleTickerProviderStateMixin {
  late BookTab _tab = widget.tab ?? BookTab.like;

  final Map<BookTab, int> _currentCommentId = {};

  final Map<BookTab, StackController<int>> _stackControllers = Map.fromEntries(
    BookTab.values.map(
      (tab) => MapEntry(tab, StackController<int>()),
    ),
  );

  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));

  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    _animationController.forward();
  }

  @override
  void didUpdateWidget(BookPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    _tab = widget.tab ?? defaultBookTab;
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _tab == BookTab.like ? Colors.green : Colors.red,
      appBar: AppBar(
        title: Text('Book: ${widget.book.title}'),
      ),
      // https://material.io/components/bottom-navigation#behavior
      body: FadeTransition(
        opacity: _animation,
        child: IndexedStack(
          index: _tab.index,
          children: BookTab.values.map((tab) {
            return RouteStack<int>(
              marker: CommentStackMarker(),
              controller: _stackControllers[tab],
              pages: (context, state) => List.generate(
                state + 1,
                (index) => MaterialPage<dynamic>(
                  key: ValueKey(index),
                  child: LikeCounter(title: 'Comment #$index'),
                ),
              ),
              updateStateOnNewRoute: (routeInfo) => _currentCommentId[tab] ?? 0,
              updateStateBeforePop: (context, route, dynamic result, state) =>
                  state - 1,
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_comment), label: 'Like comments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment_bank), label: 'Dislike comments'),
        ],
        currentIndex: _tab.index,
        onTap: (tabIndex) {
          setState(() {
            _tab =
                tabIndex == BookTab.like.index ? BookTab.like : BookTab.dislike;

            // Update stack state
            context.navi.stack(RootStackMarker()).state =
                RootStackState(book: widget.book, tab: _tab);

            _animationController.forward(from: 0);

            // Only one stack should be active to help Navi handle system back button and URL sync correctly.
            _stackControllers.forEach((tab, controller) {
              if (tab == _tab) {
                controller.activation.activate();
              } else {
                controller.activation.deactivate();
              }
            });
          });
        },
      ),
    );
  }
}

class CommentStackMarker extends StackMarker<int> {}
