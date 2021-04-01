import 'package:collection/collection.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class RootStackMarker extends StackMarker<bool> {
  RootStackMarker() : super();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return RouteStack<bool>(
      marker: RootStackMarker(),
      pages: (context, state) {
        return [
          const MaterialPage<dynamic>(
            key: ValueKey('Home'),
            child: HomePage(),
          ),
          if (state)
            const MaterialPage<dynamic>(
              key: ValueKey('Child'),
              child: ChildPage(),
            ),
        ];
      },
      updateStateOnNewRoute: (routeInfo) {
        final firstSegment = routeInfo.pathSegments.firstOrNull;
        return firstSegment == 'child';
      },
      updateRouteOnNewState: (state) {
        return state
            ? const RouteInfo(pathSegments: ['child'])
            : const RouteInfo();
      },
      updateStateBeforePop: (context, route, dynamic result, state) => false,
    );
  }
}

class ChildPage extends StatelessWidget {
  const ChildPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child'),
      ),
      body: Center(child: Text(faker.food.cuisine())),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          // context.navi.stack<StackMarker>('root').state = true;
          context.navi.stack(RootStackMarker()).state = true;
          // context.navi.parentStack.state = true;
        },
        child: const Text('Child'),
      )),
    );
  }
}
