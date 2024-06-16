import 'package:app/application/controllers/pedidos_controller.dart';
import 'package:app/application/gateways/canais_venda_gateway.dart';
import 'package:app/pages/canais_venda/canal_venda_viewmodel.dart';
import 'package:app/pages/components/breadcrumb.dart';
import 'package:app/pages/components/text_data_column.dart';
import 'package:app/pages/pedidos/pedido_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CriarPedido extends StatefulWidget {
  final CanaisVendaGateway canaisVendaGateway;
  final PedidosController controller;

  CriarPedido({super.key, required this.controller, required this.canaisVendaGateway});

  @override
  State<CriarPedido> createState() => _CriarPedido();
}

class _CriarPedido extends State<CriarPedido> {
  final identificadorController = TextEditingController();
  final nomeClienteController = TextEditingController();
  final emissaoController = TextEditingController();
  List<TextEditingController> nomesController = [];
  List<TextEditingController> quantidadesController = [];
  List<Widget> produtos = [];
  List<CanalVendaViewModel> canaisVenda = [];
  String canalValue = '';

  void initState() {
    super.initState();
    produtos.add(LinhaProduto());
    widget.canaisVendaGateway.list().then(
          (value) => setState(
            () {
              canaisVenda = value;
              canalValue = canaisVenda.first.nome;
            },
          ),
        );
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
          final pedido = PedidoViewModel(
            identificadorLoja: identificadorController.text,
            nomeCliente: nomeClienteController.text,
            emissao: emissaoController.text,
            canalVenda: canaisVenda.firstWhere((canal) => canal.nome == canalValue),
          );
          for (var index = 0; index < nomesController.length; index++) {
            final nomeProduto = nomesController[index].text;
            final quantidadeProduto = int.parse(quantidadesController[index].text);
            if (nomeProduto.isNotEmpty && quantidadeProduto > 0) {
              final produto = Produto(nome: nomeProduto, quantidade: quantidadeProduto);
              pedido.produtos.add(produto);
            }
          }
          widget.controller.criarPedido(pedido);
        },
        child: const Icon(Icons.save_outlined),
      ),
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Breadcrumb(title: 'Pedidos', breadcrumb: 'Pedidos > Criar Pedido'),
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
                                  //editing controller of this TextField
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.calendar_today), //icon of text field
                                      labelText: "Emissão do Pedido" //label text of field
                                      ),
                                  readOnly: true,
                                  //set it true, so that user will not able to edit text
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
                                        emissaoController.text = formattedDate; //set output date to TextField value.
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
                          itemCount: produtos.length,
                          itemBuilder: (context, index) {
                            return produtos[index];
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
                                  produtos.add(LinhaProduto());
                                });
                              },
                              child: const Text('Adicionar Produto'),
                            ),
                          ),
                        ),
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

  Widget LinhaProduto() {
    final nomeTextInput = TextEditingController();
    final quantidadeTextInput = TextEditingController();
    nomesController.add(nomeTextInput);
    quantidadesController.add(quantidadeTextInput);
    return Row(
      children: [
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: BoxConstraints(maxWidth: 300),
                child: TextFormField(
                  controller: nomeTextInput,
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
                  controller: quantidadeTextInput,
                  decoration: InputDecoration(labelText: 'Quantidade'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
