import 'package:logging/logging.dart';

Logger logger(Object object, [List<Object> others = const []]) {
  final objects = [object] + others;
  return Logger(['Navi', ...objects].join(': '));
}
