For more details, please check [provided examples](https://github.com/zenonine/navi/blob/master/examples).

pubspec.xml

```
dependencies:
  navi: any
```

main.dart

```
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final _informationParser = NaviInformationParser();
  final _routerDelegate = NaviRouterDelegate(rootStack: BookStack());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Navi - Declarative navigation API for Flutter',
      routeInformationParser: _informationParser,
      routerDelegate: _routerDelegate,
    );
  }
}
```