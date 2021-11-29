import 'package:flutter/material.dart';

class StableGameItem extends StatelessWidget {
  final int val;
  const StableGameItem({Key? key, required this.val}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: val == 0 ? null : colorMap[val],
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Center(
              child: val == 0
                  ? null
                  : Text(
                      val.toString(),
                      style: const TextStyle(
                          fontSize: 32, color: Color(0xDFFFFFFF)),
                    ),
            )));
  }
}
