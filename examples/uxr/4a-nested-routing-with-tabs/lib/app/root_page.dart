import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _stackController = StackController<AppTab>();
  var _currentTab = AppTab.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RouteStack<AppTab>(
        controller: _stackController,
        pages: (context, state) {
          return [
            TabPage(
              key: ValueKey(state),
              child: InnerStack(config: tabConfigs[state]!),
            )
          ];
        },
        updateRouteOnNewState: (state) {
          return RouteInfo(pathSegments: [tabConfigs[state]!.path]);
        },
        updateStateOnNewRoute: (routeInfo) {
          final path = routeInfo.pathSegmentAt(0);
          final config = tabConfigs.values
              .firstWhereOrNull((config) => config.path == path);
          return config?.tab ?? AppTab.home;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab.index,
        onTap: (tabIndex) {
          setState(() {
            _currentTab =
                AppTab.values.firstWhere((tab) => tab.index == tabIndex);
            _stackController.state = _currentTab;
          });
        },
        selectedItemColor: tabConfigs[_currentTab]!.color,
        unselectedItemColor: Colors.grey,
        items: [
          ...tabConfigs.values.map(
            (config) => BottomNavigationBarItem(
              label: config.title,
              icon: Icon(config.icon),
            ),
          )
        ],
      ),
    );
  }
}
