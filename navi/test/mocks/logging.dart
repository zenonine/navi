import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';

void setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(
      '${record.level.name.padRight(7)}'
      ' ${record.time}'
      ' ${record.loggerName}: ${record.message}',
    );
  });
}

class MockLogger extends Mock implements Logger {}

final mockLogger = MockLogger();
