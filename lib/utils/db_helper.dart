import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/models/todo.dart';

class DbHelper {
  static final _dbHelper = DbHelper._internal();
  static Database _db;

  final tblTodo = 'todo';
  final colId = 'id';
  final colTitle = 'title';
  final colDescription = 'description';
  final colPriority = 'priority';
  final colDate = 'date';

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> get db async {
    if (_db == null) _db = await initializeDb();
    return _db;
  }

  Future<Database> initializeDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbTodos = await openDatabase(dir.path + 'todos.db',
        version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  Future<List<Todo>> getTodos() async {
    final db = await this.db;
    final result = await db.query(tblTodo, orderBy: colPriority);
    return result.map((e) => Todo.fromObject(e)).toList();
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await this.db;
    final result = await db.insert(tblTodo, todo.toMap());
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await this.db;
    return db.update(tblTodo, todo.toMap(),
        where: '$colId = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    final db = await this.db;
    return db.delete(tblTodo, where: '$colId = ?', whereArgs: [id]);
  }
}
