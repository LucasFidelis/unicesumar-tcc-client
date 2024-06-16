import 'package:flutter/material.dart';

class TextDataColumn extends StatelessWidget {
  final String text;
  const TextDataColumn({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
