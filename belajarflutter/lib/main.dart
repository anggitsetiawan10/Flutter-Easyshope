import 'package:flutter/material.dart';
import 'hello_world.dart'; // Mengimpor file hello_world.dart
import 'column_widget.dart';
import 'row_widget.dart';
import 'product_page.dart';
import 'produk_form.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aplikasi Flutter Pertama",
      home: ProdukPage(),
    );
  }
}
