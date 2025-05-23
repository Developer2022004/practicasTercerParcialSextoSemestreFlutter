import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class BdLogin {
  //Creamos el objeto de la instancia perteneciente a la clase BdLogin
  static final BdLogin _instance = BdLogin._internal();

  //Creamos un constructor del tipo factory
  factory BdLogin() => _instance;

  BdLogin._internal();

  //Creamos la instancia que interactuara con la BD
  Database? _database;

  //Tareas asincronas

  //Creamos el metodo de conexion a la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  //Metodo que carga la estructura de la base de datos
  Future<Database> _initDB() async {
    //Nota sqflite no permite la ejecucion simultanea de diferentes consultas a la BD
    //Razon por la cual para crear diversas tables es necesario ejecutar la consulta de cada tabla
    //por separado
    String path = join(await getDatabasesPath(), 'login.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
            CREATE TABLE usuarios(
              Id INTEGER PRIMARY KEY AUTOINCREMENT,
              Usuario TEXT NOT NULL,
              Password TEXT NOT NULL
            )
          ''');
    });
  }

  //Metodos para cargar a la tabla de usuarios
  Future<int> crearUsuario(String usuario, String password) async {
    final db = await database;
    return await db
        .insert("usuarios", {'Usuario': usuario, 'Password': password});
  }

  //Metodo para buscar un unico usuario
  Future<Map<String, dynamic>?> buscarUsuario(String usuario) async {
    final db = await database;
    List<Map<String, dynamic>> usuario_encontrado =
        await db.query("usuarios", where: "Usuario = ?", whereArgs: [usuario]);
    return (usuario_encontrado.isNotEmpty) ? usuario_encontrado.first : null;
  }
}
