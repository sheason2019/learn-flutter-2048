import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameItem extends StatefulWidget {
  final int j;
  const GameItem(this.j, {Key? key}) : super(key: key);

  @override
  _GameItemState createState() => _GameItemState();
}

class _GameItemState extends State<GameItem>
    with SingleTickerProviderStateMixin {
  static Map colorMap = {
    0: Colors.orange[50],
    2: Colors.orange[200],
    4: Colors.orange[300],
    8: Colors.orange[400],
    16: Colors.orange[500],
    32: Colors.orange[600],
    64: Colors.orange[700],
    128: Colors.orange[800],
    256: Colors.orange[900],
  };

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    animation = Tween(begin: 44.0, end: 4.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(covariant GameItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.j == 2) {
      setState(() {
        // _margin = 4.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: Stack(children: [
          Container(
              margin: EdgeInsets.all(animation.value),
              decoration: BoxDecoration(
                  color: colorMap[widget.j],
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Center(
                child: widget.j == 0 ? null : Text(widget.j.toString()),
              )),
        ]));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
