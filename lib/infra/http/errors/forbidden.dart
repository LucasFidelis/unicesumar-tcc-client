class Forbidden implements Exception {
  final String msg;
  const Forbidden(this.msg);
  @override
  String toString() => msg;
}
