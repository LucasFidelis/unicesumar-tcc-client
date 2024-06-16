import 'package:flutter/material.dart';

mixin UIErrorManager {
  void handleMainError(BuildContext context, Stream<String?> stream) {
    stream.listen((error) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(error, textAlign: TextAlign.center),
        ));
      }
    });
  }
}
