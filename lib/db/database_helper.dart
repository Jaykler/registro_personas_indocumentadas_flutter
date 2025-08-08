
import 'package:path/path.dart';
import '../models/persona.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';



class DatabaseHelper {
  
 DatabaseHelper._privateConstructor() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  factory DatabaseHelper() => _instance;
  

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('personas.db');
    return _db!;
  }


  Future<Database> _initDB(String fileName) async {
    final path = join(await getDatabasesPath(), fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE personas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT,
          edad INTEGER,
          nacionalidad TEXT,
          fechaHora TEXT,
          latitud REAL,
          longitud REAL,
          descripcion TEXT,
          fotoPath TEXT,
          audioPath TEXT
        )
        ''');
      },
    );
  }

  Future<int> insertPersona(Persona persona) async {
    final db = await database;
    return await db.insert('personas', persona.toMap());
  }

  Future<List<Persona>> getPersonas() async {
    final db = await database;
    final res = await db.query('personas');
    return res.map((e) => Persona.fromMap(e)).toList();
  }

  Future<int> deleteAll() async {
    final db = await database;
    return await db.delete('personas');
  }
}
