import 'package:flutter/material.dart';

class ItemModel {
  int val = 0;
  // GlobalKey slotKey = GlobalKey();
  ItemModel({this.val = 0});

  from({val}) {
    return ItemModel(val: val);
  }
}