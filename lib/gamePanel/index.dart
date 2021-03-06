import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/constants.dart';
import 'package:learn_flutter/gameItem/index.dart';
import 'package:learn_flutter/gameModel/index.dart';
import 'package:learn_flutter/game_controller.dart';
import 'package:learn_flutter/itemModel/index.dart';
import 'package:learn_flutter/itemSlot/index.dart';
import 'package:learn_flutter/score/score.dart';
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

  bool _init = false;

  void undo() {
    setState(() {
      // GameModel类内部会对model进行操作
    });
  }

  Offset getParentPosition() {
    RenderBox? renderObject = context.findRenderObject() as RenderBox;
    Offset offset = renderObject.localToGlobal(Offset.zero);

    return offset;
  }

  List<List<ItemModel>> move(int arg) {
    List<List<ItemModel>> newModel = [
      ...model.getModel().map((e) => List.from(e))
    ];
    newModel[4] = [];
    int addScore = 0;

    if (arg == 2 || arg == 8) {
      for (int i = 0; i < 4; i++) {
        List<ItemModel> col = [];
        List<List<ItemModel>> mergeList = [];
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
            mergeList.add([col[target], col[last]]);
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
        // 合并动画
        for (int j = 0; j < mergeList.length; j++) {
          mergeList[j][1].val = mergeList[j][1].val ~/ 2;
          mergeList[j][0].val = mergeList[j][1].val;
          mergeList[j][0].offset = mergeList[j][1].offset;
          newModel[4].add(mergeList[j][0]);
          addScore += mergeList[j][1].val;
          Timer(CONSTANTS.moveDuration, () {
            mergeList[j][1].val *= 2;
            setState(() {});
          });
        }
      }
    } else if (arg == 4 || arg == 6) {
      for (int i = 0; i < 4; i++) {
        List<ItemModel> row = [];
        List<List<ItemModel>> mergeList = [];
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
            mergeList.add([row[target], row[last]]);
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
        for (int j = 0; j < mergeList.length; j++) {
          mergeList[j][1].val = mergeList[j][1].val ~/ 2;
          mergeList[j][0].val = mergeList[j][1].val;
          mergeList[j][0].offset = mergeList[j][1].offset;
          newModel[4].add(mergeList[j][0]);
          addScore += mergeList[j][1].val;
          Timer(CONSTANTS.moveDuration, () {
            mergeList[j][1].val *= 2;
            setState(() {});
          });
        }
      }
    }
    Timer(CONSTANTS.moveDuration, () {
      // 存储数据到本地
      GameController.writeModel(model.pack());
      Score.addScore(addScore);
    });
    return newModel;
  }

  // 原本想通过修改move函数对能否移动进行判断的，但因为动画之类的缘故move的耦合度太高了
  // 一时间也不知道怎么把它拆开，索性写了个新函数对能否移动进行判断
  bool canMove() {
    List<List<int>> data = GameModel.getModelCore(model.getModel());
    for (int i = 0; i < 4; i++) {
      int lastValCol = 0, lastValRow = 0;
      for (int j = 0; j < 4; j++) {
        // 检测合并
        if (data[j][i] != 0) {
          if (lastValCol == data[j][i]) {
            return true;
          } else {
            lastValCol = data[j][i];
          }
        } else {
          return true;
        }
        if (data[i][j] != 0) {
          if (lastValRow == data[i][j]) {
            return true;
          } else {
            lastValRow = data[i][j];
          }
        } else {
          return true;
        }
      }
    }
    return false;
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
    Timer(const Duration(milliseconds: 100), () {
      // 获取slot的位置
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
        parentOffset = getParentPosition();
      });
      Timer(const Duration(milliseconds: 100), () async {
        Map? lastModelMap = await GameController.readModel();
        if (lastModelMap == null) {
          setState(() {
            model.setModel(insertItem(model.getModel()));
            _init = true;
          });
        } else {
          setState(() {
            // 复原model
            model.setModelFromPureData(
                GameController.parseStringToModel(lastModelMap["model"]));
            //复原分数
            Score.setScore(lastModelMap["score"]);

            _init = true;
          });
        }
      });
    });
    GameController.registRefreshFunc(({bool insert = true}) {
      if (insert) {
        model.setModel(insertItem(model.getModel()));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasMove = true;
    Offset source = const Offset(0, 0);

    List<List<ItemModel>> itemModel = model.getModel();
    List<List<SlotModel>> slotModel = model.getSlotModel();

    int moveLimit = 30;

    if (_init) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!canMove() && !GameController.ended) {
          Future.delayed(Duration.zero, () {
            GameController.end(context);
          });
          GameController.ended = true;
        }
      });
    }

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
              List<List<ItemModel>> newModel = model.getModel();
              if (e.localPosition.dy - source.dy > moveLimit) {
                newModel = move(8);
              } else if (e.localPosition.dy - source.dy < -moveLimit) {
                newModel = move(2);
              }
              if (isModelDiff(newModel, model.getModel())) {
                hasMove = true;
                setState(() {
                  model.setModel(insertItem(newModel));
                });
              }
            },
            onHorizontalDragUpdate: (e) {
              if (hasMove) return;
              List<List<ItemModel>> newModel = model.getModel();
              if (e.localPosition.dx - source.dx > moveLimit) {
                newModel = move(6);
              } else if (e.localPosition.dx - source.dx < -moveLimit) {
                newModel = move(4);
              }
              if (isModelDiff(newModel, model.getModel())) {
                hasMove = true;
                setState(() {
                  model.setModel(insertItem(newModel));
                });
              }
            },
            child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: RepaintBoundary(
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
                  for (int i = itemModel.length - 1; i >= 0; i--)
                    for (int j = 0; j < itemModel[i].length; j++)
                      AnimatedPositioned(
                          duration: CONSTANTS.moveDuration,
                          curve: Curves.linear,
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
                          key: itemModel[i][j].itemKey,
                          child: GameItem(
                            itemModel[i][j].val,
                            size: itemSize,
                          )),
                ])))));
  }
}
