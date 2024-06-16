import 'package:app/application/controllers/usuarios_controller.dart';
import 'package:app/main/factories/http_client_factory.dart';
import 'package:app/main/config.dart' as Config;
import 'package:app/pages/usuarios/usuarios.dart';

UsuariosController makeController() => UsuariosController(
      httpClient: makeHttpClient(),
      baseUrl: Config.baseUrl,
    );

Usuarios makeUsuariosPage() => Usuarios(controller: makeController());
