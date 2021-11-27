import 'package:flutter/material.dart';
import 'package:learn_flutter/itemModel/index.dart';
import 'package:learn_flutter/score/score.dart';
import 'package:learn_flutter/slotModel/index.dart';

class GameModel {
  List<List<ItemModel>> _model = [];
  List<List<SlotModel>> _slotModel = [];
  // 历史模型的状态储存在这个数组里，以实现UNDO效果
  List<List<List<int>>> history_model = [];
  List<int> history_score = [];
  // 在初始化GmaeModel时会将实例放到这里方便获取，其实应该放到GameController里面的，但是一开始
  // 就在这里建立了一个instance，为了避免不必要的操作，等到后续有空的时候再改吧
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

  undo() {
    if (history_model.length > 1) {
      List<List<int>> lastModel =
          history_model.removeAt(history_model.length - 1);
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          _model[i][j].val = lastModel[i][j];
        }
      }
      _model[4] = [];
    }
    Score.setScore(history_score.removeAt(history_score.length - 1));
  }

  setModel(List<List<ItemModel>> model) {
    List<List<int>> temp = [];
    for (int i = 0; i < 4; i++) {
      List<int> row = [];
      for (int j = 0; j < 4; j++) {
        row.add(_model[i][j].val);
      }
      temp.add(row);
    }
    history_model.add(temp);
    history_score.add(Score.getScore());
    _model = model;
  }

  getSlotModel() {
    return _slotModel;
  }

  setSlotModel(slotModel) {
    _slotModel = slotModel;
  }
}
