import 'package:app/application/controllers/canais_venda_controller.dart';
import 'package:app/application/token_manager.dart';
import 'package:app/pages/canais_venda/canal_venda_viewmodel.dart';
import 'package:app/pages/components/breadcrumb.dart';
import 'package:app/pages/mixins/ui_error_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CanaisVenda extends StatefulWidget with UIErrorManager {
  final CanaisVendaController controller;
  CanaisVenda({Key? key, required this.controller}) : super(key: key);

  @override
  _CanaisVenda createState() => _CanaisVenda();
}

final List<String> prioridades = ['Baixa', 'Média', 'Alta'];

class _CanaisVenda extends State<CanaisVenda> {
  String prioridadeValue = prioridades.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(builder: (context) {
        widget.controller.loadCanaisVenda();
        widget.handleMainError(context, widget.controller.uiErrorStream);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Breadcrumb(title: 'Canais de Venda', breadcrumb: 'Canais de Venda > Visualizar'),
            Padding(padding: EdgeInsets.only(bottom: 25)),
            Container(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: StreamBuilder<List<CanalVendaViewModel>>(
                    stream: widget.controller.canaisStream,
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
      }),
    );
  }

  List<DataColumn> _createColumns() {
    return const [
      DataColumn(
          label: Text(
            'Nome do canal',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          tooltip: 'Book identifier'),
      DataColumn(
        label: Text(
          'Prioridade',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      DataColumn(
        label: Text(
          '',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }

  List<DataRow> _createRows(List<CanalVendaViewModel>? canais) {
    if (canais == null) return [];
    return canais
        .map<DataRow>(
          (canal) => DataRow(
            cells: <DataCell>[
              // DataCell(Text('cbdd50dd-8541-4569-b70a-96e8d73a4731')),
              DataCell(
                Text(canal.nome),
              ),
              DataCell(
                Text(canal.prioridade),
              ),
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _deleteDialog(canal);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _editarDialog(canal);
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

  Future<void> _deleteDialog(CanalVendaViewModel canal) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletar canal?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  canal.nome,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Você gostaria de deletar este canal?'),
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
                widget.controller.deletarCanal(canal);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _createDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        String nome = '';
        return AlertDialog(
          title: const Text('Criar um novo canal'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome do canal'),
                  onChanged: (value) {
                    nome = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'Prioridade',
                    ),
                    value: prioridadeValue,
                    items: prioridades.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        prioridadeValue = value!;
                      });
                    },
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
                widget.controller.criarCanal(nome, prioridadeValue);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editarDialog(CanalVendaViewModel canal) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        String nome = canal.nome;
        prioridadeValue = canal.prioridade;
        return AlertDialog(
          title: const Text('Editar canal'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  initialValue: nome,
                  decoration: InputDecoration(labelText: 'Nome do canal'),
                  onChanged: (value) {
                    nome = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'Prioridade',
                    ),
                    value: prioridadeValue,
                    items: prioridades.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        prioridadeValue = value!;
                      });
                    },
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
                canal.nome = nome;
                canal.prioridade = prioridadeValue;
                widget.controller.editarCanal(canal);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
