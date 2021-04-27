import 'package:collection/collection.dart';

class NaviRoute {
  const NaviRoute({
    this.path = const [],
    this.queryParams = const {},
    this.fragment = '',
  });

  factory NaviRoute.fromUri(Uri uri) => NaviRoute(
        path: uri.pathSegments,
        queryParams: uri.queryParametersAll,
        fragment: Uri.decodeComponent(uri.fragment),
      );

  final List<String> path;
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

  List<String> get normalizedPathSegments => _normalizedPathSegments(path);

  List<String> _normalizedPathSegments(List<String> pathSegments) =>
      pathSegments
          .expand((segment) => segment.split('/'))
          .map((segment) => segment.trim())
          .where((segment) => segment.isNotEmpty)
          .toList();

  bool hasPrefixes(List<String> pathSegments) {
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

  NaviRoute mergeCombinePath(NaviRoute other) => NaviRoute(
        path: normalizedPathSegments + other.normalizedPathSegments,
        queryParams: _mergeQueryParams(queryParams, other.queryParams),
        fragment: fragment.isEmpty ? other.fragment : fragment,
      );

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
  /// TODO: allow to choose strategy to merge params and fragment
  NaviRoute mergeSubtractPath(NaviRoute other) {
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

    return NaviRoute(
      path: newPathSegments,
      queryParams: _mergeQueryParams(queryParams, other.queryParams),
      fragment: fragment.isEmpty ? other.fragment : fragment,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NaviRoute &&
          runtimeType == other.runtimeType &&
          fragment == other.fragment &&
          const ListEquality<String>().equals(
            normalizedPathSegments,
            other.normalizedPathSegments,
          ) &&
          const DeepCollectionEquality.unordered().equals(
            queryParams,
            other.queryParams,
          );

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      fragment.hashCode ^
      const ListEquality<String>().hash(normalizedPathSegments) ^
      const DeepCollectionEquality.unordered().hash(queryParams);

  @override
  String toString() {
    return 'NaviRoute{path: $path, queryParams: $queryParams, fragment: $fragment}';
  }
}
