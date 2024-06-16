import 'package:app/application/controllers/separadores_controller.dart';
import 'package:app/pages/components/breadcrumb.dart';
import 'package:app/pages/components/text_data_column.dart';
import 'package:app/pages/mixins/ui_error_manager.dart';
import 'package:app/pages/separadores/separador_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Separadores extends StatefulWidget with UIErrorManager {
  final SeparadoresController controller;

  const Separadores({super.key, required this.controller});

  @override
  State<Separadores> createState() => _SeparadoresState();
}

class _SeparadoresState extends State<Separadores> {
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
          widget.handleMainError(context, widget.controller.uiErrorStream);
          widget.controller.loadSeparadores();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Breadcrumb(title: 'Separadores', breadcrumb: 'Separadores > Visualizar'),
              const Padding(padding: EdgeInsets.only(bottom: 25)),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: StreamBuilder<List<SeparadorViewModel>>(
                      stream: widget.controller.separadoresStream,
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
          text: 'Nome',
        ),
        tooltip: 'Nome do separador',
      ),
      DataColumn(
        label: TextDataColumn(
          text: 'Documento (CPF)',
        ),
        tooltip: 'CPF do separador',
      ),
      DataColumn(
        label: TextDataColumn(
          text: '',
        ),
        tooltip: 'Ações',
      ),
    ];
  }

  List<DataRow> _createRows(List<SeparadorViewModel>? separadores) {
    if (separadores == null) return [];
    return separadores
        .map<DataRow>(
          (separador) => DataRow(
            cells: <DataCell>[
              // DataCell(Text('cbdd50dd-8541-4569-b70a-96e8d73a4731')),
              DataCell(
                Text(separador.nome),
              ),
              DataCell(
                Text(separador.cpf),
              ),
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _deleteDialog(separador);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _editarDialog(separador);
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
    final nomeSeparadorController = TextEditingController();
    final cpfSeparadorController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Novo Separador'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: nomeSeparadorController,
                  decoration: const InputDecoration(labelText: 'Nome do separador'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                  child: TextFormField(
                    controller: cpfSeparadorController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(labelText: 'CPF do separador'),
                  ),
                ),
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
                widget.controller.criarSeparador(
                  nomeSeparadorController.text,
                  cpfSeparadorController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDialog(SeparadorViewModel separador) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletar separador?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  separador.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Você gostaria de deletar este separador?'),
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
                widget.controller.deletarSeparador(separador);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editarDialog(SeparadorViewModel separador) async {
    final nomeSeparadorController = TextEditingController(text: separador.nome);
    final cpfSeparadorController = TextEditingController(text: separador.cpf);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar separador'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome do separador'),
                  controller: nomeSeparadorController,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                  child: TextFormField(
                    controller: cpfSeparadorController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(labelText: 'CPF do separador'),
                  ),
                ),
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
                separador.nome = nomeSeparadorController.text;
                separador.cpf = cpfSeparadorController.text;
                widget.controller.editarSeparador(separador);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
