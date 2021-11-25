import 'package:learn_flutter/gameModel/index.dart';
import 'package:learn_flutter/score/score.dart';

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
}
