import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Bd {
  static final Bd _instance = Bd._internal();

  //Constructor del tipo factory
  factory Bd() => _instance;

  Bd._internal();

  Database? _database;

  //Tareas asyncronas

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'usuarios.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE usuarios(
          Id INTEGER PRIMARY KEY AUTOINCREMENT,
          Usuario TEXT NOT NULL,
          Password TEXT NOT NULL
        )

        ''');
      },
    );
  }

  Future<bool> validarUsuario(String usuario, String password) async {
    final db = await database;
    List<Map<String, dynamic>> usuario_encontrado = await db.query(
      "usuarios",
      where: "Usuario = ? and Password = ?",
      whereArgs: [usuario, password],
    );
    return usuario_encontrado.isNotEmpty;
  }

  //Para enviar los datos y guardarlos
  Future<int> insertarUsuario(String usuario, password) async {
    final db = await database;
    return await db.insert("usuarios", {
      'Usuario': usuario,
      'Password': password,
    });
  }

  Future<int> eliminarUsuario(int id) async {
    final db = await database;
    return await db.delete('Usuarios', where: 'Id =  ?', whereArgs: [id]);
  }

  Future<int> modificarUsuario(int id, String usuario, password) async {
    final db = await database;
    return await db.update(
      "usuarios",
      {'Usuario': usuario, 'Password': password},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    final db = await database;
    return await db.query("usuarios");
  }
}
