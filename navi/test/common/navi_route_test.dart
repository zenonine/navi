import 'package:navi/navi.dart';
import 'package:test/test.dart';

void main() {
  group('Equality', () {
    group(
        'GIVEN 2 NaviGroups have the same URI path with different input path segments',
        () {
      const route1 = NaviRoute(path: ['a', 'b']);
      const route2 = NaviRoute(path: ['a/b']);
      const route3 = NaviRoute(path: [' ', 'a', 'b', ' ']);

      test('they SHOULD be equal', () {
        expect(route1 == route2, true);
        expect(route2 == route3, true);
        expect(route3 == route1, true);
      });

      test('their hash codes SHOULD be equal', () {
        expect(route1.hashCode == route2.hashCode, true);
        expect(route2.hashCode == route3.hashCode, true);
        expect(route3.hashCode == route1.hashCode, true);
      });

      test('their URIs SHOULD be equal', () {
        expect(route1.uri == route2.uri, true);
        expect(route2.uri == route3.uri, true);
        expect(route3.uri == route1.uri, true);
      });

      test('their URIs in String SHOULD be equal', () {
        expect(route1.uri.toString() == route2.uri.toString(), true);
        expect(route2.uri.toString() == route3.uri.toString(), true);
        expect(route3.uri.toString() == route1.uri.toString(), true);
      });
    });

    group('GIVEN 2 NaviGroups have the same query params with different order',
        () {
      const route1 = NaviRoute(
        queryParams: {
          'a': ['a1', 'a2'],
          'b': ['b1', 'b2'],
        },
      );
      const route2 = NaviRoute(
        queryParams: {
          'b': ['b2', 'b1'],
          'a': ['a2', 'a1'],
        },
      );

      test('they SHOULD be equal', () {
        expect(route1 == route2, true);
      });

      test('their hash codes SHOULD be equal', () {
        expect(route1.hashCode == route2.hashCode, true);
      });
    });
  });
}
