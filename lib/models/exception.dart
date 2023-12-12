class Exceptions implements Exception {
  final String msg;

  Exceptions({required this.msg});

  @override // trying to override the default toString method
  String toString() {
    return msg;
    // return super.toString();
  }
}
