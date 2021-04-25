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

class _RootStackState extends State<RootStack> with NaviRouteMixin<RootStack> {
  int _currentIndex = 0;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    tabs.values.forEachIndexedWhile((tabIndex, tabData) {
      if (unprocessedRoute.hasPrefixes([tabData.path])) {
        setState(() {
          _currentIndex = tabIndex;
        });

        return false;
      }
      return true;
    });
  }

  Widget _buildBody() {
    return NaviStack(
      key: ValueKey(_currentIndex),
      pages: (context) => [
        NaviPage.material(
          key: ValueKey(_currentIndex),
          route: NaviRoute(path: [tabs.values.elementAt(_currentIndex).path]),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                hintText: tabs.values.elementAt(_currentIndex).label,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: [
        ...tabs.values.map(
          (tab) => BottomNavigationBarItem(
            icon: Icon(tab.icon),
            label: tab.label,
          ),
        ),
      ],
      onTap: (newIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
