class ServerError implements Exception {
  final String msg;
  const ServerError(this.msg);
  @override
  String toString() => msg;
}
