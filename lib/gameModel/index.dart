import 'dart:math';

import 'package:learn_flutter/itemModel/index.dart';
import 'package:learn_flutter/slotModel/index.dart';

class GameModel {
  List _model = [];
  List _slotModel = [];

  GameModel() {
    for (int i = 0; i < 4; i++) {
      List row = [];
      List slotRow = [];
      for (int j = 0; j < 4; j++) {
        row.add(ItemModel());
        slotRow.add(SlotModel());
      }
      _model.add(row);
      _slotModel.add(slotRow);
    }
  }
  from(GameModel model) {
    return [...model.getModel().map((e) => List.from(e))];
  }

  getModel() {
    return _model;
  }

  setModel(model) {
    _model = model;
  }
}
