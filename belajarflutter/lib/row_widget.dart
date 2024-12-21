import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Row dalam Flutter'),
      ),
      body: Row(
        children: const [
          Text('Row 1'),
          Text('Row 2'),
        ],
      ),
    );
  }
}
