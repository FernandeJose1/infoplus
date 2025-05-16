import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OfflineCache {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  static Future<Database> init() async {
    final path = join(await getDatabasesPath(), 'infoplus.db');
    return openDatabase(path, version: 1, onCreate: (db, version) {
      // criar tabelas iniciais
    });
  }
}