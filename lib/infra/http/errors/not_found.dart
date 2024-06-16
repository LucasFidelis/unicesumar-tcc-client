class NotFound implements Exception {
  final String msg;
  const NotFound(this.msg);
  @override
  String toString() => msg;
}
