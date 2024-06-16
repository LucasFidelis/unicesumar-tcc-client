import 'package:app/application/gateways/canais_venda_gateway.dart';
import 'package:app/main/factories/http_client_factory.dart';
import 'package:app/main/factories/pedidos_page_factory.dart';
import 'package:app/pages/pedidos/criar_pedido.dart';
import 'package:app/main/config.dart' as Config;

CanaisVendaGateway makeCanaisVendaGateway() => CanaisVendaGateway(
      baseUrl: Config.baseUrl,
      httpClient: makeHttpClient(),
    );
CriarPedido makeCriarPedidoPage() => CriarPedido(
      controller: makePedidosController(),
      canaisVendaGateway: makeCanaisVendaGateway(),
    );
