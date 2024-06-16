import 'package:app/application/mixins/ui_error_manager.dart';
import 'package:app/infra/http/http_client.dart';
import 'package:app/pages/pedidos/pedido_view_model.dart';
import 'package:get/get.dart';

class PedidosController extends GetxController with UIErrorManager {
  final HttpClient httpClient;
  final String baseUrl;
  final _pedidos = Rx<List<PedidoViewModel>>([]);
  Stream<List<PedidoViewModel>> get pedidosStream => _pedidos.stream;

  PedidosController({required this.httpClient, required this.baseUrl});

  Future<Map<String, dynamic>> loadCanalVenda(String canalVendaId) async {
    final url = "$baseUrl/canais_venda/$canalVendaId";
    return await httpClient.request(url: url, method: 'get');
  }

  Future<void> loadPedidos() async {
    final url = "$baseUrl/pedidos";
    final response = await httpClient.request(url: url, method: 'get');
    final List<PedidoViewModel> pedidos = [];
    for (var pedido in response) {
      final canalVendaData = await loadCanalVenda(pedido['canalVendaId']);
      pedido['canalVenda'] = canalVendaData;
      pedido = PedidoViewModel.fromJson(pedido);
      pedidos.add(pedido);
    }
    _pedidos.value = pedidos;
  }

  Future<PedidoViewModel> loadPedido(String pedidoId) async {
    final url = "$baseUrl/pedidos/$pedidoId";
    final response = await httpClient.request(url: url, method: 'get');
    final canalVendaData = await loadCanalVenda(response['canalVendaId']);
    response['canalVenda'] = canalVendaData;
    return PedidoViewModel.fromJson(response);
  }

  Future<void> criarPedido(PedidoViewModel pedido) async {
    final url = "$baseUrl/pedidos";
    final Map body = pedido.toJson();
    await httpClient.request(url: url, method: 'post', body: body);
    Get.toNamed('/dashboard');
  }

  Future<void> deletarPedido(PedidoViewModel pedido) async {
    uiError = null;
    try {
      final url = "$baseUrl/pedidos/${pedido.id}";
      await httpClient.request(url: url, method: 'delete');
      loadPedidos();
    } catch (error) {
      uiError = error.toString();
    }
  }

  Future<void> editarPedido(PedidoViewModel pedido) async {
    final url = "$baseUrl/pedidos/${pedido.id}";
    final Map body = pedido.toJson();
    body.remove('id');
    await httpClient.request(url: url, method: 'post', body: body);
    Get.toNamed('/dashboard');
  }
}
