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

  @override
  void initState() {
    super.initState();

    _stackController.addListener(() {
      setState(() {
        _currentTab = _stackController.state;
      });
    });
  }

  @override
  void dispose() {
    _stackController.dispose();
    super.dispose();
  }

  RouteStack<AppTab> _buildRouteStack() {
    return RouteStack<AppTab>(
      controller: _stackController,
      pages: (context, state) {
        return [
          // To remember state, keep the page in the stack behind the active page
          // When trying to render multiple tabs to remember state, there are some bugs:
          // TODO: sometime get error !_needsLayout is not true
          // TODO: always use path segments of the initial URL for child pages, ex.
          //   * enter initial URL /school/5 to open the app
          //   * open tab flight, the url is correct `/flight`, but the state is wrong.
          //   * reason: the nested stack for inactive tab still parse the URL to get initial state.
          // TODO: make sure pop will always be redirected to parent router
          ...tabConfigs.entries.where((entry) => entry.key != state).map(
                (entry) => TabPage(
                  key: ValueKey(entry.key),
                  child: InnerStack(config: entry.value),
                ),
              ),
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
