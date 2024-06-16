import 'package:app/application/controllers/separadores_controller.dart';
import 'package:app/main/factories/http_client_factory.dart';
import 'package:app/pages/separadores/separadores.dart';
import 'package:app/main/config.dart' as Config;

SeparadoresController makeController() => SeparadoresController(
      httpClient: makeHttpClient(),
      baseUrl: Config.baseUrl,
    );

Separadores makeSeparadoresPage() => Separadores(controller: makeController());
