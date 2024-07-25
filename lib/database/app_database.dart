import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Future createTables(Database database) async {
    await database.execute(
        'CREATE TABLE tabel_kategori(id_kategori INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nama_kategori TEXT)');
    await database.execute(
        'CREATE TABLE tabel_barang(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nama_barang TEXT, kelompok_barang TEXT, stok INTEGER, harga INTEGER, image_path TEXT, id_kategori INTEGER)');
    await database.insert('tabel_kategori', {'nama_kategori': 'Mobile'});
    await database.insert('tabel_kategori', {'nama_kategori': 'Desktop'});
  }

  Future<String> getDBPath() async {
    var databasepath = await getDatabasesPath();
    return join(databasepath, 'db_barang.db');
  }

  Future<Database> opendb() async {
    return openDatabase(
      await getDBPath(),
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllKategori() async {
    final db = await opendb();
    return await db.query('tabel_kategori');
  }

  Future<List<Map<String, dynamic>>> getAllBarang(String query) async {
    final db = await opendb();
    return db.query('tabel_barang',
        where: "nama_barang LIKE ?", whereArgs: ['%$query%']);
  }

  Future<int> addBarang(
      {required String namaBarang,
      required String kelompokBarang,
      required int stok,
      required int harga,
      required int idKategori,
      required String imagePath}) async {
    final db = await opendb();
    final data = {
      'nama_barang': namaBarang,
      'kelompok_barang': kelompokBarang,
      'stok': stok,
      'harga': harga,
      'id_kategori': idKategori,
      'image_path': imagePath
    };

    final id = await db.insert('tabel_barang', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> updateBarang(
      {required int id,
      required String namaBarang,
      required String kelompokBarang,
      required int stok,
      required int harga,
      required int idKategori,
      required String imagePath}) async {
    final db = await opendb();
    final data = {
      'nama_barang': namaBarang,
      'kelompok_barang': kelompokBarang,
      'stok': stok,
      'harga': harga,
      'id_kategori': idKategori,
      'image_path': imagePath
    };

    final res =
        await db.update('tabel_barang', data, where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<int> deleteBarang({
    required int id,
  }) async {
    final db = await opendb();

    final res =
        await db.delete('tabel_barang', where: "id = ?", whereArgs: [id]);
    return res;
  }
}
