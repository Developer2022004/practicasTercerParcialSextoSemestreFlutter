import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BdQR {
  static final BdQR _instance = BdQR._internal();

  //constructor factory
  factory BdQR() => _instance;

  BdQR._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'Abarrotera.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE productos(
            codigo TEXT PRIMARY KEY,
            nombre TEXT NOT NULL,
            precio REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertarProducto(
    String codigo,
    String nombre,
    double precio,
  ) async {
    final db = await database;
    return await db.insert("productos", {
      'codigo': codigo,
      'nombre': nombre,
      'precio': precio,
    });
  }

  Future<List<Map<String, dynamic>>> obtenerProductos() async {
    final db = await database;
    return await db.query("productos");
  }

  Future<int> actualizarProducto(
    String codigo,
    String nombre,
    double precio,
  ) async {
    final db = await database;
    return await db.update(
      "productos",
      {"codigo": codigo, "nombre": nombre, "precio": precio},
      where: "codigo = ?",
      whereArgs: [codigo],
    );
  }

  Future<int> eliminarProducto(String codigo) async {
    final db = await database;
    return await db.delete(
      "productos",
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }
}
