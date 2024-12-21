import 'produk_form.dart';
import 'produk_detail.dart';
import 'package:flutter/material.dart';
class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});
  @override
  _ProdukPageState createState() => _ProdukPageState();
}


class _ProdukPageState extends State<ProdukPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Data Produk'),
      actions: [
        GestureDetector(
// menampilkan icon +
            child: const Icon(Icons.add),
//pada saat icon + di tap
            onTap: () async {
//berpindah ke halaman ProdukForm
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProdukForm()));
            })

      ],
   ),
      body: ListView(
    children: const[
      //List 1
        ItemProduk(
          kodeProduk: "A001",
          namaProduk: "Kulkas",
          harga: 2500000,
        ),
          //List 2
      ItemProduk(
        kodeProduk: "A002",
        namaProduk: "TV",
        harga: 50000000,
      ),
          // List 3
        ItemProduk(
          kodeProduk: "A003",
          namaProduk: "GTR Nssan",
          harga: 1500000000,
        ),
          ],
          ),
    );
    }
  }
class ItemProduk extends StatelessWidget {
  final String? kodeProduk;
  final String? namaProduk;
  final int? harga;
  const ItemProduk({super.key, this.kodeProduk, this.namaProduk, this.harga});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(namaProduk.toString()),
          subtitle: Text(harga.toString()),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProdukDetail(
                  kodeProduk: kodeProduk,
                  namaProduk: namaProduk,
                  harga: harga,
                )));
      },

    );
  }
}
