import 'package:app/application/controllers/canais_venda_controller.dart';
import 'package:app/main/factories/http_client_factory.dart';
import 'package:app/pages/canais_venda.dart';
import 'package:app/main/config.dart' as Config;

CanaisVendaController makeCanaisVendaController() => CanaisVendaController(
      httpClient: makeHttpClient(),
      baseUrl: Config.baseUrl,
    );
CanaisVenda makePageCanaisVenda() => CanaisVenda(controller: makeCanaisVendaController());
