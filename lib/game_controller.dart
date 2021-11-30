import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:learn_flutter/ending.dart';
import 'package:learn_flutter/gameModel/index.dart';
import 'package:learn_flutter/score/score.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import './ending.dart';

class GameController {
  // ignore: prefer_function_declarations_over_variables
  static Function _refreshFunc = () {};
  static bool ended = false;

  static void registRefreshFunc(Function func) {
    _refreshFunc = func;
  }

  static void restart() async {
    final Database db = await getDatabase();
    writeRecord();
    // 删除该局的历史操作记录
    await db.delete("models");

    GameModel.instance?.init();
    _refreshFunc();
    writeModel(GameModel.instance?.pack() as Map<String, Object?>);
    Score.initScore();
  }

  static void undo() async {
    final Database db = await getDatabase();
    List<Map> query = await db.query("models");
    ended = false;
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
      version: 1,
    );
    return database;
  }

  // 数据库完整性检查
  static checkDatabase() async {
    final Database db = await getDatabase();
    List<Map> records = await db.query('sqlite_master');
    Map<String, bool> checkMap = {"models": false, "historys": false};
    for (Map item in records) {
      if (checkMap.containsKey(item['name'])) {
        checkMap[item['name']] = true;
      }
    }
    checkMap.forEach((table, exist) {
      if (!exist) {
        switch (table) {
          case 'models':
            db.execute(
                'CREATE TABLE models(step INTEGER PRIMARY KEY, model TEXT, score number);');
            break;
          case 'historys':
            db.execute(
                'CREATE TABLE historys(id INTEGER PRIMARY KEY, model TEXT, score number, time TEXT);');
            break;
        }
      }
    });
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

  static void writeRecord() async {
    final Database db = await getDatabase();
    // 将本局的最终结果写入history记录里
    await db.insert('historys', {
      "model":
          json.encode(GameModel.getModelCore(GameModel.instance!.getModel())),
      "score": Score.getScore(),
      "time": DateTime.now().millisecondsSinceEpoch,
    });
  }

  static void end(BuildContext context) {
    writeRecord();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Ending(
          score: Score.getScore(),
          model: GameModel.getModelCore(GameModel.instance!.getModel()));
    }));
  }

  static Future<List<Map>> getHistoryRecords() async {
    final Database db = await getDatabase();
    List<Map> records = await db.query('historys', orderBy: "score desc");
    return records;
  }

  static Future<int> getBestScore() async {
    final Database db = await getDatabase();
    List<Map> records =
        await db.query('historys', orderBy: "score desc", limit: 1);
    return max(records.first["score"], Score.getScore());
  }
}
