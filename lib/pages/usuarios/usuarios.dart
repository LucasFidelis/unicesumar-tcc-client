import 'package:app/application/controllers/usuarios_controller.dart';
import 'package:app/pages/components/breadcrumb.dart';
import 'package:app/pages/components/text_data_column.dart';
import 'package:app/pages/separadores/separador_view_model.dart';
import 'package:app/pages/usuarios/usuario_view_model.dart';
import 'package:flutter/material.dart';

class Usuarios extends StatefulWidget {
  final UsuariosController controller;

  Usuarios({super.key, required this.controller});

  @override
  State<Usuarios> createState() => _Usuarios();
}

final Map<String, String> funcoes = {
  'separador': 'Separador',
  'administrador': 'Administrador',
};

class _Usuarios extends State<Usuarios> {
  String funcao = 'separador';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (BuildContext context) {
          widget.controller.loadUsuarios();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Breadcrumb(title: 'Usuários', breadcrumb: 'Usuários > Visualizar'),
              const Padding(padding: EdgeInsets.only(bottom: 25)),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: StreamBuilder<List<UsuarioViewModel>>(
                      stream: widget.controller.usuariosStream,
                      builder: (context, snapshot) {
                        return DataTable(
                          columns: _createColumns(),
                          rows: _createRows(snapshot.data),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return const [
      DataColumn(
        label: TextDataColumn(
          text: 'Login',
        ),
        tooltip: 'Login do usuário',
      ),
      DataColumn(
        label: TextDataColumn(
          text: 'Função',
        ),
        tooltip: 'Função do usuário',
      ),
      DataColumn(
        label: TextDataColumn(
          text: 'Separador',
        ),
        tooltip: 'Separador',
      ),
      DataColumn(
        label: TextDataColumn(
          text: '',
        ),
        tooltip: 'Ações',
      ),
    ];
  }

  List<DataRow> _createRows(List<UsuarioViewModel>? usuarios) {
    if (usuarios == null) return [];
    return usuarios
        .map<DataRow>(
          (usuario) => DataRow(
            cells: <DataCell>[
              DataCell(
                Text(usuario.login),
              ),
              DataCell(
                Text(funcoes[usuario.funcao]!),
              ),
              DataCell(
                Text(usuario.separador?.nome ?? ''),
              ),
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _deleteDialog(usuario);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _editarDialog(usuario);
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  Future<void> _createDialog() async {
    final loginController = TextEditingController();
    final senhaController = TextEditingController();
    SeparadorViewModel? separador;
    List<SeparadorViewModel> separadores;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          widget.controller.loadSeparadores();
          return AlertDialog(
            title: const Text('Novo Usuário'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: loginController,
                    decoration: const InputDecoration(labelText: 'Login'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: senhaController,
                      decoration: InputDecoration(labelText: 'Senha'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Função',
                      ),
                      value: funcao,
                      items: funcoes.keys.toList().map<DropdownMenuItem<String>>((String key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text(funcoes[key]!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          funcao = value!;
                        });
                      },
                    ),
                  ),
                  StreamBuilder<List<SeparadorViewModel>>(
                      stream: widget.controller.separadoresStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) return const CircularProgressIndicator();
                        separadores = snapshot.data ?? [];
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: 'Separador',
                            ),
                            value: separador?.id,
                            items: snapshot.data?.map<DropdownMenuItem<String>>((SeparadorViewModel value) {
                              return DropdownMenuItem<String>(
                                value: value.id,
                                child: Text(value.nome),
                              );
                            }).toList(),
                            onChanged: (value) {
                              final filter = separadores.where((data) => data.id == value).first;
                              separador = filter;
                            },
                          ),
                        );
                      }),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Criar'),
                onPressed: () {
                  final usuario = UsuarioViewModel(login: loginController.text, funcao: funcao);
                  usuario.senha = senhaController.text;
                  usuario.separadorId = separador?.id;
                  widget.controller.criarUsuario(usuario);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _editarDialog(UsuarioViewModel usuario) async {
    final loginController = TextEditingController(text: usuario.login);
    final senhaController = TextEditingController();
    funcao = usuario.funcao;
    SeparadorViewModel? separador = usuario.separador;
    List<SeparadorViewModel> separadores;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          widget.controller.loadSeparadores();
          return AlertDialog(
            title: const Text('Novo Usuário'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: loginController,
                    decoration: const InputDecoration(labelText: 'Login'),
                    enabled: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: senhaController,
                      decoration: InputDecoration(labelText: 'Senha'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Função',
                      ),
                      value: funcao,
                      items: funcoes.keys.toList().map<DropdownMenuItem<String>>((String key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text(funcoes[key]!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          funcao = value!;
                        });
                      },
                    ),
                  ),
                  StreamBuilder<List<SeparadorViewModel>>(
                      stream: widget.controller.separadoresStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) return const CircularProgressIndicator();
                        separadores = snapshot.data ?? [];
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: 'Separador',
                            ),
                            value: separador?.id,
                            items: snapshot.data?.map<DropdownMenuItem<String>>((SeparadorViewModel value) {
                              return DropdownMenuItem<String>(
                                value: value.id,
                                child: Text(value.nome),
                              );
                            }).toList(),
                            onChanged: (value) {
                              final filter = separadores.where((data) => data.id == value).first;
                              separador = filter;
                            },
                          ),
                        );
                      }),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Editar'),
                onPressed: () {
                  usuario.login = loginController.text;
                  usuario.senha = senhaController.text == '' ? null : senhaController.text;
                  usuario.funcao = funcao;
                  usuario.separadorId = separador?.id;
                  widget.controller.atualizarUsuario(usuario);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _deleteDialog(UsuarioViewModel usuario) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletar usuário?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  usuario.login,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Você gostaria de deletar este usuário?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Deletar'),
              onPressed: () {
                Navigator.of(context).pop();
                widget.controller.deletarUsuario(usuario);
              },
            ),
          ],
        );
      },
    );
  }
}
