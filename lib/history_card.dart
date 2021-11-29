import 'package:flutter/material.dart';
import 'package:learn_flutter/gameItem/stable_game_item.dart';
import 'package:learn_flutter/score/score.dart';

import 'itemSlot/index.dart';

class HistoryCard extends StatelessWidget {
  final int score;
  final List<List<int>> model;
  const HistoryCard({Key? key, required this.model, required this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16);
    const scoreStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22);
    return Transform.scale(
        scale: 0.85,
        child: Card(
          margin: const EdgeInsets.all(8),
          elevation: 3,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                    padding: const EdgeInsets.all(4),
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
                          Text(score.toString(), style: scoreStyle),
                        ]),
                  )),
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.fromLTRB(8, 16, 16, 0),
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color(0xFF3D3A33)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'BEST',
                            style: titleStyle,
                          ),
                          Text(Score.getScore().toString(), style: scoreStyle),
                        ]),
                  )),
                ],
              ),
              AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Stack(children: [
                        Column(
                          children: [
                            for (int i = 0; i < 4; i++)
                              Row(
                                children: [
                                  for (int j = 0; j < 4; j++)
                                    Expanded(
                                      child: model[i][j] == 0
                                          ? const ItemSlot()
                                          : StableGameItem(val: model[i][j]),
                                    )
                                ],
                              )
                          ],
                        ),
                      ])))
            ],
          ),
        ));
  }
}
