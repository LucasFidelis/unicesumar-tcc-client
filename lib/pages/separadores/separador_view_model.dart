class SeparadorViewModel {
  final String id;
  String nome;
  String cpf;

  SeparadorViewModel({
    required this.id,
    required this.nome,
    required this.cpf,
  });

  factory SeparadorViewModel.fromJson(Map data) {
    return SeparadorViewModel(
      id: data['id'],
      nome: data['nome'],
      cpf: data['cpf'],
    );
  }

  Map toJson() {
    return {
      id: id,
      nome: nome,
      cpf: cpf,
    };
  }
}
