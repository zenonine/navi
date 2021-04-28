import 'package:navi/navi.dart';
import 'package:test/test.dart';

void main() {
  group('Equality', () {
    group(
        'GIVEN NaviRoutes with the same URI path but different input path segments',
        () {
      const route1 = NaviRoute(path: ['a', 'b']);
      const route2 = NaviRoute(path: ['a/b']);
      const route3 = NaviRoute(path: [' ', ' a ', ' b ', ' ']);

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

    group(
      'GIVEN NaviRoutes with the same query params in different order',
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
      },
    );

    group('GIVEN NaviRoutes with the same fragment', () {
      const route1 = NaviRoute(fragment: 'a');
      const route2 = NaviRoute(fragment: 'a');

      test('they SHOULD be equal', () {
        expect(route1 == route2, true);
      });

      test('their hash codes SHOULD be equal', () {
        expect(route1.hashCode == route2.hashCode, true);
      });

      test('their URIs in String SHOULD be equal', () {
        expect(route1.uri.toString() == route2.uri.toString(), true);
      });
    });

    group(
      'GIVEN NaviRoutes with same path but different input path segments'
      ', same query params in different order and same fragment',
      () {
        const route1 = NaviRoute(
          path: ['a', 'b'],
          queryParams: {
            'a': ['a1', 'a2'],
            'b': ['b1', 'b2'],
          },
          fragment: 'a',
        );
        const route2 = NaviRoute(
          path: [' ', 'a/b', ' '],
          queryParams: {
            'b': ['b2', 'b1'],
            'a': ['a2', 'a1'],
          },
          fragment: 'a',
        );

        test('they SHOULD be equal', () {
          expect(route1 == route2, true);
        });

        test('their hash codes SHOULD be equal', () {
          expect(route1.hashCode == route2.hashCode, true);
        });
      },
    );
  });

  group('Inequality', () {
    group('GIVEN NaviRoutes with the different URI path', () {
      const route1 = NaviRoute(path: ['a', 'b']);
      const route2 = NaviRoute(path: ['b', 'a']);
      const route3 = NaviRoute(path: ['a']);
      const route4 = NaviRoute(path: ['b']);

      test('they SHOULD NOT be equal', () {
        expect(route1 == route2, false);
        expect(route2 == route3, false);
        expect(route3 == route4, false);
        expect(route4 == route1, false);
      });

      test('their hash codes SHOULD NOT be equal', () {
        expect(route1.hashCode == route2.hashCode, false);
        expect(route2.hashCode == route3.hashCode, false);
        expect(route3.hashCode == route4.hashCode, false);
        expect(route4.hashCode == route1.hashCode, false);
      });

      test('their URIs SHOULD NOT be equal', () {
        expect(route1.uri == route2.uri, false);
        expect(route2.uri == route3.uri, false);
        expect(route3.uri == route4.uri, false);
        expect(route4.uri == route1.uri, false);
      });

      test('their URIs in String SHOULD NOT be equal', () {
        expect(route1.uri.toString() == route2.uri.toString(), false);
        expect(route2.uri.toString() == route3.uri.toString(), false);
        expect(route3.uri.toString() == route4.uri.toString(), false);
        expect(route4.uri.toString() == route1.uri.toString(), false);
      });
    });

    group(
      'GIVEN NaviRoutes with different query params',
      () {
        const route1 = NaviRoute(queryParams: {
          'a': ['a1']
        });
        const route2 = NaviRoute(queryParams: {
          'a': ['a1 ']
        });
        const route3 = NaviRoute(queryParams: {
          'a': [' a1']
        });
        const route4 = NaviRoute(
          queryParams: {
            ' a': ['a1']
          },
        );
        const route5 = NaviRoute(queryParams: {
          'a ': ['a1']
        });
        const route6 = NaviRoute(queryParams: {
          'a': ['a1', 'a2']
        });
        const route7 = NaviRoute(queryParams: {
          'a': ['a1'],
          'b': ['b1']
        });

        test('they SHOULD NOT be equal', () {
          expect(route1 == route2, false);
          expect(route2 == route3, false);
          expect(route3 == route4, false);
          expect(route4 == route5, false);
          expect(route5 == route6, false);
          expect(route6 == route7, false);
          expect(route7 == route1, false);
        });

        test('their hash codes SHOULD NOT be equal', () {
          expect(route1.hashCode == route2.hashCode, false);
          expect(route2.hashCode == route3.hashCode, false);
          expect(route3.hashCode == route4.hashCode, false);
          expect(route4.hashCode == route5.hashCode, false);
          expect(route5.hashCode == route6.hashCode, false);
          expect(route6.hashCode == route7.hashCode, false);
          expect(route7.hashCode == route1.hashCode, false);
        });
      },
    );

    group('GIVEN NaviRoutes with different fragments', () {
      const route1 = NaviRoute(fragment: 'a');
      const route2 = NaviRoute(fragment: 'a ');
      const route3 = NaviRoute(fragment: ' a');
      const route4 = NaviRoute(fragment: 'b');

      test('they SHOULD NOT be equal', () {
        expect(route1 == route2, false);
        expect(route2 == route3, false);
        expect(route3 == route4, false);
        expect(route4 == route1, false);
      });

      test('their hash codes SHOULD NOT be equal', () {
        expect(route1.hashCode == route2.hashCode, false);
        expect(route2.hashCode == route3.hashCode, false);
        expect(route3.hashCode == route4.hashCode, false);
        expect(route4.hashCode == route1.hashCode, false);
      });

      test('their URIs in String SHOULD NOT be equal', () {
        expect(route1.hashCode.toString() == route2.hashCode.toString(), false);
        expect(route2.hashCode.toString() == route3.hashCode.toString(), false);
        expect(route3.hashCode.toString() == route4.hashCode.toString(), false);
        expect(route4.hashCode.toString() == route1.hashCode.toString(), false);
      });
    });
  });

  group('Normalized URI String', () {
    test('SHOULD start with a slash', () {
      expect(const NaviRoute().uri.toString(), '/');
      expect(const NaviRoute(path: [' ']).uri.toString(), '/');
      expect(const NaviRoute(path: [' a ']).uri.toString(), '/a');
      expect(const NaviRoute(path: [' ', ' a ']).uri.toString(), '/a');
    });

    test('SHOULD NOT end with a slash', () {
      expect(const NaviRoute(path: [' a/']).uri.toString(), '/a');
      expect(const NaviRoute(path: [' a ', ' ']).uri.toString(), '/a');
      expect(const NaviRoute(path: [' a/', ' ']).uri.toString(), '/a');
    });

    test('SHOULD NOT have redundant slashes', () {
      expect(const NaviRoute(path: ['///']).uri.toString(), '/');
      expect(
        const NaviRoute(path: ['///a///b///c///']).uri.toString(),
        '/a/b/c',
      );
    });
  });

  group('hasPrefixes', () {
    test('/a/b SHOULD has prefixes / or /a or /a/b', () {
      const route = NaviRoute(path: ['a', 'b']);
      expect(route.hasPrefixes([]), true);
      expect(route.hasPrefixes(['a']), true);
      expect(route.hasPrefixes(['a', 'b']), true);
    });

    test('/a/b SHOULD NOT has prefixes /b or /b/a or /a/b/c', () {
      const route = NaviRoute(path: ['a', 'b']);
      expect(route.hasPrefixes(['b']), false);
      expect(route.hasPrefixes(['b', 'a']), false);
      expect(route.hasPrefixes(['a', 'b', 'c']), false);
    });
  });

  group('pathSegmentAt', () {
    group('GIVEN path /a/b', () {
      const route = NaviRoute(path: ['/a/b']);
      test('path segment at 0 SHOULD be a', () {
        expect(route.pathSegmentAt(0), 'a');
      });

      test('path segment at 1 SHOULD be b', () {
        expect(route.pathSegmentAt(1), 'b');
      });

      test('path segment at 2 SHOULD be null', () {
        expect(route.pathSegmentAt(2), null);
      });

      test('path segment at -1 SHOULD be null', () {
        expect(route.pathSegmentAt(-1), null);
      });
    });
  });

  group('mergeCombinePath', () {
    test('SHOULD join paths of both routes', () {
      const route1 = NaviRoute(path: ['a']);
      const route2 = NaviRoute(path: ['b']);
      const mergedRute = NaviRoute(path: ['a', 'b']);
      expect(route1.mergeCombinePath(route2), mergedRute);
    });

    test('SHOULD keep query params of both routes', () {
      const route1 = NaviRoute(queryParams: {
        'a': ['a1'],
        'b': ['b1'],
      });
      const route2 = NaviRoute(queryParams: {
        'a': ['a2'],
        'c': ['c1'],
      });
      const mergedRute = NaviRoute(queryParams: {
        'a': ['a1', 'a2'],
        'b': ['b1'],
        'c': ['c1'],
      });
      expect(route1.mergeCombinePath(route2), mergedRute);
    });

    group(
      'GIVEN original fragment is empty'
      ', secondary fragment is empty',
      () {
        test('fragment SHOULD be empty', () {
          const route1 = NaviRoute();
          const route2 = NaviRoute();
          expect(route1.mergeCombinePath(route2).fragment, '');
        });
      },
    );

    group(
      'GIVEN original fragment is not empty'
      ', secondary fragment is empty',
      () {
        test('SHOULD keep fragment of original route', () {
          const route1 = NaviRoute(fragment: ' 1 ');
          const route2 = NaviRoute(fragment: ' ');
          const secondaryRoute = NaviRoute();
          expect(route1.mergeCombinePath(secondaryRoute).fragment, ' 1 ');
          expect(route2.mergeCombinePath(secondaryRoute).fragment, ' ');
        });
      },
    );

    group(
      'GIVEN original fragment is empty'
      ', secondary fragment is not empty',
      () {
        test('SHOULD keep fragment of secondary route', () {
          const route = NaviRoute();
          const secondaryRoute1 = NaviRoute(fragment: ' 1 ');
          const secondaryRoute2 = NaviRoute(fragment: ' ');
          expect(route.mergeCombinePath(secondaryRoute1).fragment, ' 1 ');
          expect(route.mergeCombinePath(secondaryRoute2).fragment, ' ');
        });
      },
    );
  });

  group('mergeSubtractPath', () {
    group('GIVEN original path /a/b and secondary path /', () {
      test('merged path SHOULD be /a/b', () {
        const route1 = NaviRoute(path: ['a', 'b']);
        const route2 = NaviRoute();
        const mergedRute = NaviRoute(path: ['a', 'b']);
        expect(route1.mergeSubtractPath(route2), mergedRute);
      });
    });

    group('GIVEN original path /a/b and secondary path /a', () {
      test('merged path SHOULD be /b', () {
        const route1 = NaviRoute(path: ['a', 'b']);
        const route2 = NaviRoute(path: ['a']);
        const mergedRute = NaviRoute(path: ['b']);
        expect(route1.mergeSubtractPath(route2), mergedRute);
      });
    });

    group('GIVEN original path /a/b and secondary path /a/b', () {
      test('merged path SHOULD be /', () {
        const route1 = NaviRoute(path: ['a', 'b']);
        const route2 = NaviRoute(path: ['a', 'b']);
        const mergedRute = NaviRoute();
        expect(route1.mergeSubtractPath(route2), mergedRute);
      });
    });

    group('GIVEN original path /a/b and secondary path /a/b/c', () {
      test('merged path SHOULD be /', () {
        const route1 = NaviRoute(path: ['a', 'b']);
        const route2 = NaviRoute(path: ['a', 'b', 'c']);
        const mergedRute = NaviRoute();
        expect(route1.mergeSubtractPath(route2), mergedRute);
      });
    });

    group('GIVEN original path /a/b and secondary path /b', () {
      test('merged path SHOULD be /', () {
        const route1 = NaviRoute(path: ['a', 'b']);
        const route2 = NaviRoute(path: ['b']);
        const mergedRute = NaviRoute();
        expect(route1.mergeSubtractPath(route2), mergedRute);
      });
    });

    group('GIVEN original path /a/b and secondary path /c', () {
      test('merged path SHOULD be /', () {
        const route1 = NaviRoute(path: ['a', 'b']);
        const route2 = NaviRoute(path: ['c']);
        const mergedRute = NaviRoute();
        expect(route1.mergeSubtractPath(route2), mergedRute);
      });
    });

    test('SHOULD keep query params of both routes', () {
      const route1 = NaviRoute(queryParams: {
        'a': ['a1'],
        'b': ['b1'],
      });
      const route2 = NaviRoute(queryParams: {
        'a': ['a2'],
        'c': ['c1'],
      });
      const mergedRute = NaviRoute(queryParams: {
        'a': ['a1', 'a2'],
        'b': ['b1'],
        'c': ['c1'],
      });
      expect(route1.mergeSubtractPath(route2), mergedRute);
    });

    group(
      'GIVEN original fragment is empty'
      ', secondary fragment is empty',
      () {
        test('fragment SHOULD be empty', () {
          const route1 = NaviRoute();
          const route2 = NaviRoute();
          expect(route1.mergeSubtractPath(route2).fragment, '');
        });
      },
    );

    group(
      'GIVEN original fragment is not empty'
      ', secondary fragment is empty',
      () {
        test('SHOULD keep fragment of original route', () {
          const route1 = NaviRoute(fragment: ' 1 ');
          const route2 = NaviRoute(fragment: ' ');
          const secondaryRoute = NaviRoute();
          expect(route1.mergeSubtractPath(secondaryRoute).fragment, ' 1 ');
          expect(route2.mergeSubtractPath(secondaryRoute).fragment, ' ');
        });
      },
    );

    group(
      'GIVEN original fragment is empty'
      ', secondary fragment is not empty',
      () {
        test('SHOULD keep fragment of secondary route', () {
          const route = NaviRoute();
          const secondaryRoute1 = NaviRoute(fragment: ' 1 ');
          const secondaryRoute2 = NaviRoute(fragment: ' ');
          expect(route.mergeSubtractPath(secondaryRoute1).fragment, ' 1 ');
          expect(route.mergeSubtractPath(secondaryRoute2).fragment, ' ');
        });
      },
    );
  });
}
