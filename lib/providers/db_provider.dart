import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/scan.dart';
export '../model/scan.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsFolder = await getApplicationDocumentsDirectory();
    final path = join(documentsFolder.path, 'ScansDB.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ('
          'id INTEGER PRIMARY KEY,'
          'type TEXT,'
          'value TEXT'
          ')');
    });
  }

  create(ScanModel scan) async {
    final db = await database;
    final res = await db?.insert('Scans', scan.toJson());
    return res;
  }

  Future<ScanModel?> getById(int id) async {
    final db = await database;
    final res = await db?.query('Scans', where: 'id = ?', whereArgs: [id]);
    return (res != null && res.isNotEmpty)
        ? ScanModel.fromJson(res.first)
        : null;
  }

  Future<List<ScanModel>?> getAll() async {
    final db = await database;
    final res = await db?.query('Scans');
    return (res != null && res.isNotEmpty)
        ? res.map((e) => ScanModel.fromJson(e)).toList()
        : [];
  }

  Future<List<ScanModel>?> getByType(String type) async {
    final db = await database;
    final res = await db?.query('Scans', where: 'type = ?', whereArgs: [type]);
    return (res != null && res.isNotEmpty)
        ? res.map((e) => ScanModel.fromJson(e)).toList()
        : null;
  }

  Future<int?> update(ScanModel scan) async {
    final db = await database;
    final res = await db
        ?.update('Scans', scan.toJson(), where: 'id = ?', whereArgs: [scan.id]);
    return res;
  }

  Future<int?> deleteById(int id) async {
    final db = await database;
    final res = await db?.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int?> deleteAll() async {
    final db = await database;
    final res = await db?.delete('Scans');
    return res;
  }
}
