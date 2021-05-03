import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

enum AppTab { home, school, business }

class AppTabData {
  const AppTabData({
    required this.path,
    required this.icon,
    required this.label,
  });

  final String path;
  final IconData icon;
  final String label;
}

const tabs = {
  AppTab.home: AppTabData(
    path: 'home',
    icon: Icons.home,
    label: 'Home',
  ),
  AppTab.school: AppTabData(
    path: 'school',
    icon: Icons.school,
    label: 'School',
  ),
  AppTab.business: AppTabData(
    path: 'business',
    icon: Icons.business,
    label: 'Business',
  ),
};

class RootStack extends StatefulWidget {
  @override
  _RootStackState createState() => _RootStackState();
}

class _RootStackState extends State<RootStack>
    with SingleTickerProviderStateMixin, NaviRouteMixin<RootStack> {
  int _currentIndex = 0;

  late final TabController _tabController = TabController(
    length: tabs.length,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    tabs.values.forEachIndexedWhile((tabIndex, tabData) {
      if (unprocessedRoute.hasPrefixes([tabData.path])) {
        setState(() {
          _currentIndex = tabIndex;
          _tabController.animateTo(_currentIndex);
        });

        return false;
      }
      return true;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Home'),
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          ...tabs.values.map(
            (data) => Tab(
              icon: Icon(data.icon),
              text: data.label,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        ...tabs.entries.mapIndexed(
          (index, tabEntry) => NaviStack(
            // IMPORTANT: only one stack should be activated
            active: index == _currentIndex,
            pages: (context) => [
              NaviPage.material(
                key: ValueKey(tabEntry.key),
                route: NaviRoute(path: [tabEntry.value.path]),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '${tabEntry.value.label}',
                          icon: Icon(tabEntry.value.icon),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
