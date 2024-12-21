// import 'package:easyshop/users/produkdetailpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/kategori.dart';
import '../models/produk.dart'; // Sesuaikan path sesuai dengan lokasi model Anda.
import '../constans.dart'; // Mengimpor file konstanta untuk URL atau konfigurasi lainnya.
import 'dart:async';
import 'produkdetailpage.dart';
import '../main.dart';

class DepanPage extends StatefulWidget {
  const DepanPage({Key? key}) : super(key: key);

  @override
  State<DepanPage> createState() => _DepanPageState();
}

class _DepanPageState extends State<DepanPage> {
  List<Kategori> kategoriList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  Future<void> fetchKategori() async {
    const String endpoint = '/kategoribyproduk';
    final String url = '${Palette.sUrl}$endpoint';

    try {
      print('Mengambil data dari: $url');  // Mencetak URL yang dipanggil
      final response = await http.get(Uri.parse(url));
      print('Status respons: ${response.statusCode}');  // Mencetak kode status respons
      if (response.statusCode == 200) {
        print('Isi respons: ${response.body}');  // Mencetak isi respons
        final List<dynamic> jsonItems = json.decode(response.body);
        setState(() {
          kategoriList = jsonItems.map((json) => Kategori.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal memuat kategori: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    await fetchKategori();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : kategoriList.isEmpty
            ? const Center(child: Text('Kategori tidak ditemukan'))
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: kategoriList.map((kategori) {
              return WidgetbyKategori(
                id: kategori.id,
                kategori: kategori.nama,
                warna: kategoriList.indexOf(kategori),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class WidgetbyKategori extends StatefulWidget {
  final int id;
  final String kategori;
  final int warna;

  const WidgetbyKategori({
    Key? key,
    required this.id,
    required this.kategori,
    required this.warna,
  }) : super(key: key);

  @override
  State<WidgetbyKategori> createState() => _WidgetbyKategoriState();
}

class _WidgetbyKategoriState extends State<WidgetbyKategori> {
  Future<List<Produk>> fetchProduk(String id) async {
    final String endpoint = '/produkbykategori?id=$id';
    final String url = '${Palette.sUrl}$endpoint';
    print('Mengambil data dari: $url'); // Menampilkan URL yang diakses
    try {
      final response = await http.get(Uri.parse(url));
      print('Status respons: ${response.statusCode}'); // Menampilkan status respons
      if (response.statusCode == 200) {
        final List<dynamic> jsonItems = json.decode(response.body);
        return jsonItems.map((json) => Produk.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat produk: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int adjustedColorIndex = widget.warna % Palette.colors.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(10.0),
                    ),
                    color: Palette.colors[adjustedColorIndex],
                  ),
                  child: Text(
                    widget.kategori,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('Selengkapnya untuk kategori ID: ${widget.id}');
                  },
                  child: const Text(
                    'Selengkapnya',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200.0,
            margin: const EdgeInsets.only(bottom: 7.0),
            child: FutureBuilder<List<Produk>>(
              future: fetchProduk(widget.id.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Produk tidak ditemukan'));
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    final produk = snapshot.data![i];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          print('Produk ID: ${produk.id}');
                          Navigator.of(context)
                              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                            return ProdukDetailPage(
                                id: produk.id,
                                judul: produk.judul,
                                harga: produk.harga,
                                hargax: produk.hargax,
                                deskripsi: '',
                                thumbnail: produk.thumbnail,
                                valstok: false);
                          }));
                        },
                        child: SizedBox(
                          width: 135.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.network(
                                Palette.sUrl + produk.thumbnail,
                                height: 110.0,
                                width: 110.0,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  produk.judul,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: Text(produk.harga),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





// import 'package:easyshop/users/produkdetailpage.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/kategori.dart';
// import '../models/produk.dart';// Sesuaikan path sesuai dengan lokasi model Anda.
// import '../constans.dart'; // Mengimpor file konstanta untuk URL atau konfigurasi lainnya.
// import 'dart:async';
// import 'produkdetailpage.dart';
//
// class DepanPage extends StatefulWidget {
//   const DepanPage({Key? key}) : super(key: key);
//
//   @override
//   State<DepanPage> createState() => _DepanPageState();
// }
//
// class _DepanPageState extends State<DepanPage> {
//   List<Kategori> kategoriList = [];
//   bool isLoading = true;
//   String? errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchKategori();
//   }
//
//   Future<void> fetchKategori() async {
//     const String endpoint = '/kategoribyproduk';
//     final String url = '${Palette.sUrl}$endpoint';
//
//     try {
//       print('Mengambil data dari: $url');  // Mencetak URL yang dipanggil
//       final response = await http.get(Uri.parse(url));
//       print('Status respons: ${response.statusCode}');  // Mencetak kode status respons
//       if (response.statusCode == 200) {
//         print('Isi respons: ${response.body}');  // Mencetak isi respons
//         final List<dynamic> jsonItems = json.decode(response.body);
//         setState(() {
//           kategoriList = jsonItems.map((json) => Kategori.fromJson(json)).toList();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Gagal memuat kategori: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Terjadi kesalahan: $e';
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _refresh() async {
//     setState(() {
//       isLoading = true;
//     });
//     await fetchKategori();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: RefreshIndicator(
//         onRefresh: _refresh,
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : errorMessage != null
//             ? Center(child: Text(errorMessage!))
//             : kategoriList.isEmpty
//             ? const Center(child: Text('Kategori tidak ditemukan'))
//             : SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: kategoriList.map((kategori) {
//               return WidgetbyKategori(
//                 id: kategori.id,
//                 kategori: kategori.nama,
//                 warna: kategoriList.indexOf(kategori),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class WidgetbyKategori extends StatefulWidget {
//   final int id;
//   final String kategori;
//   final int warna;
//
//   const WidgetbyKategori({
//     Key? key,
//     required this.id,
//     required this.kategori,
//     required this.warna,
//   }) : super(key: key);
//
//   @override
//   State<WidgetbyKategori> createState() => _WidgetbyKategoriState();
// }
//
// class _WidgetbyKategoriState extends State<WidgetbyKategori> {
//   Future<List<Produk>> fetchProduk(String id) async {
//     final String endpoint = '/produkbykategori?id=$id';
//     final String url = '${Palette.sUrl}$endpoint';
//     print('Mengambil data dari: $url'); // Menampilkan URL yang diakses
//     try {
//       final response = await http.get(Uri.parse(url));
//       print('Status respons: ${response.statusCode}'); // Menampilkan status respons
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonItems = json.decode(response.body);
//         return jsonItems.map((json) => Produk.fromJson(json)).toList();
//       } else {
//         throw Exception('Gagal memuat produk: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Terjadi kesalahan: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final int adjustedColorIndex = widget.warna % Palette.colors.length;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20.0),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//             padding: const EdgeInsets.only(right: 10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width * 0.6,
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.horizontal(
//                       right: Radius.circular(10.0),
//                     ),
//                     color: Palette.colors[adjustedColorIndex],
//                   ),
//                   child: Text(
//                     widget.kategori,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 // InkWell(
//                 //   onTap: () {
//                 //     Navigator.of(context)
//                 //         .push(MaterialPageRoute(builder: (_) {
//                 //       return ProdukPage("kat", widget.id, 0, widget.kategori);
//                 //     }));
//                 //   },
//                 // )
//                 GestureDetector(
//                   onTap: () {
//                     print('Selengkapnya untuk kategori ID: ${widget.id}');
//                   },
//                   child: const Text(
//                     'Selengkapnya',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 200.0,
//             margin: const EdgeInsets.only(bottom: 7.0),
//             child: FutureBuilder<List<Produk>>(
//               future: fetchProduk(widget.id.toString()),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('Produk tidak ditemukan'));
//                 }
//                 return ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, i) {
//                     final produk = snapshot.data![i];
//                     return Card(
//                       child: InkWell(
//                         onTap: () {
//                           print('Produk ID: ${produk.id}');
//                           Navigator.of(context)
//                               .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
//                             return new ProdukDetailPage(
//                                 snapshot.data![i].id,
//                                 snapshot.data![i].judul,
//                                 snapshot.data![i].harga,
//                                 snapshot.data![i].hargax,
//                                 snapshot.data![i].thumbnail,
//                                 false);
//                         }));
//                         child: SizedBox(
//                           width: 135.0,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               Image.network(
//                                 Palette.sUrl + produk.thumbnail,
//                                 height: 110.0,
//                                 width: 110.0,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return const Icon(Icons.broken_image);
//                                 },
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 5.0),
//                                 child: Text(
//                                   produk.judul,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
//                                 child: Text(produk.harga),
//                               ),
//                             ],
//                           ),
//                     );
//                   },
//             ),
//       ),
//     );
//   }
// }
//
