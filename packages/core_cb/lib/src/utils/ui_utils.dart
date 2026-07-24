import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showSnackbar(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.deepPurpleAccent.shade100,
    ),
  );
}
