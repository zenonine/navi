import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'app/index.dart';

void main() {
  timeDilation = 3; // slow motion (x times slower)
  runApp(App());
}
