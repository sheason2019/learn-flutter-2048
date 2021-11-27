class Score {
  static int _score = 0;
  static int getScore() {
    return _score;
  }

  // 这里需要用Function类型的指针指向程序声明的订阅函数
  // ignore: prefer_function_declarations_over_variables
  static Function _subscribe = () {};

  static void initScore() {
    _score = 0;
    _subscribe();
  }

  static void addScore(int val) {
    _score += val;
    _subscribe();
  }

  static void setSubscribe(Function func) {
    _subscribe = func;
  }

  static void setScore(int val) {
    _score = val;
    _subscribe();
  }
}
