import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class BookPage extends StatefulWidget {
  const BookPage({
    Key? key,
    required this.book,
    this.tab,
    this.onSelectBookTab,
  }) : super(key: key);

  final Book book;
  final BookTab? tab;
  final ValueChanged<BookTab>? onSelectBookTab;

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage>
    with SingleTickerProviderStateMixin {
  late BookTab _tab = widget.tab ?? BookTab.like;
  final Map<BookTab, BackButtonController> _backButtonControllers =
      Map.fromEntries(
    BookTab.values.map(
      (tab) => MapEntry(tab, BackButtonController()),
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('BookPage ${context.stacks}');
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
            return StackOutlet(
              backButtonController: _backButtonControllers[tab],
              stack: BookCommentStack(initialState: 0),
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
            widget.onSelectBookTab?.call(_tab);
            _animationController.forward(from: 0);

            _backButtonControllers.forEach((tab, controller) {
              if (tab == _tab) {
                controller.takePriority();
              } else {
                controller.removePriority();
              }
            });
          });
        },
      ),
    );
  }
}
