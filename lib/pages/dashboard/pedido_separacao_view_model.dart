import 'package:app/pages/dashboard/separacao_view_model.dart';
import 'package:app/pages/pedidos/pedido_view_model.dart';
import 'package:app/pages/separadores/separador_view_model.dart';

class PedidoSeparacaoViewModel {
  PedidoViewModel pedido;
  SeparacaoViewModel separacao;
  SeparadorViewModel separador;

  PedidoSeparacaoViewModel({
    required this.pedido,
    required this.separacao,
    required this.separador,
  });
}
