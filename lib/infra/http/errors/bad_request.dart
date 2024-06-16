class BadRequest implements Exception {
  final String msg;
  const BadRequest(this.msg);
  @override
  String toString() => msg;
}
