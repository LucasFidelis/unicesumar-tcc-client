import 'package:get/get.dart';

mixin UIErrorManager on GetxController {
  final _uiError = Rx<String?>(null);
  Stream<String?> get uiErrorStream => _uiError.stream;
  set uiError(String? value) => _uiError.value = value;
}
