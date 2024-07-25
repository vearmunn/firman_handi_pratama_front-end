class Kategori {
  final int? id;
  final String namaKategori;

  Kategori({required this.id, required this.namaKategori});

  static Kategori fromJson(Map<String, dynamic> json) => Kategori(
      id: json['id_kategori'] as int?,
      namaKategori: json['nama_kategori'] as String);
}
