import 'package:app/application/controllers/pedidos_controller.dart';
import 'package:app/pages/components/breadcrumb.dart';
import 'package:app/pages/components/text_data_column.dart';
import 'package:app/pages/mixins/ui_error_manager.dart';
import 'package:app/pages/pedidos/pedido_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Pedidos extends StatefulWidget with UIErrorManager {
  final PedidosController controller;

  Pedidos({super.key, required this.controller});

  @override
  State<Pedidos> createState() => _Pedidos();
}

class _Pedidos extends State<Pedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/pedido/novo');
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (BuildContext context) {
          widget.controller.loadPedidos();
          widget.handleMainError(context, widget.controller.uiErrorStream);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Breadcrumb(title: 'Pedidos', breadcrumb: 'Pedidos > Visualizar'),
              const Padding(padding: EdgeInsets.only(bottom: 25)),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: StreamBuilder<List<PedidoViewModel>>(
                      stream: widget.controller.pedidosStream,
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
          text: 'ID. Loja',
        ),
        tooltip: 'Identificador do pedido',
      ),
      DataColumn(
        label: TextDataColumn(
          text: 'Cliente',
        ),
        tooltip: 'Nome do cliente',
      ),
      DataColumn(
        label: TextDataColumn(
          text: 'Emissão',
        ),
        tooltip: 'Data de emissão do pedido',
      ),
      DataColumn(
        label: TextDataColumn(
          text: 'Canal de Venda',
        ),
        tooltip: 'Canal de Venda',
      ),
      DataColumn(
        label: TextDataColumn(
          text: 'Qtd. Produtos',
        ),
        tooltip: 'Quantidade de produtos',
      ),
      DataColumn(
        label: TextDataColumn(
          text: '',
        ),
        tooltip: 'Ações',
      ),
    ];
  }

  String dateFormat(String emissao) {
    final formatter = new DateFormat('dd/MM/yyyy');
    final date = DateTime.parse(emissao);
    return formatter.format(date);
  }

  List<DataRow> _createRows(List<PedidoViewModel>? pedidos) {
    if (pedidos == null) return [];
    return pedidos
        .map<DataRow>(
          (pedido) => DataRow(
            cells: <DataCell>[
              DataCell(
                Text(pedido.identificadorLoja),
              ),
              DataCell(
                Text(pedido.nomeCliente),
              ),
              DataCell(
                Text(dateFormat(pedido.emissao)),
              ),
              DataCell(
                Text(pedido.canalVenda.nome),
              ),
              DataCell(
                Text(pedido.produtos.length.toString()),
              ),
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _deleteDialog(pedido);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.toNamed("/pedido/editar/${pedido.id}");
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

  Future<void> _deleteDialog(PedidoViewModel pedido) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletar pedido?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  pedido.identificadorLoja,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Você gostaria de deletar este pedido?'),
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
                widget.controller.deletarPedido(pedido);
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> _editarDialog(SeparadorViewModel separador) async {
  //   final nomeSeparadorController = TextEditingController(text: separador.nome);
  //   final cpfSeparadorController = TextEditingController(text: separador.cpf);
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Editar canal'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               TextFormField(
  //                 decoration: InputDecoration(labelText: 'Nome do separador'),
  //                 controller: nomeSeparadorController,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 10.0, bottom: 20),
  //                 child: TextFormField(
  //                   controller: cpfSeparadorController,
  //                   decoration: InputDecoration(labelText: 'CPF do separador'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Cancelar'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Editar'),
  //             onPressed: () {
  //               separador.nome = nomeSeparadorController.text;
  //               separador.cpf = cpfSeparadorController.text;
  //               widget.controller.editarSeparador(separador);
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
