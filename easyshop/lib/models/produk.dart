class Produk {
  final int id;
  final int idkategori;
  final String judul;
  final String harga;
  final String hargax;
  final String thumbnail;

  Produk({
    required this.id,
    required this.idkategori,
    required this.judul,
    required this.harga,
    required this.hargax,
    required this.thumbnail,
  });

  // Factory constructor untuk membuat instance Produk dari JSON
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'] as int,  // Asumsi data JSON selalu memiliki nilai id sebagai int
      idkategori: json['idkategori'] as int, // Asumsi data JSON selalu memiliki nilai idkategori sebagai int
      judul: json['judul'] ?? '', // Jika judul null, set sebagai string kosong
      harga: json['harga'] ?? '', // Jika harga null, set sebagai string kosong
      hargax: json['hargax'] ?? '', // Jika hargax null, set sebagai string kosong
      thumbnail: json['thumbnail'] ?? '', // Jika thumbnail null, set sebagai string kosong
    );
  }
}


// class Produk {
//   final int id;
//   final int idkategori;
//   final String judul;
//   final String harga;
//   final String hargax;
//   final String thumbnail;
//
//   Produk({required this.id,required this.idkategori,required this.judul,required this.harga,required this.hargax,required this.thumbnail});
//
//   factory Produk.fromJson(Map<String, dynamic> json){
//     return Produk(
//       id : json['id'] as int,
//       idkategori : json['idkategori'] as int,
//       judul : json['judul'] as String,
//       harga : json['harga'] as String,
//       hargax : json['hargax'] as String,
//       thumbnail : json['thumbnail'] as String
//     );
//   }
// }