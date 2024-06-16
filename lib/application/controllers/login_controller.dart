import 'package:app/application/mixins/ui_error_manager.dart';
import 'package:app/application/token_manager.dart';
import 'package:app/infra/http/http_client.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with UIErrorManager {
  final HttpClient httpClient;
  final String baseUrl;
  final TokenManager tokenManager = TokenManager();

  LoginController({required this.httpClient, required this.baseUrl});

  Future<void> logar(String usuario, String senha) async {
    try {
      uiError = null;
      final url = "$baseUrl/auth";
      final Map body = {'login': usuario, 'senha': senha};
      final response = await httpClient.request(url: url, method: 'post', body: body);
      final accessToken = response['accessToken'];
      final role = response['role'];
      await tokenManager.setToken(accessToken);
      await tokenManager.setRole(role);
      goToDashboard();
    } catch (error) {
      uiError = error.toString();
    }
  }

  void goToDashboard() {
    Get.toNamed('/dashboard');
  }
}
