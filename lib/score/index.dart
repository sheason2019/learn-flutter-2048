import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learn_flutter/game_controller.dart';
import 'package:learn_flutter/menu.dart';
import 'package:learn_flutter/score/score.dart';

class ScoreWidget extends StatefulWidget {
  const ScoreWidget({Key? key}) : super(key: key);

  @override
  _ScoreWidgetState createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  GlobalKey containerKey = GlobalKey();
  double itemHeight = 0;

  @override
  void initState() {
    super.initState();
    Score.setSubscribe(() {
      setState(() {
        // 这里会将fream标记为脏，从而刷新获取最新得分
      });
    });
    getHeight();
  }

  void getHeight() {
    Timer(const Duration(milliseconds: 100), () {
      Size? temp = containerKey.currentContext?.size;
      if (temp != null) {
        setState(() {
          itemHeight = temp.height - 8;
        });
      } else {
        getHeight();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width - 32;

    const titleStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16);
    const scoreStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22);
    const buttonColor = Color(0xFFF75e3e);
    const buttonTextStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20);

    return Container(
        width: containerWidth,
        margin: const EdgeInsets.all(16),
        child: Row(children: [
          Expanded(
              flex: 1,
              key: containerKey,
              child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color(0xFFECCC5F)),
                    child: const Text('2048',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5)),
                  ))),
          Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                      height: itemHeight / 7 * 4,
                      width: itemHeight + 8,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Color(0xFF3D3A33)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'SCORE',
                              style: titleStyle,
                            ),
                            Text(Score.getScore().toString(),
                                style: scoreStyle),
                          ]),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const MenuWidget();
                          }));
                        },
                        child: Container(
                            width: itemHeight + 8,
                            height: itemHeight / 7 * 3,
                            margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: buttonColor,
                              ),
                              alignment: Alignment.center,
                              child: const Text('Menu', style: buttonTextStyle),
                            ))),
                  ])),
          Expanded(
              flex: 1,
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  height: itemHeight / 7 * 4,
                  width: itemHeight + 8,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xFF3D3A33)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('BEST', style: titleStyle),
                        Text(Score.getScore().toString(), style: scoreStyle),
                      ]),
                ),
                GestureDetector(
                    onTap: () {
                      GameController.undo();
                    },
                    child: Container(
                      height: itemHeight / 7 * 3,
                      width: itemHeight + 8,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: buttonColor),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('UNDO', style: buttonTextStyle)
                          ]),
                    )),
              ]))
        ]));
  }
}
