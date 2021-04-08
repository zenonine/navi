import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class InnerStack extends StatelessWidget {
  const InnerStack({required this.config});

  final TabConfig config;

  List<String> get _items =>
      List.generate(config.size, (index) => '${config.title} $index');

  @override
  Widget build(BuildContext context) {
    return RouteStack<int?>(
      marker: InnerStackMarker(),
      pages: (context, state) {
        print('InnerStackMarker $state');
        return [
          NaviPage.material(
            key: const ValueKey('TabFirstPage'),
            child: TabFirstPage(
              config: config,
              items: _items,
            ),
          ),
          if (state != null)
            NaviPage.material(
              key: ValueKey(state),
              child: TabSecondPage(
                config: config,
                text: '${config.title} #$state',
              ),
            ),
        ];
      },
      updateStateOnNewRoute: (routeInfo) {
        final index = int.tryParse(routeInfo.pathSegmentAt(0) ?? '');
        return (index != null && index < config.size) ? index : null;
      },
      updateRouteOnNewState: (state) =>
          RouteInfo(pathSegments: state != null ? ['$state'] : []),
      updateStateBeforePop: (context, route, dynamic result, state) => null,
    );
  }
}

class InnerStackMarker extends StackMarker<int?> {}
