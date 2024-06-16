import 'package:flutter/material.dart';

class Breadcrumb extends StatelessWidget {
  final String title;
  final String breadcrumb;

  const Breadcrumb({super.key, required this.title, required this.breadcrumb});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        Text(
          breadcrumb,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
