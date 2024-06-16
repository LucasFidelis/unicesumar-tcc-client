import 'package:app/application/mixins/ui_error_manager.dart';
import 'package:app/infra/http/http_client.dart';
import 'package:app/pages/canais_venda/canal_venda_viewmodel.dart';
import 'package:get/get.dart';

class CanaisVendaController extends GetxController with UIErrorManager {
  final HttpClient httpClient;
  final String baseUrl;
  final _canais = Rx<List<CanalVendaViewModel>>([]);
  Stream<List<CanalVendaViewModel>> get canaisStream => _canais.stream;

  CanaisVendaController({required this.httpClient, required this.baseUrl});

  Future<void> loadCanaisVenda() async {
    final url = "$baseUrl/canais_venda";
    final response = await httpClient.request(url: url, method: 'get');
    _canais.value = response
        .map<CanalVendaViewModel>(
          (canalData) => CanalVendaViewModel.fromJson(canalData),
        )
        .toList();
  }

  Future<void> deletarCanal(CanalVendaViewModel canal) async {
    uiError = null;
    try {
      final url = "$baseUrl/canais_venda/${canal.id}";
      await httpClient.request(url: url, method: 'delete');
      loadCanaisVenda();
    } catch (error) {
      uiError = error.toString();
    }
  }

  Future<void> criarCanal(String nome, String prioridade) async {
    final url = "$baseUrl/canais_venda";
    final Map body = {'nome': nome, 'prioridade': prioridade};
    await httpClient.request(url: url, method: 'post', body: body);
    loadCanaisVenda();
  }

  Future<void> editarCanal(CanalVendaViewModel canal) async {
    final url = "$baseUrl/canais_venda/${canal.id}";
    final Map body = {'nome': canal.nome, 'prioridade': canal.prioridade};
    await httpClient.request(url: url, method: 'post', body: body);
    loadCanaisVenda();
  }
}
