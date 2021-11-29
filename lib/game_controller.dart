import 'dart:convert';

import 'package:learn_flutter/gameModel/index.dart';
import 'package:learn_flutter/score/score.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GameController {
  // ignore: prefer_function_declarations_over_variables
  static Function _refreshFunc = () {};

  static void registRefreshFunc(Function func) {
    _refreshFunc = func;
  }

  static void restart() async {
    GameModel.instance?.init();
    final Database db = await getDatabase();
    db.delete("models");

    _refreshFunc();
    writeModel(GameModel.instance?.pack() as Map<String, Object?>);
    Score.initScore();
  }

  static void undo() async {
    final Database db = await getDatabase();
    List<Map> query = await db.query("models");
    if (query.length <= 1) return;
    await db.delete('models', where: "step in (select max(step) from models)");

    Map lastModel = await readModel() ?? {};
    Score.setScore(lastModel["score"]);
    GameModel.instance
        ?.setModelFromPureData(parseStringToModel(lastModel["model"]));
    _refreshFunc(insert: false);
  }

  static getDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), '2048'),
      onCreate: (db, _verison) {
        return db.execute(
            'CREATE TABLE models(step INTEGER PRIMARY KEY, model TEXT, score number)');
      },
      version: 1,
    );
    return database;
  }

  static void writeModel(Map<String, Object?> modelMap) async {
    final db = await getDatabase();
    await db.insert('models', modelMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Map?> readModel() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query('models', orderBy: "step desc");
    return maps.first;
  }

  static List<List<int>> parseStringToModel(String str) {
    final _model = json.decode(str);
    List<List<int>> lastModel = [];
    for (int i = 0; i < 4; i++) {
      List<int> row = [];
      for (int j = 0; j < 4; j++) {
        row.add(_model[i][j]);
      }
      lastModel.add(row);
    }
    return lastModel;
  }
}
