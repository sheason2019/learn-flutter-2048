import 'package:flutter/material.dart';
import 'package:learn_flutter/itemModel/index.dart';
import 'package:learn_flutter/slotModel/index.dart';

class GameModel {
  List<List<ItemModel>> _model = [];
  List<List<SlotModel>> _slotModel = [];
  static GameModel? instance;

  void init({bool restart = false}) {
    _model = [];
    _slotModel = restart ? _slotModel : [];
    for (int i = 0; i < 4; i++) {
      List<ItemModel> row = [];
      List<SlotModel> slotRow = [];
      for (int j = 0; j < 4; j++) {
        row.add(ItemModel(offset: Offset(i.toDouble(), j.toDouble())));
        restart ? null : slotRow.add(SlotModel());
      }
      _model.add(row);
      restart ? null : _slotModel.add(slotRow);
    }
    // 这一行是cache，用来实现合并动画
    _model.add([]);
  }

  GameModel() {
    init();
    instance = this;
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
