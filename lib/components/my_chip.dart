import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  final String text;

  MyChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.grey[250],
    );
  }
}
