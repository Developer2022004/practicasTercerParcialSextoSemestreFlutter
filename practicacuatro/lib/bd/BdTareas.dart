import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BdTareas {
  static final BdTareas _instance = BdTareas._internal();

  factory BdTareas() => _instance;

  BdTareas._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'tareas.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tareas(
            Id INTEGER PRIMARY KEY AUTOINCREMENT,
            Titulo TEXT NOT NULL,
            Descripcion TEXT NOT NULL,
            Realizada INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertarTarea(String titulo, String descripcion) async {
    final db = await database;
    return await db.insert("tareas", {
      'Titulo': titulo,
      'Descripcion': descripcion,
      'Realizada': 1,
    });
  }

  Future<List<Map<String, dynamic>>> obtenerTareas() async {
    final db = await database;
    return await db.query("tareas");
  }
}
