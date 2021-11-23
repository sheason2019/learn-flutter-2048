import 'package:flutter/material.dart';

class ItemSlot extends StatelessWidget {
  const ItemSlot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: Stack(children: [
          Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: const BorderRadius.all(Radius.circular(8))),
          ),
        ]));
  }
}
