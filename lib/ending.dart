import 'package:flutter/material.dart';
import 'package:learn_flutter/history_card.dart';

class Ending extends StatelessWidget {
  final int score;
  final List<List<int>> model;
  const Ending({
    Key? key,
    required this.score,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2048 - 游戏结束'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        child: Container(
            color: const Color(0xFFE5E5E5),
            child: Column(
              children: [
                HistoryCard(model: model, score: score),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('开始新的游戏'),
                )
              ],
            )),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }
}
