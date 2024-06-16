import 'package:app/application/mixins/ui_error_manager.dart';
import 'package:app/infra/http/http_client.dart';
import 'package:app/pages/dashboard/pedido_separacao_view_model.dart';
import 'package:app/pages/dashboard/separacao_view_model.dart';
import 'package:app/pages/pedidos/pedido_view_model.dart';
import 'package:app/pages/separadores/separador_view_model.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController with UIErrorManager {
  final HttpClient httpClient;
  final String baseUrl;

  final _pedidosAltaPrioridade = Rx<List<PedidoViewModel>>([]);
  Stream<List<PedidoViewModel>> get pedidosAltaPrioridadeStream => _pedidosAltaPrioridade.stream;
  final _pedidosMediaPrioridade = Rx<List<PedidoViewModel>>([]);
  Stream<List<PedidoViewModel>> get pedidosMediaPrioridade => _pedidosMediaPrioridade.stream;
  final _pedidosBaixaPrioridade = Rx<List<PedidoViewModel>>([]);
  Stream<List<PedidoViewModel>> get pedidosBaixaPrioridade => _pedidosBaixaPrioridade.stream;
  final _pedidosEmSeparacao = Rx<List<PedidoSeparacaoViewModel>>([]);
  Stream<List<PedidoSeparacaoViewModel>> get pedidosEmSeparacao => _pedidosEmSeparacao.stream;
  final _pedidosSeparados = Rx<List<PedidoSeparacaoViewModel>>([]);
  Stream<List<PedidoSeparacaoViewModel>> get pedidosSeparados => _pedidosSeparados.stream;
  final _separadores = Rx<List<SeparadorViewModel>>([]);
  Stream<List<SeparadorViewModel>> get separadoresStream => _separadores.stream;

  DashboardController({required this.httpClient, required this.baseUrl});

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
    final separacoes = await loadSeparacoes();
    final separadores = await loadSeparadores();
    _pedidosAltaPrioridade.value = pedidos
        .where(
          (pedido) => pedido.canalVenda.prioridade == 'Alta' && pedidoTemSeparacao(pedido, separacoes) == null,
        )
        .toList();
    _pedidosMediaPrioridade.value = pedidos
        .where(
          (pedido) => pedido.canalVenda.prioridade == 'Média' && pedidoTemSeparacao(pedido, separacoes) == null,
        )
        .toList();
    _pedidosBaixaPrioridade.value = pedidos
        .where(
          (pedido) => pedido.canalVenda.prioridade == 'Baixa' && pedidoTemSeparacao(pedido, separacoes) == null,
        )
        .toList();
    _pedidosEmSeparacao.value = getPedidosEmSeparacao(pedidos, separacoes, separadores);
    _pedidosSeparados.value = getPedidosSeparados(pedidos, separacoes, separadores);
  }

  SeparacaoViewModel? pedidoTemSeparacao(PedidoViewModel pedido, List<SeparacaoViewModel> separacoes) {
    for (final separacao in separacoes) {
      if (pedido.id == separacao.pedidoId) return separacao;
    }
    return null;
  }

  List<PedidoSeparacaoViewModel> getPedidosEmSeparacao(
    List<PedidoViewModel> pedidos,
    List<SeparacaoViewModel> separacoes,
    List<SeparadorViewModel> separadores,
  ) {
    List<PedidoSeparacaoViewModel> pedidosEmSeparacao = [];
    for (final pedido in pedidos) {
      final separacao = pedidoTemSeparacao(pedido, separacoes);
      if (separacao != null && separacao.status == 'iniciado') {
        final separador = separadores.where((separador) => separador.id == separacao.separadorId).first;
        final pedidoSeparacao = PedidoSeparacaoViewModel(
          pedido: pedido,
          separacao: separacao,
          separador: separador,
        );
        pedidosEmSeparacao.add(pedidoSeparacao);
      }
    }
    return pedidosEmSeparacao;
  }

  List<PedidoSeparacaoViewModel> getPedidosSeparados(
    List<PedidoViewModel> pedidos,
    List<SeparacaoViewModel> separacoes,
    List<SeparadorViewModel> separadores,
  ) {
    List<PedidoSeparacaoViewModel> pedidosEmSeparacao = [];
    for (final pedido in pedidos) {
      final separacao = pedidoTemSeparacao(pedido, separacoes);
      if (separacao != null && separacao.status == 'finalizado') {
        final separador = separadores.where((separador) => separador.id == separacao.separadorId).first;
        final pedidoSeparacao = PedidoSeparacaoViewModel(
          pedido: pedido,
          separacao: separacao,
          separador: separador,
        );
        pedidosEmSeparacao.add(pedidoSeparacao);
      }
    }
    return pedidosEmSeparacao;
  }

  Future<List<SeparacaoViewModel>> loadSeparacoes() async {
    final url = "$baseUrl/separacoes";
    final response = await httpClient.request(url: url, method: 'get');
    return response
        .map<SeparacaoViewModel>(
          (data) => SeparacaoViewModel.fromJson(data),
        )
        .toList();
  }

  Future<List<SeparadorViewModel>> loadSeparadores() async {
    final url = "$baseUrl/separadores";
    final response = await httpClient.request(url: url, method: 'get');
    final separadores = response
        .map<SeparadorViewModel>(
          (separadorData) => SeparadorViewModel.fromJson(separadorData),
        )
        .toList();
    _separadores.value = separadores;
    return separadores;
  }

  Future<void> iniciarSeparacao(PedidoViewModel pedido, SeparadorViewModel separador) async {
    final url = "$baseUrl/separacoes";
    final Map body = {
      'pedidoId': pedido.id,
      'separadorId': separador.id,
    };
    await httpClient.request(url: url, method: 'post', body: body);
    loadPedidos();
  }

  Future<void> finalizarSeparacao(PedidoSeparacaoViewModel pedidoSeparacao) async {
    final url = "$baseUrl/separacoes/${pedidoSeparacao.separacao.id}/finalizar";
    await httpClient.request(url: url, method: 'post');
    loadPedidos();
  }

  Future<void> retornarSeparacao(PedidoSeparacaoViewModel pedidoSeparacao) async {
    try {
      final url = "$baseUrl/separacoes/${pedidoSeparacao.separacao.id}";
      await httpClient.request(url: url, method: 'delete');
      loadPedidos();
    } catch (error) {
      uiError = error.toString();
    }
  }

  String imprimirPedidoURL(PedidoViewModel pedido) {
    return '$baseUrl/pedidos/${pedido.id}/imprimir';
  }
}
