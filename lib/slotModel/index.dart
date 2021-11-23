import 'package:flutter/material.dart';

class SlotModel {
  GlobalKey slotKey = GlobalKey();

  getSlotOffset() {
    RenderBox? renderBox =
        slotKey.currentContext!.findRenderObject() as RenderBox?;
    var offset = renderBox!.localToGlobal(Offset.zero);
    print(offset);
    return [offset.dx, offset.dy];
  }
}
