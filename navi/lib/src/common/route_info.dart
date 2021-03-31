import 'package:collection/collection.dart';

class RouteInfo {
  const RouteInfo({
    this.pathSegments = const [],
    this.queryParams = const {},
    this.fragment = '',
  });

  factory RouteInfo.fromUri(Uri uri) => RouteInfo(
        pathSegments: uri.pathSegments,
        queryParams: uri.queryParametersAll,
        fragment: Uri.decodeComponent(uri.fragment),
      );

  final List<String> pathSegments;
  final Map<String, List<String>> queryParams;
  final String fragment;

  Uri get uri {
    var normalizedPathSegments = this.normalizedPathSegments;

    // make sure always having a root segment
    if (normalizedPathSegments.isEmpty) {
      normalizedPathSegments = [''];
    }

    return Uri(
      // make sure path will starts with a slash
      pathSegments: ['', ...normalizedPathSegments],
      queryParameters: queryParams.isEmpty ? null : queryParams,
      fragment: fragment.isEmpty ? null : fragment,
    );
  }

  List<String> get normalizedPathSegments => pathSegments
      .expand((segment) => segment.split('/'))
      .map((segment) => segment.trim())
      .where((segment) => segment.isNotEmpty)
      .toList();

  RouteInfo operator +(RouteInfo other) {
    return RouteInfo(
      pathSegments: normalizedPathSegments + other.normalizedPathSegments,
      // TODO: queryParams
      queryParams: queryParams,
      // TODO: fragment
      fragment: fragment,
    );
  }

  /// ```
  /// [a, b, c] - [a, b] = [c]
  /// [a, b, c] - [a, b, c] = []
  /// [a, b, c] - [a, b, d] = []
  /// [a, b, c] - [a, b, c, d] = []
  /// [a, b, c] - [d] = []
  /// ```
  RouteInfo operator -(RouteInfo other) {
    final thisPathSegments = normalizedPathSegments;
    final otherPathSegments = other.normalizedPathSegments;

    List<String> newPathSegments = [];
    if (otherPathSegments.length < thisPathSegments.length) {
      final equals = const ListEquality<String>().equals(
        otherPathSegments,
        thisPathSegments.sublist(0, otherPathSegments.length),
      );

      if (equals) {
        newPathSegments = thisPathSegments.sublist(otherPathSegments.length);
      }
    }

    return RouteInfo(
      pathSegments: newPathSegments,
      // TODO: queryParams
      queryParams: queryParams,
      // TODO: fragment
      fragment: fragment,
    );
  }

  @override
  String toString() {
    return 'RouteInfo{pathSegments: $pathSegments, queryParams: $queryParams, fragment: $fragment}';
  }
}
