import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn_flutter/itemModel/index.dart';
import 'package:learn_flutter/score/score.dart';
import 'package:learn_flutter/slotModel/index.dart';

class GameModel {
  List<List<ItemModel>> _model = [];
  List<List<SlotModel>> _slotModel = [];
  // 唯一的实例，方便外部调用
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
    // 其实这里应该解耦到一个动画模型列表以实现数据分离，在build函数里合并它和Model以实现数据模型单一职责原则的
    // 但是当时没有想到这么多
    _model.add([]);
  }

  GameModel() {
    init();
    instance = this;
  }

  List<List<ItemModel>> getModel() {
    return _model;
  }

  void setModelFromPureData(List<List<int>> data) {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        _model[i][j].val = data[i][j];
      }
    }
    _model[4] = [];
  }

  static List<List<int>> _getModelCore(List<List<ItemModel>> _model) {
    List<List<int>> temp = [];
    for (int i = 0; i < 4; i++) {
      List<int> row = [];
      for (int j = 0; j < 4; j++) {
        row.add(_model[i][j].val);
      }
      temp.add(row);
    }
    return temp;
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

  Map<String, Object?> pack() {
    return {
      'model': json.encode(_getModelCore(_model)),
      'score': Score.getScore(),
    };
  }
}
