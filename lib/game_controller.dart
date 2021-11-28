import 'dart:convert';
import 'dart:io';

import 'package:learn_flutter/gameModel/index.dart';
import 'package:learn_flutter/score/score.dart';
import 'package:path_provider/path_provider.dart';

class GameController {
  // ignore: prefer_function_declarations_over_variables
  static Function _refreshFunc = () {};

  static void registRefreshFunc(Function func) {
    _refreshFunc = func;
  }

  static void restart() {
    GameModel.instance?.init();
    _refreshFunc();
    Score.initScore();
  }

  static void undo() {
    GameModel.instance?.undo();
    _refreshFunc(insert: false);
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _historyModelFile async {
    final path = await _localPath;
    return File('$path/model.json');
  }

  static writeModel(Map modelMap) async {
    final file = await _historyModelFile;
    return file.writeAsString(json.encode(modelMap));
  }

  static Future<Map?> readModel() async {
    Map? result;
    try {
      final file = await _historyModelFile;
      final contents = await file.readAsString();
      result = json.decode(contents);
    } catch (e) {
      result = null;
    }
    return result;
  }
}
