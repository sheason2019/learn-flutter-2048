import 'dart:math';

import 'package:flutter/material.dart';
import 'package:learn_flutter/itemModel/index.dart';
import 'package:learn_flutter/slotModel/index.dart';

class GameModel {
  List<List<ItemModel>> _model = [];
  List<List<SlotModel>> _slotModel = [];

  GameModel() {
    for (int i = 0; i < 4; i++) {
      List<ItemModel> row = [];
      List<SlotModel> slotRow = [];
      for (int j = 0; j < 4; j++) {
        row.add(ItemModel(offset: Offset(i.toDouble(), j.toDouble())));
        slotRow.add(SlotModel());
      }
      _model.add(row);
      _slotModel.add(slotRow);
    }
  }
  from(GameModel model) {
    return [...model.getModel().map((e) => List.from(e))];
  }

  List<List<ItemModel>> getModel() {
    return _model;
  }

  setModel(List<List<ItemModel>> model) {
    _model = model;
  }

  getSlotModel() {
    return _slotModel;
  }

  setSlotModel(slotModel) {
    _slotModel = slotModel;
  }
}
