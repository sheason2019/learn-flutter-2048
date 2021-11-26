import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameItem extends StatefulWidget {
  final int j;
  final Size size;
  const GameItem(this.j, {Key? key, required this.size}) : super(key: key);

  @override
  _GameItemState createState() => _GameItemState();
}

class _GameItemState extends State<GameItem>
    with SingleTickerProviderStateMixin {
  static Map colorMap = {
    2: Colors.orange[200],
    4: Colors.orange[300],
    8: Colors.orange[400],
    16: Colors.orange,
    32: Colors.orange[600],
    64: Colors.orange[700],
    128: Colors.orange[800],
    256: Colors.deepOrange[400],
    512: Colors.deepOrange[500],
    1024: Colors.deepOrange[600],
    2048: Colors.deepOrange[700],
    4096: Colors.deepOrange[800],
    8192: Colors.deepOrange[900],
    16384: Colors.red[700],
    32768: Colors.red[800],
  };

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
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
    return Transform.scale(
        scale: animation.value,
        child: AspectRatio(
            aspectRatio: 1,
            child: Stack(children: [
              Container(
                  margin: const EdgeInsets.all(5.0),
                  height: widget.size.height,
                  width: widget.size.width,
                  decoration: BoxDecoration(
                      color: widget.j == 0 ? null : colorMap[widget.j],
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: Center(
                    child: widget.j == 0
                        ? null
                        : Text(
                            widget.j.toString(),
                            style: const TextStyle(
                                fontSize: 32, color: Color(0xDFFFFFFF)),
                          ),
                  )),
            ])));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
