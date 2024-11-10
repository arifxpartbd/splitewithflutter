import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TodoDatabase{
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async{
    // Get the application documents directory
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path = "${documentDirectory.path}/$fileName";

    return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version)async{
    await db.execute('''
    CREATE TABLE todos(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    isDone INTEGER NOT NULL
    )
    ''');
  }
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}