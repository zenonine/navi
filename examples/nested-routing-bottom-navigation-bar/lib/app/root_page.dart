import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  var _currentTab = AppTab.home;
  final _stackController = StackController<AppTab>();
  late final VoidCallback _stackListener;

  @override
  void initState() {
    super.initState();

    _stackListener = () {
      setState(() {
        _currentTab = _stackController.state;
      });
    };
    _stackController.addListener(_stackListener);
  }

  @override
  void dispose() {
    _stackController.removeListener(_stackListener);
    super.dispose();
  }

  RouteStack<AppTab> _buildRouteStack() {
    return RouteStack<AppTab>(
      controller: _stackController,
      pages: (context, state) {
        return [
          // TODO: remember state of each tab?
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
        final config =
            tabConfigs.values.firstWhereOrNull((config) => config.path == path);
        return config?.tab ?? AppTab.home;
      },
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildRouteStack(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
