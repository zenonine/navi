class StackMarker<T> {
  const StackMarker([this.id]);

  final T? id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StackMarker &&
          runtimeType == other.runtimeType &&
          id == other.id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  @override
  String toString() {
    return '$runtimeType{id: $id}';
  }
}
