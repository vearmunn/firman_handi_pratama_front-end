// ignore_for_file: public_member_api_docs, sort_constructors_first
const String idField = "id";
const String namaBarangField = "nama_barang";
const String idKategoriField = "id_kategori";
const String kelompokBarangField = "kelompok_barang";
const String stokField = "stok";
const String hargaField = "harga";
const String imagePathField = "image_path";

class Barang {
  final int? id;
  final String namaBarang;
  final int idKategori;
  final String kelompokBarang;
  final int stok;
  final int harga;
  final String imagePath;

  Barang(
      {required this.id,
      required this.namaBarang,
      required this.idKategori,
      required this.kelompokBarang,
      required this.stok,
      required this.harga,
      required this.imagePath});

  static Barang fromJson(Map<String, dynamic> json) => Barang(
      id: json[idField] as int?,
      namaBarang: json[namaBarangField] as String,
      idKategori: json[idKategoriField] as int,
      kelompokBarang: json[kelompokBarangField] as String,
      stok: json[stokField] as int,
      harga: json[hargaField] as int,
      imagePath: json[imagePathField] as String);

  Barang copyWith({
    int? id,
    String? namaBarang,
    int? idKategori,
    String? kelompokBarang,
    int? stok,
    int? harga,
    String? imagePath,
  }) =>
      Barang(
          id: id ?? this.id,
          namaBarang: namaBarang ?? this.namaBarang,
          idKategori: idKategori ?? this.idKategori,
          kelompokBarang: kelompokBarang ?? this.kelompokBarang,
          stok: stok ?? this.stok,
          harga: harga ?? this.harga,
          imagePath: imagePath ?? this.imagePath);
}
