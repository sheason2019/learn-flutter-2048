import 'package:flutter/material.dart';

class ItemModel {
  int val;
  GlobalKey itemKey = GlobalKey();
  Offset offset;
  ItemModel({this.val = 0, this.offset = Offset.zero});

  static from(ItemModel item) {
    ItemModel result = ItemModel();
    result.val = item.val;
    result.itemKey = item.itemKey;
    result.offset = item.offset;
    return result;
  }
}
