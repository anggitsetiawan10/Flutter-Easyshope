import 'package:flutter/material.dart';
import '../models/cabang.dart';
import 'package:http/http.dart' as http;
import '../constans.dart';
import 'dart:async';
import 'dart:convert';

class ProdukDetailPage extends StatefulWidget {
  const ProdukDetailPage({
    super.key,
    required this.id,
    required this.judul,
    required this.harga,
    required this.hargax,
    required this.deskripsi,
    required this.thumbnail,
    required this.valstok,
  });

  final int id; // ID Produk
  final String judul; // Judul Produk
  final String harga; // Harga Produk
  final String hargax; // Harga dengan Diskon
  final String deskripsi; // Deskripsi Produk
  final String thumbnail; // URL Thumbnail Produk
  final bool valstok; // Status Stok Produk

  @override
  State<ProdukDetailPage> createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
  List<Cabang> cabanglist = []; // Menyimpan daftar cabang dari API
  String _valcabang = ''; // Cabang yang dipilih oleh pengguna
  bool instok = false;

  @override
  void initState() {
    super.initState();

    // Debug untuk memverifikasi data
    debugPrint('ID Produk: ${widget.id}');
    debugPrint('Judul Produk: ${widget.judul}');
    debugPrint('Produk Detail Page menerima data:');
    debugPrint('ID: ${widget.id}');
    debugPrint('Judul: ${widget.judul}');
    debugPrint('Harga: ${widget.harga}');
    debugPrint('Harga Diskon: ${widget.hargax}');
    debugPrint('Deskripsi: ${widget.deskripsi}');
    debugPrint('Thumbnail URL: ${widget.thumbnail}');
    debugPrint('Stok: ${widget.valstok}');

    fetchCabang(); // Ambil data cabang saat page dibuka
    if (widget.valstok == true) {
      instok = widget.valstok;
    }
  }
  Future<void> fetchCabang() async {
    var urlCabang = Uri.parse('${Palette.sUrl}/cabang');
    var urlStokCabang =
    Uri.parse('${Palette.sUrl}/stokcabang?idproduk=${widget.id}');

    try {
      // Fetch data cabang
      var responseCabang = await http.get(urlCabang);
      debugPrint("Response cabang: ${responseCabang.body}");
      if (responseCabang.statusCode == 200) {
        var cabangData = json.decode(responseCabang.body)['data'] as List;
        List<Cabang> allCabang = cabangData.map((item) => Cabang.fromJson(item)).toList();

        // Fetch stok cabang
        var responseStokCabang = await http.get(urlStokCabang);
        debugPrint("Response stokcabang: ${responseStokCabang.body}");
        if (responseStokCabang.statusCode == 200) {
          var decodedResponse = json.decode(responseStokCabang.body);
          if (decodedResponse['data'] is List) {
            var stokData = decodedResponse['data'] as List;
            var cabangIdsWithStok =
            stokData.map((stokItem) => stokItem['idcabang'].toString()).toSet();

            // Filter cabang dengan stok
            var filteredCabang = allCabang.where((cabang) {
              return cabangIdsWithStok.contains(cabang.id.toString());
            }).toList();

            setState(() {
              cabanglist = filteredCabang;
              if (cabanglist.isNotEmpty) {
                _valcabang = cabanglist[0].id.toString();
              }
            });
          } else {
            debugPrint("Error: Data stok bukan array.");
          }
        } else {
          debugPrint("Gagal memuat stok cabang: ${responseStokCabang.statusCode}");
        }
      } else {
        debugPrint("Gagal memuat data cabang: ${responseCabang.statusCode}");
      }
    } catch (e) {
      debugPrint("Error saat fetchCabang: $e");
    }
  }
  _cekProdukCabang(String idproduk, String idcabang) async {
    debugPrint("Memeriksa stok untuk ID produk: $idproduk di cabang: $idcabang");
    var params = "/stokcabang?idproduk=" + idproduk + "&idcabang=" + idcabang;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var res = await http.get(sUrl);
      debugPrint("Respon API: ${res.body}");
      if (res.statusCode == 200) {
        var decodedResponse = json.decode(res.body);

        // Pastikan data memiliki struktur yang benar
        if (decodedResponse['status'] == true && decodedResponse['data'] is List) {
          var data = decodedResponse['data'] as List;
          // Periksa apakah ada idcabang yang cocok
          bool stokTersedia = data.any((item) => item['idcabang'] == idcabang);

          setState(() {
            instok = stokTersedia;
          });
          debugPrint(stokTersedia
              ? "Stok tersedia untuk cabang $idcabang"
              : "Stok tidak tersedia untuk cabang $idcabang");
        } else {
          debugPrint("Format data tidak sesuai atau stok tidak ditemukan.");
          setState(() {
            instok = false;
          });
        }
      } else {
        debugPrint("Gagal memeriksa stok: Status Code ${res.statusCode}");
        setState(() {
          instok = false;
        });
      }
    } catch (e) {
      debugPrint("Kesalahan saat memeriksa stok: $e");
      setState(() {
        instok = false;
      });
    }
  }




  // _cekProdukCabang(String idproduk, String idcabang) async {
  //   debugPrint("kon biru");
  //   var params =
  //       "/stokcabang?idproduk=" + idproduk + "&idcabang=" + idcabang;
  //   var sUrl = Uri.parse(Palette.sUrl + params);
  //   try {
  //     var res = await http.get(sUrl);
  //     if (res.statusCode == 200) {
  //       if (res.body == "OK") {
  //         setState(() {
  //           instok = true;
  //         });
  //       } else {
  //         setState(() {
  //           instok = false;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     setState(() {
  //       instok = false;
  //     });
  //   }
  // }

  //
  // Future<void> fetchCabang() async {
  //   var urlCabang = Uri.parse('${Palette.sUrl}/cabang');
  //   var urlStokCabang = Uri.parse('${Palette.sUrl}/stokcabang?idproduk=${widget.id}');
  //   try {
  //     // Ambil daftar cabang
  //     var responseCabang = await http.get(urlCabang);
  //     if (responseCabang.statusCode == 200) {
  //       var cabangData = json.decode(responseCabang.body)['data'] as List;
  //       List<Cabang> allCabang = cabangData.map((item) => Cabang.fromJson(item)).toList();
  //
  //       // Ambil daftar cabang dengan stok produk
  //       var responseStokCabang = await http.get(urlStokCabang);
  //       if (responseStokCabang.statusCode == 200) {
  //         var stokData = json.decode(responseStokCabang.body)['data'] as List;
  //         var cabangIdsWithStok = stokData.map((stokItem) => stokItem['idcabang'].toString()).toSet();
  //
  //         // Filter cabang yang memiliki stok
  //         var filteredCabang = allCabang.where((cabang) {
  //           return cabangIdsWithStok.contains(cabang.id.toString());
  //         }).toList();
  //
  //         // Update state
  //         setState(() {
  //           cabanglist = filteredCabang;
  //           if (cabanglist.isNotEmpty) {
  //             _valcabang = cabanglist[0].id.toString(); // Pilih default cabang
  //           }
  //         });
  //       } else {
  //         debugPrint("Gagal memuat cabang dengan stok: ${responseStokCabang.statusCode}");
  //       }
  //     } else {
  //       debugPrint("Gagal memuat data cabang: ${responseCabang.statusCode}");
  //     }
  //   } catch (e) {
  //     debugPrint("Error saat fetchCabang: $e");
  //   }
  // }

  // Fungsi untuk membangun UI utama
  Widget _body() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Thumbnail Produk
          Container(
            width: double.infinity,
            child: Image.network(
              Palette.sUrl + widget.thumbnail,
              fit: BoxFit.fitWidth,
            ),
          ),
          // Judul Produk
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: SelectableText(widget.judul, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          // Harga Produk
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: SelectableText(
              widget.harga,
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
          ),
          // Dropdown Pilihan Cabang
          // Dropdown Pilihan Cabang
          Container(
            margin: const EdgeInsets.all(10),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 10, left: 12.0, bottom: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              hint: const Text("Pilih Cabang"), // Placeholder
              value: _valcabang.isNotEmpty ? _valcabang : null, // Nilai default hanya diisi jika ada pilihan
              items: cabanglist.map((item) {
                return DropdownMenuItem<String>(
                  value: item.id.toString(), // ID cabang
                  child: Text(item.nama), // Nama cabang
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _valcabang = newValue ?? ''; // Update nilai cabang terpilih
                  debugPrint("Cabang yang dipilih: $_valcabang");
                  if (_valcabang.isNotEmpty) {
                    _cekProdukCabang(widget.id.toString(), _valcabang);
                  }
                });
              },
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Detail Produk'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _body(), // Panggil UI utama
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: (){
                      debugPrint("Tombol Favorit ditekan");
                    },
                    child: Container(
                      child: Icon(
                        Icons.favorite_border,
                        size: 40.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(color: Colors.grey[100] ?? Colors.grey, spreadRadius: 1),
                          //BoxShadow(color: Colors.grey[500], spreadRadius: 1),
                        ],
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: (){
                      debugPrint("Tombol keraanjang ditekan");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/keranjanguser', (Route<dynamic> route) => false);
                    },
                    child: Container(
                      child: Icon(
                        Icons.shopping_cart,
                        size: 40.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(color: Colors.grey[100] ?? Colors.grey, spreadRadius: 1),
                          // BoxShadow(color: Colors.grey[500], spreadRadius: 1),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    if (instok == true){
                      // Keranjang _keranjangku = Keranjang(
                      //   idproduk: widget.id,
                      //   judul: widget.judul,
                      //   harga: widget.harga,
                      //   thumbnail: widget.thumbnail,
                      //   jumlah: 1,
                      //   userId: _valcabang);
                      // saveKeranjang(_keranjangku);
                    }
                  },
                  child: Container(
                    height: 40.0,
                    child: Center(
                      child: Text('Beli Sekarang',
                          style: TextStyle(color: Colors.white)),
                    ),
                    decoration: BoxDecoration(
                      color: instok == true ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow:[
                        BoxShadow(
                            color: instok == true ? Colors.blue : Colors.grey,
                            spreadRadius:1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          height: 60.0,
          padding:
          EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow:[
              BoxShadow(color: Colors.grey[100] ?? Colors.grey, spreadRadius: 1),
              // BoxShadow(color: Colors.grey[100], spreadRadius: 1),
            ],
          ),
        ),
        elevation: 0,
      ),
    );
  }
}
