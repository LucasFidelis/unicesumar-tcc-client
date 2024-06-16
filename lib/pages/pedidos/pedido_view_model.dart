import 'dart:js_interop';

import 'package:app/pages/canais_venda/canal_venda_viewmodel.dart';

class PedidoViewModel {
  String? id;
  String identificadorLoja;
  String nomeCliente;
  String emissao;
  CanalVendaViewModel canalVenda;
  List<Produto> produtos = [];

  PedidoViewModel({
    this.id,
    required this.identificadorLoja,
    required this.nomeCliente,
    required this.emissao,
    required this.canalVenda,
  });

  factory PedidoViewModel.fromJson(Map data) {
    final pedido = PedidoViewModel(
      id: data['id'],
      identificadorLoja: data['identificadorLoja'],
      nomeCliente: data['nomeCliente'],
      emissao: data['emissao'],
      canalVenda: CanalVendaViewModel.fromJson(data['canalVenda']),
    );
    pedido.produtos = data['produtos']
        .map<Produto>(
          (produtoData) => Produto.fromJson(produtoData),
        )
        .toList();
    return pedido;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "identificadorLoja": identificadorLoja,
      "nomeCliente": nomeCliente,
      "emissao": emissao,
      "canalVendaId": canalVenda.id,
      "produtos": produtos.map((produto) => produto.toJson()).toList(),
    };
  }
}

class Produto {
  String nome;
  int quantidade;

  Produto({required this.nome, required this.quantidade});

  factory Produto.fromJson(Map data) {
    return Produto(
      nome: data['nome'],
      quantidade: data['quantidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nome": nome,
      "quantidade": quantidade,
    };
  }
}
