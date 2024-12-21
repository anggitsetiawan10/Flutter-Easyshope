 // class Kategori {
//   final int id;
//   final String nama;

//   Kategori({this.id, this.nama});

//   factory Kategori.fromJson(Map<String, dynamic> json) {
//     return Kategori(id: json['id'] as int, nama: json['nama'] as String);
//   }
// }

class Kategori {
  final int id;
  final String nama;

  Kategori({required this.id, required this.nama});

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'] as int,
      nama: json['nama'] as String,
    );
  }
}
