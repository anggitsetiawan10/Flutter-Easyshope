import 'package:flutter/material.dart';

class ColumnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kolom dalam flutter'),
      ),
      body: Column(
        children: const [
          Text('Kolom 3'),
          Text('Kolom 4'),
        ],
      ),
    );
  }
}
