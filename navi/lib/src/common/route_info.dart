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

  List<String> get normalizedPathSegments =>
      _normalizedPathSegments(pathSegments);

  List<String> _normalizedPathSegments(List<String> pathSegments) =>
      pathSegments
          .expand((segment) => segment.split('/'))
          .map((segment) => segment.trim())
          .where((segment) => segment.isNotEmpty)
          .toList();

  bool isPrefixed(List<String> pathSegments) {
    final _normalizedSegments = _normalizedPathSegments(pathSegments);

    if (normalizedPathSegments.length < _normalizedSegments.length) {
      return false;
    }

    return const ListEquality<String>().equals(
      _normalizedSegments,
      normalizedPathSegments.sublist(0, _normalizedSegments.length),
    );
  }

  String? pathSegmentAt(int position) {
    if (normalizedPathSegments.length > position) {
      return normalizedPathSegments[position];
    }
  }

  RouteInfo operator +(RouteInfo other) {
    return RouteInfo(
      pathSegments: normalizedPathSegments + other.normalizedPathSegments,
      queryParams: _mergeQueryParams(queryParams, other.queryParams),
      // TODO: fragment
      fragment: fragment,
    );
  }

  Map<String, List<String>> _mergeQueryParams(
    Map<String, List<String>> first,
    Map<String, List<String>> second,
  ) {
    final Map<String, List<String>> result = {};

    result.addAll(first);

    second.forEach((key, value) {
      result[key] = (result[key] ?? []) + value;
    });

    return result;
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
