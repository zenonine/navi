import 'package:flutter/widgets.dart';
import 'package:navi/navi.dart';
import 'package:test/test.dart';

void main() {
  /// https://en.wikipedia.org/wiki/Percent-encoding
  /// NOTE: + means space only in query params
  final parser = NaviInformationParser();

  group('Convert location to NaviRoute', () {
    test('SHOULD decode components', () async {
      const routeInfo = RouteInformation(
        location: '/%20%C3%A4+?+%C3%BC%20=+%C3%B6%20'
            '#%C3%84+%C3%9C%20%C3%96',
      );
      const expectedRoute = NaviRoute(
        path: [' ä+'],
        queryParams: {
          ' ü ': [' ö ']
        },
        fragment: 'Ä+Ü Ö',
      );

      final route = await parser.parseRouteInformation(routeInfo);
      expect(route, expectedRoute);
    });
  });

  group('Convert NaviRoute to location', () {
    test('SHOULD encode components', () {
      const route = NaviRoute(
        path: [' ä+'],
        queryParams: {
          ' ü ': [' ö ']
        },
        fragment: 'Ä+Ü Ö',
      );
      const expectedLocation =
          '/%C3%A4+?+%C3%BC+=+%C3%B6+#%C3%84+%C3%9C%20%C3%96';

      final routeInfo = parser.restoreRouteInformation(route);
      expect(routeInfo.location, expectedLocation);
    });
  });
}
