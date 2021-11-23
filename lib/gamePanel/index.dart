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
        List col = [];
        int count = 0;
        bool justMerge = false;
        for (int j = 0; j < 4; j++) {
          if (newModel[j][i].val != 0) {
            bool shouldMerge = false;
            if (col.isNotEmpty) {
              if (col[col.length - 1].val == newModel[j][i].val) {
                shouldMerge = true;
              }
            }
            if (shouldMerge && !justMerge) {
              col[col.length - 1].val *= 2;
              count++;
              justMerge = true;
              continue;
            } else {
              col.add(newModel[j][i]);
            }
            justMerge = false;
          } else {
            count++;
          }
        }
        for (int j = 0; j < count; j++) {
          col.insert(arg == 2 ? col.length : 0, ItemModel(val: 0));
        }
        for (int j = 0; j < 4; j++) {
          newModel[j][i] = col[j];
        }
      }
    } else if (arg == 4 || arg == 6) {
      for (int i = 0; i < newModel.length; i++) {
        List row = [];
        int count = 0;
        bool justMerge = false;
        for (int j = 0; j < 4; j++) {
          if (newModel[i][j].val != 0) {
            bool shouldMerge = false;
            if (row.isNotEmpty) {
              if (row[row.length - 1].val == newModel[i][j].val) {
                shouldMerge = true;
              }
            }
            if (shouldMerge && !justMerge) {
              row[row.length - 1].val *= 2;
              count++;
              justMerge = true;
              continue;
            } else {
              row.add(newModel[i][j]);
            }
            justMerge = false;
          } else {
            count++;
          }
        }
        for (int j = 0; j < count; j++) {
          row.insert(arg == 4 ? row.length : 0, ItemModel(val: 0));
        }
        for (int j = 0; j < 4; j++) {
          newModel[i][j] = row[j];
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
                                GameItem(j.val),
                              ]))
                          ],
                        )
                    ],
                  )
                ]))));
  }
}
