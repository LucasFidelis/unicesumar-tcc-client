import 'package:app/infra/http/http_client.dart';
import 'package:app/application/mixins/ui_error_manager.dart';
import 'package:app/pages/separadores/separador_view_model.dart';
import 'package:get/get.dart';

class SeparadoresController extends GetxController with UIErrorManager {
  final HttpClient httpClient;
  final String baseUrl;
  final _separadores = Rx<List<SeparadorViewModel>>([]);
  Stream<List<SeparadorViewModel>> get separadoresStream => _separadores.stream;

  SeparadoresController({required this.httpClient, required this.baseUrl});

  Future<void> loadSeparadores() async {
    final url = "$baseUrl/separadores";
    final response = await httpClient.request(url: url, method: 'get');
    _separadores.value = response
        .map<SeparadorViewModel>(
          (separadorData) => SeparadorViewModel.fromJson(separadorData),
        )
        .toList();
  }

  Future<void> criarSeparador(String nome, String documento) async {
    uiError = null;
    try {
      final url = "$baseUrl/separadores";
      Map body = {"nome": nome, "cpf": documento};
      await httpClient.request(url: url, method: 'post', body: body);
      loadSeparadores();
    } catch (error) {
      uiError = error.toString();
    }
  }

  Future<void> deletarSeparador(SeparadorViewModel separador) async {
    uiError = null;
    try {
      final url = "$baseUrl/separadores/${separador.id}";
      await httpClient.request(url: url, method: 'delete');
      loadSeparadores();
    } catch (error) {
      uiError = error.toString();
    }
  }

  Future<void> editarSeparador(SeparadorViewModel separador) async {
    uiError = null;
    try {
      final url = "$baseUrl/separadores/${separador.id}";
      Map body = {"nome": separador.nome, "cpf": separador.cpf};
      await httpClient.request(url: url, method: 'post', body: body);
      loadSeparadores();
    } catch (error) {
      uiError = error.toString();
    }
  }
}
