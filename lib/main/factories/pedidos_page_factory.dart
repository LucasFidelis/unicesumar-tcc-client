import 'package:app/application/controllers/pedidos_controller.dart';
import 'package:app/main/factories/http_client_factory.dart';
import 'package:app/main/config.dart' as Config;
import 'package:app/pages/pedidos/pedidos.dart';

PedidosController makePedidosController() => PedidosController(
      httpClient: makeHttpClient(),
      baseUrl: Config.baseUrl,
    );

Pedidos makePedidosPage() => Pedidos(controller: makePedidosController());
