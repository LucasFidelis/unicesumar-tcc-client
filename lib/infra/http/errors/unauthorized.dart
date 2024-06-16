class Unauthorized implements Exception {
  final String msg;
  const Unauthorized(this.msg);
  @override
  String toString() => msg;
}
