import 'package:app/application/controllers/pedidos_controller.dart';
import 'package:app/application/gateways/canais_venda_gateway.dart';
import 'package:app/pages/canais_venda/canal_venda_viewmodel.dart';
import 'package:app/pages/components/breadcrumb.dart';
import 'package:app/pages/components/text_data_column.dart';
import 'package:app/pages/pedidos/pedido_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class EditarPedido extends StatefulWidget {
  final CanaisVendaGateway canaisVendaGateway;
  final PedidosController controller;

  EditarPedido({super.key, required this.controller, required this.canaisVendaGateway});

  @override
  State<EditarPedido> createState() => _EditarPedido();
}

class _EditarPedido extends State<EditarPedido> {
  final identificadorController = TextEditingController();
  final nomeClienteController = TextEditingController();
  final emissaoController = TextEditingController();
  Map<Key, Widget> produtos = {};
  Map<Key, List<TextEditingController>> produtosControllers = {};
  List<CanalVendaViewModel> canaisVenda = [];
  String canalValue = '';
  Future<PedidoViewModel>? _future;
  late PedidoViewModel pedido;

  @override
  void initState() {
    super.initState();
    widget.canaisVendaGateway.list().then(
          (value) => setState(
            () {
              canaisVenda = value;
              canalValue = canaisVenda.first.nome;
            },
          ),
        );
    _future = loadPedido();
  }

  Key criarLinhaProduto() {
    const uuid = Uuid();
    final keyValue = uuid.v4();
    final key = ValueKey(keyValue);
    final nomeProdutoController = TextEditingController();
    final quantidadeProdutoController = TextEditingController();
    List<TextEditingController> controllers = [nomeProdutoController, quantidadeProdutoController];
    produtosControllers[key] = controllers;
    produtos[key] = LinhaProduto(key, controllers);
    return key;
  }

  Future<PedidoViewModel> loadPedido() async {
    final pedidoId = Get.parameters['id'];
    if (pedidoId == null) {
      return await Get.toNamed('/dashboard');
    }
    pedido = await widget.controller.loadPedido(pedidoId);
    identificadorController.text = pedido.identificadorLoja;
    nomeClienteController.text = pedido.nomeCliente;
    emissaoController.text = pedido.emissao;
    canalValue = pedido.canalVenda.nome;
    for (var item in pedido.produtos) {
      final key = criarLinhaProduto();
      produtosControllers[key]![0].text = item.nome;
      produtosControllers[key]![1].text = item.quantidade.toString();
    }
    return pedido;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.toNamed('/dashboard'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pedido.identificadorLoja = identificadorController.text;
          pedido.nomeCliente = nomeClienteController.text;
          pedido.emissao = emissaoController.text;
          pedido.canalVenda = canaisVenda.firstWhere((canal) => canal.nome == canalValue);
          pedido.produtos.clear();
          final keys = produtos.keys.toList();
          for (final key in keys) {
            final nomeProduto = produtosControllers[key]![0].text;
            final quantidadeProduto = int.parse(produtosControllers[key]![1].text);
            if (nomeProduto.isNotEmpty && quantidadeProduto > 0) {
              final produto = Produto(nome: nomeProduto, quantidade: quantidadeProduto);
              pedido.produtos.add(produto);
            }
          }
          widget.controller.editarPedido(pedido);
        },
        child: const Icon(Icons.save_outlined),
      ),
      body: FutureBuilder<PedidoViewModel>(
          future: _future,
          builder: (content, snapshot) {
            return Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Breadcrumb(title: 'Pedidos', breadcrumb: 'Pedidos > Editar Pedido'),
                  const Padding(padding: EdgeInsets.only(bottom: 25)),
                  SizedBox(
                    width: double.infinity,
                    child: Form(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 15, left: 8.0),
                              child: Text(
                                'Dados Gerais',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: 300),
                                    child: TextFormField(
                                      onChanged: (value) => pedido.identificadorLoja = value,
                                      controller: identificadorController,
                                      decoration: InputDecoration(labelText: 'Identificador da Loja'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: 300),
                                    child: TextFormField(
                                      onChanged: (value) => pedido.nomeCliente = value,
                                      controller: nomeClienteController,
                                      decoration: InputDecoration(labelText: 'Nome do Cliente'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: 300),
                                    child: TextField(
                                      controller: emissaoController,
                                      onChanged: (value) => pedido.emissao = value,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.calendar_today), //icon of text field
                                          labelText: "Emissão do Pedido" //label text of field
                                          ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(2100),
                                        );
                                        if (pickedDate != null) {
                                          String formattedDate = DateFormat('yyyy-MM-ddT00:00:00').format(pickedDate);
                                          setState(() {
                                            emissaoController.text = formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: 300),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Canal de Venda',
                                      ),
                                      value: canalValue,
                                      items: canaisVenda.map<DropdownMenuItem<String>>((CanalVendaViewModel canalVenda) {
                                        return DropdownMenuItem<String>(
                                          value: canalVenda.nome,
                                          child: Text(canalVenda.nome),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        pedido.canalVenda = canaisVenda.firstWhere((canal) => canal.nome == canalValue);
                                        setState(() {
                                          canalValue = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 15, left: 8.0),
                              child: Text(
                                'Produtos',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: produtos.keys.toList().length,
                              itemBuilder: (context, index) {
                                final keys = produtos.keys.toList();
                                return produtos[keys[index]];
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 25.0, bottom: 50),
                              child: SizedBox(
                                width: 360,
                                height: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightBlue[100],
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      criarLinhaProduto();
                                    });
                                  },
                                  child: const Text('Adicionar Produto'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget LinhaProduto(Key key, List<TextEditingController> controllers) {
    return Row(
      children: [
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: BoxConstraints(maxWidth: 300),
                child: TextFormField(
                  controller: controllers[0],
                  decoration: InputDecoration(labelText: 'Nome do Produto'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: BoxConstraints(maxWidth: 300),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: controllers[1],
                  decoration: InputDecoration(labelText: 'Quantidade'),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  produtos.removeWhere((linhaKey, value) => linhaKey == key);
                  produtosControllers.removeWhere((linhaKey, value) => linhaKey == key);
                });
              },
              icon: const Icon(
                Icons.delete_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
