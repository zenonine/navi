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

  // TODO: use path package?
  List<String> get normalizedPathSegments => pathSegments
      .expand((segment) => segment.split('/'))
      .map((segment) => segment.trim())
      .where((segment) => segment.isNotEmpty)
      .toList();

  @override
  String toString() {
    return 'RouteInfo{pathSegments: $pathSegments, queryParams: $queryParams, fragment: $fragment}';
  }
}
