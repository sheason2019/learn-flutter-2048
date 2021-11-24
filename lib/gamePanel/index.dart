import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/gameItem/index.dart';
import 'package:learn_flutter/gameModel/index.dart';
import 'package:learn_flutter/itemModel/index.dart';
import 'package:learn_flutter/itemSlot/index.dart';
import 'package:learn_flutter/slotModel/index.dart';

class GamePanel extends StatefulWidget {
  const GamePanel({Key? key}) : super(key: key);

  @override
  _GamePanelState createState() => _GamePanelState();
}

class _GamePanelState extends State<GamePanel> {
  GameModel model = GameModel();
  Size itemSize = const Size(0, 0);
  List<List<Offset>> slotPosition = [];
  Offset parentOffset = Offset.zero;

  Offset getParentPosition() {
    RenderBox? renderObject = context.findRenderObject() as RenderBox;
    Offset offset = renderObject.localToGlobal(Offset.zero);

    return offset;
  }

  List<List<ItemModel>> move(int arg) {
    List<List<ItemModel>> newModel = [
      ...model.getModel().map((e) => List.from(e))
    ];

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
            col[last] = ItemModel.from(col[last]);
            col[last].val *= 2;
            col[target] = ItemModel.from(col[target]);
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
          newModel[j][i].offset = Offset(j.toDouble(), i.toDouble());
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
            row[last] = ItemModel.from(row[last]);
            row[last].val *= 2;
            row[target] = ItemModel.from(row[target]);
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
          newModel[i][j].offset = Offset(i.toDouble(), j.toDouble());
        }
      }
    }
    bool diff = isModelDiff(newModel, model.getModel());
    if (diff || arg == 0) {
      return insertItem(newModel);
    } else {
      return model.getModel();
    }
  }

  bool isModelDiff(
      List<List<ItemModel>> newModel, List<List<ItemModel>> oldModel) {
    bool diff = false;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (model.getModel()[i][j].val != newModel[i][j].val) {
          diff = true;
        }
      }
    }
    return diff;
  }

  List<List<ItemModel>> insertItem(List<List<ItemModel>> newModel) {
    // 为了在以后实现撤销功能，这里必须实现纯函数，
    List<List<ItemModel>> result = [...newModel.map((e) => List.from(e))];
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
    ItemModel target = result[emptyList[num][0]][emptyList[num][1]] =
        ItemModel.from(newModel[emptyList[num][0]][emptyList[num][1]]);
    target.val = 2;
    return result;
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 0), () {
      List<List<SlotModel>> slotModel = model.getSlotModel();
      List<List<Offset>> _slotPosition = [];
      for (List i in slotModel) {
        List<Offset> row = [];
        for (SlotModel j in i) {
          row.add(j.getSlotOffset());
        }
        _slotPosition.add(row);
      }
      setState(() {
        Size? temp = slotModel[0][0].getSlotSize();
        slotPosition = _slotPosition;
        if (temp == null) return;
        itemSize = Size(temp.width - 8, temp.height - 8);
        model.setModel(move(0));
        parentOffset = getParentPosition();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasMove = true;
    Offset source = const Offset(0, 0);

    List<List<ItemModel>> itemModel = model.getModel();
    List<List<SlotModel>> slotModel = model.getSlotModel();

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
                      for (int i = 0; i < 4; i++)
                        Row(
                          children: [
                            for (int j = 0; j < 4; j++)
                              Expanded(
                                  child: Stack(children: [
                                ItemSlot(
                                  key: slotModel[i][j].slotKey,
                                ),
                              ]))
                          ],
                        )
                    ],
                  ),
                  for (int i = 0; i < 4; i++)
                    for (int j = 0; j < 4; j++)
                      Positioned(
                          left: slotPosition.isEmpty
                              ? 0
                              : slotPosition[itemModel[i][j].offset.dx.toInt()]
                                          [itemModel[i][j].offset.dy.toInt()]
                                      .dx -
                                  parentOffset.dx -
                                  20,
                          top: slotPosition.isEmpty
                              ? 0
                              : slotPosition[itemModel[i][j].offset.dx.toInt()]
                                          [itemModel[i][j].offset.dy.toInt()]
                                      .dy -
                                  parentOffset.dy -
                                  20,
                          width: itemSize.width + 8,
                          height: itemSize.height + 8,
                          child: GameItem(
                            itemModel[i][j].val,
                            key: itemModel[i][j].itemKey,
                            size: itemSize,
                          )),
                ]))));
  }
}
