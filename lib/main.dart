import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('2048'),
        ),
        body: const GamePanel(),
      ),
    );
  }
}

class GamePanel extends StatefulWidget {
  const GamePanel({Key? key}) : super(key: key);

  @override
  _GamePanelState createState() => _GamePanelState();
}

class _GamePanelState extends State<GamePanel> {
  List model = [
    [0, 2, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
  ];

  List move(int arg) {
    List newModel = [...model.map((e) => List.from(e))];
    if (arg == 2 || arg == 8) {
      for (int i = 0; i < 4; i++) {
        List col = [];
        int count = 0;
        bool justMerge = false;
        for (int j = 0; j < 4; j++) {
          if (newModel[j][i] != 0) {
            if (col.indexOf(newModel[j][i]) == col.length - 1 &&
                col.isNotEmpty &&
                !justMerge) {
              col[col.length - 1] *= 2;
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
          col.insert(arg == 2 ? col.length : 0, 0);
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
          if (newModel[i][j] != 0) {
            if (row.indexOf(newModel[i][j]) == row.length - 1 &&
                row.isNotEmpty &&
                !justMerge) {
              row[row.length - 1] *= 2;
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
          row.insert(arg == 4 ? row.length : 0, 0);
        }
        for (int j = 0; j < 4; j++) {
          newModel[i][j] = row[j];
        }
      }
    }
    bool diff = false;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (model[i][j] != newModel[i][j]) {
          diff = true;
        }
      }
    }
    if (diff) {
      List emptyList = [];
      for (int i = 0; i < newModel.length; i++) {
        for (int j = 0; j < newModel[i].length; j++) {
          if (newModel[i][j] == 0) {
            emptyList.add([i, j]);
          }
        }
      }
      var random = Random();
      int num = random.nextInt(emptyList.length);
      newModel[emptyList[num][0]][emptyList[num][1]] = 2;
      return newModel;
    } else {
      return model;
    }
  }

  @override
  void didUpdateWidget(covariant GamePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
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
                  model = move(8);
                });
                hasMove = true;
              } else if (e.localPosition.dy - source.dy < -100) {
                setState(() {
                  model = move(2);
                });
                hasMove = true;
              }
            },
            onHorizontalDragUpdate: (e) {
              if (hasMove) return;
              if (e.localPosition.dx - source.dx > 100) {
                setState(() {
                  model = move(6);
                });
                hasMove = true;
              } else if (e.localPosition.dx - source.dx < -100) {
                setState(() {
                  model = move(4);
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
                child: Column(
                  children: [
                    for (var i in model)
                      Row(
                        children: [
                          for (var j in i) Expanded(child: gameItem(j))
                        ],
                      )
                  ],
                ))));
  }

  static Map colorMap = {
    0: 50,
    2: 200,
    4: 300,
    8: 400,
    16: 500,
    32: 600,
    64: 700
  };

  Widget gameItem(int j) {
    return AspectRatio(
        aspectRatio: 1,
        child: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: Colors.orange[colorMap[j]],
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Center(
              child: j == 0 ? null : Text(j.toString()),
            )));
  }
}
