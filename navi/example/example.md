[Full example source code](https://github.com/zenonine/navi/blob/master/examples/simple/lib/main.dart)

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
  runApp(MaterialApp.router(
    title: 'Navi - Declarative navigation API for Flutter',
    routeInformationParser: NaviInformationParser(),
    routerDelegate: NaviRouterDelegate(rootStack: BookStack()),
  ));
}
```