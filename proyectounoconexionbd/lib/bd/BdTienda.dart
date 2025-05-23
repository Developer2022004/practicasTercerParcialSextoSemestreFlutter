//Importamos la libreria para interactuar con la ruta de almacenamiento de las bases de dato
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BdTienda {
  //Creamos el objeto de la instancia de la clase BdTienda
  static final BdTienda _instance = BdTienda._internal();

  //Creamos un constructor del tipo factory
  factory BdTienda() => _instance;

  BdTienda._internal();

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
    String path = join(await getDatabasesPath(), 'tienda.db');
    return await openDatabase(
      path,
      version: 1,
      // version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            Id INTEGER PRIMARY KEY AUTOINCREMENT,
            Usuario TEXT NOT NULL,
            Password TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE productos(
            Id INTEGER PRIMARY KEY AUTOINCREMENT,
            Nombre TEXT NOT NULL,
            Precio REAL NOT NULL,
            Cantidad INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  //Metodos para cargar a la entidad de usuarios

  Future<int> crearUsuario(String usuario, String password) async {
    final db = await database;
    //Nota el valor que se retorna al usar Databse.insert corresponde al ID creado del usuario
    return await db.insert("usuarios", {
      'Usuario': usuario,
      'Password': password,
    });
  }

  Future<Map<String, dynamic>?> buscarUsuario(String usuario) async {
    final db = await database;
    List<Map<String, dynamic>> usuario_encontrado = await db.query(
      "usuarios",
      where: "Usuario = ?",
      whereArgs: [usuario],
    );
    return (usuario_encontrado.isNotEmpty) ? usuario_encontrado.first : null;
  }

  //Metodos para cargar a la entidad productos
  Future<int> crearProducto(String nombre, double precio, int cantidad) async {
    final db = await database;
    return await db.insert("productos", {
      'Nombre': nombre,
      'Precio': precio,
      'Cantidad': cantidad,
    });
  }

  Future<int> modificarProducto(
    int id,
    String nombre,
    double precio,
    int cantidad,
  ) async {
    final db = await database;
    return await db.update(
      "productos",
      {'Nombre': nombre, 'Precio': precio, 'Cantidad': cantidad},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> eliminarProducto(int id) async {
    final db = await database;
    return await db.delete("Productos", where: "Id = ?", whereArgs: [id]);
  }

  Future<int> eliminarProductos() async {
    final db = await database;
    return await db.delete("Productos");
  }

  Future<List<Map<String, dynamic>>> obtenerProductos() async {
    final db = await database;
    return await db.query("productos");
  }
}
