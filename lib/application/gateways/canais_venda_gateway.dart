import 'package:app/infra/http/http_client.dart';
import 'package:app/pages/canais_venda/canal_venda_viewmodel.dart';

class CanaisVendaGateway {
  final String baseUrl;
  final HttpClient httpClient;

  CanaisVendaGateway({
    required this.baseUrl,
    required this.httpClient,
  });

  Future<List<CanalVendaViewModel>> list() async {
    final url = "$baseUrl/canais_venda";
    final response = await httpClient.request(url: url, method: 'get');
    return response
        .map<CanalVendaViewModel>(
          (canalData) => CanalVendaViewModel.fromJson(canalData),
        )
        .toList();
  }
}
