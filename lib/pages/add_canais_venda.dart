import 'package:app/application/token_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddCanaisVenda extends StatefulWidget {
  AddCanaisVenda({super.key});

  @override
  _AddCanaisVenda createState() => _AddCanaisVenda();
}

final List<String> prioridades = ['Baixa', 'Média', 'Alta'];

class _AddCanaisVenda extends State<AddCanaisVenda> {
  final TokenManager tokenManager = TokenManager();
  String prioridadeValue = prioridades.first;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard > Canais de Venda > Adicionar Canal',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Nome do canal de venda',
            ),
          ),
          DropdownButton(
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
          SizedBox(
            width: 300,
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Cadastrar'),
            ),
          )
        ],
      ),
    );
  }
}
