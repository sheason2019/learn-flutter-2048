import 'package:flutter/material.dart';
import 'package:learn_flutter/score/score.dart';

class ScoreWidget extends StatefulWidget {
  @override
  _ScoreWidgetState createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  @override
  void initState() {
    super.initState();
    Score.setSubscribe(() {
      setState(() {
        // 这里会将fream标记为脏，从而刷新获取最新得分
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width - 32;

    return Container(
        width: containerWidth,
        margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: Row(children: [
          Expanded(
              flex: 6,
              child: Container(
                alignment: Alignment.center,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xFFFFCC80)),
                child: Text('得分： ' + Score.getScore().toString()),
              )),
          Expanded(
              flex: 1,
              child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xFFFFCC80),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Menu'),
                  )))
        ]));
  }
}
