import 'package:flutter/material.dart';
import 'package:learn_flutter/history_card.dart';

import 'game_controller.dart';

class HistoryRecords extends StatefulWidget {
  const HistoryRecords({Key? key}) : super(key: key);

  @override
  _HistoryRecordsState createState() => _HistoryRecordsState();
}

class _HistoryRecordsState extends State<HistoryRecords> {
  List<Map> records = [];

  _setRecords() async {
    List<Map> newRecords = await GameController.getHistoryRecords();
    setState(() {
      records = newRecords;
    });
  }

  @override
  initState() {
    super.initState();
    _setRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2048 - 历史记录'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          for (int i = 0; i < records.length; i++)
            HistoryRecordItem(record: records[i], rank: i + 1),
        ],
      ),
    );
  }
}

class HistoryRecordItem extends StatelessWidget {
  final Map record;
  final int rank;
  const HistoryRecordItem({Key? key, required this.record, required this.rank})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> timeList =
        DateTime.fromMillisecondsSinceEpoch(int.parse(record["time"]))
            .toIso8601String()
            .split(RegExp(r"[T\.]"));
    String timeStr = timeList.sublist(0, 2).join(" ");

    return Container(
        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HistoryRecordDetail(
                  record: record,
                );
              }));
            },
            child: Card(
                color: const Color(0xFFFFCC80),
                elevation: 2,
                child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              height: 56,
                              width: 56,
                              child: Center(
                                  child: Text(
                                rank.toString(),
                                style: const TextStyle(fontSize: 24),
                              ))),
                          SizedBox(
                            height: 56,
                            child: Center(
                                child: Text(
                                    "SCORE: " + record["score"].toString())),
                          ),
                          SizedBox(
                            height: 56,
                            child: Center(child: Text(timeStr)),
                          ),
                          Container(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: const RotatedBox(
                                  quarterTurns: 2,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Icon(
                                      IconData(0xee83,
                                          fontFamily: "MaterialIcons"),
                                    ),
                                  )))
                        ],
                      ),
                    ])))));
  }
}

class HistoryRecordDetail extends StatelessWidget {
  final Map record;
  const HistoryRecordDetail({
    required this.record,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('游戏详情'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          HistoryCard(
              model: GameController.parseStringToModel(record["model"]),
              score: record["score"])
        ],
      ),
    );
  }
}
