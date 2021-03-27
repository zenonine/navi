import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Section _section = defaultSection;
  SectionTab _tab = defaultSectionTab;

  final Map<SectionTab, BackButtonController> _backButtonControllers =
      Map.fromEntries(
    SectionTab.values.map(
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sectionName(_section))),
      drawer: _Drawer(onSelectSection: _selectSection),
      // https://material.io/components/bottom-navigation#behavior
      body: FadeTransition(
        opacity: _animation,
        child: IndexedStack(
          key: ValueKey(_section),
          index: _tab.index,
          children: SectionTab.values
              .map((tab) => StackOutlet(
                    backButtonController: _backButtonControllers[tab],
                    stack: SectionTabStack(section: _section, tab: tab),
                  ))
              .toList(),
        ),
      ),
      bottomNavigationBar: _BottomNavigationBar(
        tab: _tab,
        onSelectTab: _selectTab,
      ),
    );
  }

  void _selectSection(Section section) {
    if (_section != section) {
      setState(() {
        _section = section;
        _tab = defaultSectionTab;
        _selectTabEffect();
      });
    }
  }

  void _selectTab(SectionTab newTab) {
    if (_tab != newTab) {
      setState(() {
        _tab = newTab;
        _selectTabEffect();
      });
    }
  }

  void _selectTabEffect() {
    _animationController.forward(from: 0);

    // make sure stack for current tab has priority
    _backButtonControllers.forEach((tab, controller) {
      if (tab == _tab) {
        controller.takePriority();
      } else {
        controller.removePriority();
      }
    });
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({
    Key? key,
    required this.tab,
    this.onSelectTab,
  }) : super(key: key);

  final SectionTab tab;
  final ValueChanged<SectionTab>? onSelectTab;

  @override
  __BottomNavigationBarState createState() => __BottomNavigationBarState();
}

class __BottomNavigationBarState extends State<_BottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          label: 'All',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Staff Picks',
        ),
      ],
      currentIndex: widget.tab.index,
      onTap: (tabIndex) {
        final tab =
            SectionTab.values.firstWhere((tab) => tab.index == tabIndex);
        widget.onSelectTab?.call(tab);
      },
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({this.onSelectSection});

  final ValueChanged<Section>? onSelectSection;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Audiobook'),
            onTap: () {
              onSelectSection?.call(Section.audiobook);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Fiction'),
            onTap: () {
              onSelectSection?.call(Section.fiction);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
