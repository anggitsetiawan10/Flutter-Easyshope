import 'package:flutter/material.dart';

class HelloWorld extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halo Perkenalkan Nama Saya'),
      ),
      body: const Center(
        child: Text('Hello Saya Anggit Setiawan'),
      ),
    );
  }
}
