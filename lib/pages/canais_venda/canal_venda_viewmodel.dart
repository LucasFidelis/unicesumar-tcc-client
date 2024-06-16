class CanalVendaViewModel {
  final String id;
  String nome;
  String prioridade;

  CanalVendaViewModel({
    required this.id,
    required this.nome,
    required this.prioridade,
  });

  factory CanalVendaViewModel.fromJson(Map data) {
    return CanalVendaViewModel(
      id: data['id'],
      nome: data['nome'],
      prioridade: data['prioridade'],
    );
  }
}
