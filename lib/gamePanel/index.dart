import 'dart:math';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/gameItem/index.dart';
import 'package:learn_flutter/gameModel/index.dart';
import 'package:learn_flutter/itemModel/index.dart';
import 'package:learn_flutter/itemSlot/index.dart';

class GamePanel extends StatefulWidget {
  const GamePanel({Key? key}) : super(key: key);

  @override
  _GamePanelState createState() => _GamePanelState();
}

class _GamePanelState extends State<GamePanel> {
  GameModel model = GameModel();
  bool _init = true;

  List move(int arg) {
    List newModel = [...model.getModel().map((e) => List.from(e))];
    if (arg == 2 || arg == 8) {
      for (int i = 0; i < 4; i++) {
        List<ItemModel> col = [];
        // 清除为0的项
        for (int j = 0; j < 4; j++) {
          if (newModel[j][i].val != 0) {
            col.add(newModel[j][i]);
          }
        }
        // 进行相加操作
        for (int j = 0; j < col.length; j++) {
          int target = arg == 2 ? j : col.length - 1 - j;
          int last = arg == 2 ? target - 1 : target + 1;
          if (last < 0 || last > col.length - 1) continue;
          if (col[target].val == col[last].val) {
            col[last] = col[last].from(col[last]);
            col[last].val *= 2;
            col[target] = col[target].from(col[target]);
            col[target].val = 0;
          }
        }
        // 再次清除为0的项
        List colWithoutZero = [];
        for (int j = 0; j < col.length; j++) {
          if (col[j].val != 0) {
            colWithoutZero.add(col[j]);
          }
        }
        // 插入为0的项
        int loopCount = 4 - colWithoutZero.length;
        for (int j = 0; j < loopCount; j++) {
          colWithoutZero.insert(
              arg == 2 ? colWithoutZero.length : 0, ItemModel(val: 0));
        }
        // 合并到newModel
        for (int j = 0; j < 4; j++) {
          newModel[j][i] = colWithoutZero[j];
        }
      }
    } else if (arg == 4 || arg == 6) {
      for (int i = 0; i < newModel.length; i++) {
        List<ItemModel> row = [];
        for (int j = 0; j < 4; j++) {
          if (newModel[i][j].val != 0) {
            row.add(newModel[i][j]);
          }
        }
        for (int j = 0; j < row.length; j++) {
          int target = arg == 4 ? j : row.length - 1 - j;
          int last = arg == 4 ? target - 1 : target + 1;
          if (last < 0 || last > row.length - 1) continue;
          if (row[target].val == row[last].val) {
            row[last] = row[last].from(row[last]);
            row[last].val *= 2;
            row[target] = row[target].from(row[target]);
            row[target].val = 0;
          }
        }
        List rowWithoutZero = [];
        for (int j = 0; j < row.length; j++) {
          if (row[j].val != 0) {
            rowWithoutZero.add(row[j]);
          }
        }
        int loopCount = 4 - rowWithoutZero.length;
        for (int j = 0; j < loopCount; j++) {
          rowWithoutZero.insert(
              arg == 4 ? rowWithoutZero.length : 0, ItemModel(val: 0));
        }
        for (int j = 0; j < 4; j++) {
          newModel[i][j] = rowWithoutZero[j];
        }
      }
    }
    bool diff = false;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (model.getModel()[i][j].val != newModel[i][j].val) {
          diff = true;
        }
      }
    }
    if (diff || arg == 0) {
      List emptyList = [];
      for (int i = 0; i < newModel.length; i++) {
        for (int j = 0; j < newModel[i].length; j++) {
          if (newModel[i][j].val == 0) {
            emptyList.add([i, j]);
          }
        }
      }
      var random = Random();
      int num = random.nextInt(emptyList.length);
      newModel[emptyList[num][0]][emptyList[num][1]] = ItemModel(val: 2);
      return newModel;
    } else {
      return model.getModel();
    }
  }

  @override
  void didUpdateWidget(covariant GamePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    if (_init) {
      setState(() {
        model.setModel(move(0));
      });
      _init = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasMove = true;
    Offset source = const Offset(0, 0);

    return AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
            onVerticalDragStart: (e) {
              source = e.localPosition;
              hasMove = false;
            },
            onHorizontalDragStart: (e) {
              source = e.localPosition;
              hasMove = false;
            },
            onVerticalDragUpdate: (e) {
              if (hasMove) return;
              if (e.localPosition.dy - source.dy > 100) {
                setState(() {
                  model.setModel(move(8));
                });
                hasMove = true;
              } else if (e.localPosition.dy - source.dy < -100) {
                setState(() {
                  model.setModel(move(2));
                });
                hasMove = true;
              }
            },
            onHorizontalDragUpdate: (e) {
              if (hasMove) return;
              if (e.localPosition.dx - source.dx > 100) {
                setState(() {
                  model.setModel(move(6));
                });
                hasMove = true;
              } else if (e.localPosition.dx - source.dx < -100) {
                setState(() {
                  model.setModel(move(4));
                });
                hasMove = true;
              }
            },
            child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Stack(children: [
                  Column(
                    children: [
                      for (var i in model.getModel())
                        Row(
                          children: [
                            for (var j in i)
                              Expanded(
                                  child: Stack(children: [
                                const ItemSlot(),
                                GameItem(j.val, key: j.itemKey),
                              ]))
                          ],
                        )
                    ],
                  )
                ]))));
  }
}
