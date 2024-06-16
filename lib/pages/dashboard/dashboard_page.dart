import 'package:app/application/controllers/dashboard_controller.dart';
import 'package:app/pages/components/breadcrumb.dart';
import 'package:app/pages/dashboard/pedido_separacao_view_model.dart';
import 'package:app/pages/dashboard/tabela_prioridade_columns.dart';
import 'package:app/pages/dashboard/tabela_separacao_columns.dart';
import 'package:app/pages/mixins/ui_error_manager.dart';
import 'package:app/pages/pedidos/pedido_view_model.dart';
import 'package:app/pages/separadores/separador_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

class DashboardPage extends StatefulWidget with UIErrorManager {
  final DashboardController controller;
  DashboardPage({Key? key, required this.controller}) : super(key: key);

  @override
  _DashboardPage createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.controller.loadPedidos();
        widget.controller.loadSeparacoes();
        widget.handleMainError(context, widget.controller.uiErrorStream);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Breadcrumb(title: 'Dashboard', breadcrumb: 'Separação de Pedidos'),
            Padding(padding: EdgeInsets.only(bottom: 25)),
            Container(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StreamBuilder<List<PedidoViewModel>>(
                            stream: widget.controller.pedidosAltaPrioridadeStream,
                            builder: (context, snapshot) {
                              return TabButton(0, 'Alta Prioridade - ${snapshot.data?.length.toString() ?? 0}');
                            },
                          ),
                          StreamBuilder<List<PedidoViewModel>>(
                            stream: widget.controller.pedidosMediaPrioridade,
                            builder: (context, snapshot) {
                              return TabButton(1, 'Média Prioridade - ${snapshot.data?.length.toString() ?? 0}');
                            },
                          ),
                          StreamBuilder<List<PedidoViewModel>>(
                            stream: widget.controller.pedidosBaixaPrioridade,
                            builder: (context, snapshot) {
                              return TabButton(2, 'Baixa Prioridade - ${snapshot.data?.length.toString() ?? 0}');
                            },
                          ),
                          StreamBuilder<List<PedidoSeparacaoViewModel>>(
                            stream: widget.controller.pedidosEmSeparacao,
                            builder: (context, snapshot) {
                              return TabButton(3, 'Em Separação - ${snapshot.data?.length.toString() ?? 0}');
                            },
                          ),
                          StreamBuilder<List<PedidoSeparacaoViewModel>>(
                            stream: widget.controller.pedidosSeparados,
                            builder: (context, snapshot) {
                              return TabButton(4, 'Separados - ${snapshot.data?.length.toString() ?? 0}');
                            },
                          ),
                        ],
                      ),
                      BuildContent(),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
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
              // DataCell(Text('cbdd50dd-8541-4569-b70a-96e8d73a4731')),
              DataCell(
                Text(pedido.identificadorLoja),
              ),
              DataCell(
                Text(pedido.nomeCliente),
              ),
              DataCell(
                Text(pedido.canalVenda.nome),
              ),
              DataCell(
                Text(pedido.produtos.length.toString()),
              ),
              DataCell(
                Text(dateFormat(pedido.emissao)),
              ),
              DataCell(
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Iniciar Separação'),
                      onTap: () {
                        iniciarSeparacao(pedido);
                      },
                    ),
                    PopupMenuItem(
                      child: Text('Imprimir Pedido'),
                      onTap: () {
                        html.window.open(widget.controller.imprimirPedidoURL(pedido), 'Imprimir pedido');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  Future<void> iniciarSeparacao(PedidoViewModel pedido) async {
    SeparadorViewModel? separador;
    List<SeparadorViewModel> separadores;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Builder(
          builder: (context) {
            widget.controller.loadSeparadores();
            return AlertDialog(
              title: const Text('Iniciar Separação'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    StreamBuilder<List<SeparadorViewModel>>(
                        stream: widget.controller.separadoresStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) return const CircularProgressIndicator();
                          separadores = snapshot.data ?? [];
                          separador = separadores.first;
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
                    if (separador != null) {
                      widget.controller.iniciarSeparacao(pedido, separador!);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<DataRow> _createRowsSeparacao(List<PedidoSeparacaoViewModel>? separacoes) {
    if (separacoes == null) return [];
    return separacoes
        .map<DataRow>(
          (separacao) => DataRow(
            cells: <DataCell>[
              // DataCell(Text('cbdd50dd-8541-4569-b70a-96e8d73a4731')),
              DataCell(
                Text(separacao.pedido.identificadorLoja),
              ),
              DataCell(
                Text(separacao.pedido.nomeCliente),
              ),
              DataCell(
                Text(separacao.pedido.canalVenda.nome),
              ),
              DataCell(
                Text(separacao.pedido.produtos.length.toString()),
              ),
              DataCell(
                Text(dateFormat(separacao.pedido.emissao)),
              ),
              DataCell(
                Text(separacao.separador.nome),
              ),
              DataCell(
                PopupMenuButton(
                  itemBuilder: (context) => buildPopupMenuItems(separacao),
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  List<PopupMenuEntry<dynamic>> buildPopupMenuItems(PedidoSeparacaoViewModel pedidoSeparacao) {
    List<PopupMenuEntry<dynamic>> menuItems = [];
    switch (pedidoSeparacao.separacao.status) {
      case 'iniciado':
        menuItems.add(
          PopupMenuItem(
            child: Text('Finalizar Separação'),
            onTap: () {
              widget.controller.finalizarSeparacao(pedidoSeparacao);
            },
          ),
        );
        menuItems.add(
          PopupMenuItem(
            child: Text('Retornar Separação'),
            onTap: () {
              widget.controller.retornarSeparacao(pedidoSeparacao);
            },
          ),
        );
    }
    menuItems.add(
      PopupMenuItem(
        child: Text('Imprimir Pedido'),
        onTap: () {
          html.window.open(widget.controller.imprimirPedidoURL(pedidoSeparacao.pedido), 'Imprimir pedido');
        },
      ),
    );
    return menuItems;
  }

  Widget TabButton(int contentIndex, String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          index = contentIndex;
        });
      },
      style: contentIndex == index
          ? ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[200],
            )
          : Theme.of(context).elevatedButtonTheme.style,
      child: Text(label),
    );
  }

  Widget BuildContent() {
    switch (index) {
      case 0:
        return StreamBuilder<List<PedidoViewModel>>(
          stream: widget.controller.pedidosAltaPrioridadeStream,
          builder: (context, snapshot) {
            return DataTable(
              columns: tabelaPrioridadeColumns,
              rows: _createRows(snapshot.data),
            );
          },
        );
      case 1:
        return StreamBuilder<List<PedidoViewModel>>(
          stream: widget.controller.pedidosMediaPrioridade,
          builder: (context, snapshot) {
            return DataTable(
              columns: tabelaPrioridadeColumns,
              rows: _createRows(snapshot.data),
            );
          },
        );
      case 2:
        return StreamBuilder<List<PedidoViewModel>>(
          stream: widget.controller.pedidosBaixaPrioridade,
          builder: (context, snapshot) {
            return DataTable(
              columns: tabelaPrioridadeColumns,
              rows: _createRows(snapshot.data),
            );
          },
        );
      case 3:
        return StreamBuilder<List<PedidoSeparacaoViewModel>>(
          stream: widget.controller.pedidosEmSeparacao,
          builder: (context, snapshot) {
            return DataTable(
              columns: tabelaSeparacaoColumns,
              rows: _createRowsSeparacao(snapshot.data),
            );
          },
        );
      case 4:
        return StreamBuilder<List<PedidoSeparacaoViewModel>>(
          stream: widget.controller.pedidosSeparados,
          builder: (context, snapshot) {
            return DataTable(
              columns: tabelaSeparacaoColumns,
              rows: _createRowsSeparacao(snapshot.data),
            );
          },
        );
    }
    return Text(index.toString());
  }
}
