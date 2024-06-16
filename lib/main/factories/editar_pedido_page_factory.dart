import 'package:app/application/gateways/canais_venda_gateway.dart';
import 'package:app/main/factories/http_client_factory.dart';
import 'package:app/main/factories/pedidos_page_factory.dart';
import 'package:app/main/config.dart' as Config;
import 'package:app/pages/pedidos/editar_pedido.dart';

CanaisVendaGateway makeCanaisVendaGateway() => CanaisVendaGateway(
      baseUrl: Config.baseUrl,
      httpClient: makeHttpClient(),
    );
EditarPedido makeEditarPedidoPage() => EditarPedido(
      controller: makePedidosController(),
      canaisVendaGateway: makeCanaisVendaGateway(),
    );
