import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  final String _tableName = 'tasks';

  Future<void> initDb() async {
    if (_db != null) {
      debugPrint('already exist');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'task.db';
        debugPrint('creating new DB at path: ' + _path);
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          await db.execute('''
CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT
, title STRING
, note TEXT
, date STRING
, startTime STRING
, endTime STRING
, remind INTEGER
, repeat STRING
, color INTEGER
, isCompleted INTEGER)''');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<int> insert(Task task) async {
    debugPrint('DB insert: function called!');
    return await _db!.insert(_tableName, task.toJson());
  }

  Future<int> delete(Task task) async {
    debugPrint('DB delete: function called!');
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> update(Task task) async {
    debugPrint('DB update: function called!');
    return await _db!.rawUpdate('''
    UPDATE $_tableName SET isCompleted = ? WHERE id = ?
    ''', [1, task.id]);
  }

  Future<List<Map<String, dynamic>>> query(Task task) async {
    debugPrint('DB query: function called!');
    return await _db!.query(_tableName);
  }
}
