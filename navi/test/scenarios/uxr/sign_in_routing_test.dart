import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mocks.dart';

void main() {
  setUpAll(() {
    setupLogger();
  });

  tearDown(() {
    reset(mockLogger);
  });
}
