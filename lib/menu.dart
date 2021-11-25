import 'package:flutter/material.dart';
import 'package:learn_flutter/gameModel/index.dart';
import 'package:learn_flutter/game_controller.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("2048"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MenuButton(
            width: windowWidth / 5 * 3,
            text: '回到游戏',
            onPress: () {
              Navigator.pop(context);
            },
          ),
          MenuButton(
            width: windowWidth / 5 * 3,
            text: '重新开始',
            onPress: () {
              GameController.restart();
              Navigator.pop(context);
            },
          ),
          MenuButton(
            width: windowWidth / 5 * 3,
            text: '历史记录',
            onPress: () {},
          ),
        ],
      )),
    );
  }
}

class MenuButton extends StatelessWidget {
  final double width;
  final String text;
  final Function onPress;
  const MenuButton(
      {Key? key,
      required this.width,
      required this.text,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(16),
        child: MaterialButton(
          onPressed: () {
            onPress();
          },
          color: Colors.orange[200],
          child: SizedBox(
              width: width,
              height: 0.309 * width,
              child: Center(child: Text(text))),
        ));
  }
}
