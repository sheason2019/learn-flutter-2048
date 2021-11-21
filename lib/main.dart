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
    bool diff = false;
    if (arg == 2 || arg == 8) {
      for (int i = 0; i < newModel.length; i++) {
        // valueA = model[0][i] valueB = model[j][i]
        int pointA = arg == 2 ? 0 : 3;
        for (int j = 1; j < newModel[i].length; j++) {
          int row = arg == 2 ? j : 3 - j;
          if (newModel[row][i] == 0) continue;
          if (newModel[pointA][i] == newModel[row][i]) {
            newModel[pointA][i] *= 2;
            arg == 2 ? pointA++ : pointA--;
            newModel[row][i] = 0;
            diff = true;
          } else if (newModel[pointA][i] != newModel[row][i]) {
            pointA = row;
          }
        }
        for (int j = 0; j < newModel[i].length; j++) {
          int pointB = arg == 8 ? 0 : 3;
          int row = arg == 8 ? j : 3 - j;
          if (newModel[row][i] == 0) {
            while (pointB <= 3 && pointB >= 0) {
              if (newModel[pointB][i] != 0) {
                newModel[row][i] = newModel[pointB][i];
                newModel[pointB][i] = 0;
                diff = true;
                break;
              }
              arg == 8 ? pointB++ : pointB--;
            }
          }
        }
      }
    } else if (arg == 4 || arg == 6) {
      for (int i = 0; i < newModel.length; i++) {
        int pointA = arg == 4 ? 0 : 3;
        for (int j = 1; j < newModel[i].length; j++) {
          int col = arg == 4 ? j : 3 - j;
          if (newModel[i][col] == 0) continue;
          if (newModel[i][pointA] == newModel[i][col]) {
            newModel[i][pointA] *= 2;
            arg == 4 ? pointA++ : pointA--;
            newModel[i][col] = 0;
            diff = true;
          } else if (newModel[i][pointA] != newModel[i][col]) {
            pointA = col;
          }
        }
        for (int j = 0; j < newModel[i].length; j++) {
          int pointB = arg == 6 ? 0 : 3;
          int col = arg == 6 ? j : 3 - j;
          if (newModel[i][col] == 0) {
            while (pointB <= 3 && pointB >= 0) {
              if (newModel[i][pointB] != 0) {
                newModel[i][col] = newModel[i][pointB];
                newModel[i][pointB] = 0;
                diff = true;
                break;
              }
              arg == 6 ? pointB++ : pointB--;
            }
          }
        }
      }
    }

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
    if (diff) {
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
