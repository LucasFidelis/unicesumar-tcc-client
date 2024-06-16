import 'package:flutter/material.dart';

const List<DataColumn> tabelaSeparacaoColumns = [
  DataColumn(
      label: Text(
        'Identificador Loja',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      tooltip: 'Book identifier'),
  DataColumn(
    label: Text(
      'Nome Cliente',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  DataColumn(
    label: Text(
      'Canal de Venda',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  DataColumn(
    label: Text(
      'Qtd. Produtos',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  DataColumn(
    label: Text(
      'Emissão',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  DataColumn(
    label: Text(
      'Separador',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  DataColumn(
    label: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  ),
];
