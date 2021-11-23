import 'package:flutter/material.dart';

class SlotModel {
  GlobalKey slotKey = GlobalKey();

  Offset _offset = const Offset(-1, -1);

  getSlotOffset() {
    if (_offset.dx == -1 &&
        _offset.dy == -1 &&
        slotKey.currentContext != null) {
      RenderBox? renderBox =
          slotKey.currentContext!.findRenderObject() as RenderBox?;
      var offset = renderBox!.localToGlobal(Offset.zero);
      _offset = offset;
    }
    return _offset;
  }

  Size? getSlotSize() {
    if (slotKey.currentContext != null) {
      return slotKey.currentContext?.findRenderObject()?.paintBounds.size;
    }
  }
}
