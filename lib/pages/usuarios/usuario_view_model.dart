import 'package:app/pages/separadores/separador_view_model.dart';

class UsuarioViewModel {
  String? id;
  String login;
  String funcao;
  String? separadorId;
  String? senha;
  SeparadorViewModel? separador;

  UsuarioViewModel({
    this.id,
    required this.login,
    required this.funcao,
    this.separadorId,
  });

  factory UsuarioViewModel.fromJson(Map data) {
    return UsuarioViewModel(
      id: data['id'],
      login: data['login'],
      funcao: data['funcao'],
      separadorId: data['separadorId'],
    );
  }

  Map toJson() {
    return {
      'id': id,
      'login': login,
      'funcao': funcao,
      'senha': senha,
      'separadorId': separadorId,
    };
  }
}
