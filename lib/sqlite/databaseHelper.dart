import 'dart:io';

import 'package:crud_app_sqlite/model/toDoModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper{
  DataBaseHelper._privateConstructor();
  static final DataBaseHelper instant = DataBaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async =>_database ??= await _initDatabase();

  Future<Database>_initDatabase()async{
    Directory documentDirectory=await getApplicationSupportDirectory();

    String path = join(documentDirectory.path,'todos.db',);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

//THIS FUNCTION WILL CREATE DATABASE TABLE THAT NAME IS TODOS
  Future _onCreate(Database db,int version)async{
   await db.execute(
     """
     CREATE TABLE todos(
     id INTEGER PRIMARY KEY,
     Title TEXT,
     description TEXT
     )"""
   );
  }


//THIS FUNCTION WILL INSER DATA TO THE TABLE
  Future<int>addTodos(TodoModel todo)async{
    Database db = await instant.database;
    return await db.insert("todos", todo.toJson());
  }

//THIS FUNCTION WILL GET DATA FROM TABLE
  Future<List<TodoModel>>getTodos()async{
    Database db = await instant.database;
    var todos = await db.query('todos',orderBy: 'id');
    List<TodoModel>_todos = todos.isNotEmpty?todos.map((e) => TodoModel.fromJson(e)).toList():[];
    return _todos;
  }
//THIS FUCKTION WILL DELETE DATA FROM TABLE
  Future deleteTodos(int? id)async{
    Database db = await instant.database;
    return await db.delete('todos',where: "id=?",whereArgs: [id]);

  }

//THIS FUNCTION WILL UPDATE THE DATA
Future updateTodo(TodoModel todo)async{
  Database db = await instant.database;
  return await db.update('todos', todo.toJson(),
  where: 'id=?',
  whereArgs: [todo.id]);
}

}