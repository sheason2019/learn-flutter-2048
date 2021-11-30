import 'package:learn_flutter/game_controller.dart';

class Score {
  static int _score = 0;
  static int _bestScore = 0;
  static int getScore() {
    return _score;
  }

  static int getBestScore() {
    return _bestScore;
  }

  // 这里需要用Function类型的指针指向程序声明的订阅函数
  // ignore: prefer_function_declarations_over_variables
  static Function _subscribe = () {};

  static void initScore() async {
    _score = 0;
    _bestScore = await GameController.getBestScore();
    _subscribe();
  }

  static void addScore(int val) async {
    _score += val;
    _bestScore = await GameController.getBestScore();
    _subscribe();
  }

  static void setSubscribe(Function func) {
    _subscribe = func;
  }

  static void setScore(int val) async {
    _score = val;
    _bestScore = await GameController.getBestScore();
    _subscribe();
  }
}
