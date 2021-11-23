import 'package:flutter/material.dart';

class ItemModel {
  int val = 0;
  GlobalKey slotKey = GlobalKey();
  GlobalKey itemKey = GlobalKey();
  ItemModel({this.val = 0});

  from(ItemModel item) {
    ItemModel result = ItemModel();
    result.val = item.val;
    result.itemKey = item.itemKey;
    result.slotKey = item.slotKey;
    return result;
  }
}
