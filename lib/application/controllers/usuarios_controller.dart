import 'package:app/infra/http/http_client.dart';
import 'package:app/pages/separadores/separador_view_model.dart';
import 'package:app/pages/usuarios/usuario_view_model.dart';
import 'package:get/get.dart';

class UsuariosController extends GetxController {
  final HttpClient httpClient;
  final String baseUrl;
  final _usuarios = Rx<List<UsuarioViewModel>>([]);
  Stream<List<UsuarioViewModel>> get usuariosStream => _usuarios.stream;
  final _separadores = Rx<List<SeparadorViewModel>>([]);
  Stream<List<SeparadorViewModel>> get separadoresStream => _separadores.stream;

  UsuariosController({required this.httpClient, required this.baseUrl});

  Future<void> loadUsuarios() async {
    List<UsuarioViewModel> usuarios = [];
    final url = "$baseUrl/usuarios";
    final response = await httpClient.request(url: url, method: 'get');
    final separadores = await loadSeparadores();
    for (final usuarioData in response) {
      final usuario = UsuarioViewModel.fromJson(usuarioData);
      final separador = separadores.where((separador) => separador.id == usuario.separadorId);
      if (separador.isNotEmpty) usuario.separador = separador.first;
      usuarios.add(usuario);
    }
    _usuarios.value = usuarios;
  }

  Future<void> criarUsuario(UsuarioViewModel usuario) async {
    final url = "$baseUrl/usuarios";
    Map body = usuario.toJson();
    body.remove('id');
    await httpClient.request(url: url, method: 'post', body: body);
    loadUsuarios();
  }

  Future<void> deletarUsuario(UsuarioViewModel usuario) async {
    final url = "$baseUrl/usuarios/${usuario.id}";
    await httpClient.request(url: url, method: 'delete');
    loadUsuarios();
  }

  Future<void> atualizarUsuario(UsuarioViewModel usuario) async {
    final url = "$baseUrl/usuarios/${usuario.id}";
    Map body = usuario.toJson();
    body.remove('id');
    body.remove('login');
    if (body['senha'] == null) body.remove('senha');
    await httpClient.request(url: url, method: 'post', body: body);
    loadUsuarios();
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

  // Future<void> criarSeparador(String nome, String documento) async {
  //   final url = "$baseUrl/separadores";
  //   Map body = {"nome": nome, "cpf": documento};
  //   await httpClient.request(url: url, method: 'post', body: body);
  //   loadSeparadores();
  // }

  // Future<void> deletarSeparador(SeparadorViewModel separador) async {
  //   final url = "$baseUrl/separadores/${separador.id}";
  //   await httpClient.request(url: url, method: 'delete');
  //   loadSeparadores();
  // }

  // Future<void> editarSeparador(SeparadorViewModel separador) async {
  //   final url = "$baseUrl/separadores/${separador.id}";
  //   Map body = {"nome": separador.nome, "cpf": separador.cpf};
  //   await httpClient.request(url: url, method: 'post', body: body);
  //   loadSeparadores();
  // }
}
