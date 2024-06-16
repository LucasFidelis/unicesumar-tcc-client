class SeparacaoViewModel {
  String? id;
  String pedidoId;
  String separadorId;
  String status;

  SeparacaoViewModel({
    this.id,
    required this.pedidoId,
    required this.separadorId,
    required this.status,
  });

  factory SeparacaoViewModel.fromJson(Map data) {
    return SeparacaoViewModel(
      id: data['id'],
      pedidoId: data['pedidoId'],
      separadorId: data['separadorId'],
      status: data['status'],
    );
  }

  Map toJson() {
    return {
      id: this.id,
      pedidoId: this.pedidoId,
      separadorId: this.separadorId,
      status: this.status,
    };
  }
}
