import 'dart:math';

import 'package:flutter/material.dart';

class Swatches {
  static const _items = <MaterialColor>[
    Colors.pink,
    Colors.red,
    Colors.deepOrange,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.lime,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.lightBlue,
    Colors.blue,
    Colors.indigo,
    Colors.deepPurple,
    Colors.purple,
    Colors.brown,
    Colors.blueGrey,
    Colors.grey,
  ];

  // basics
  static int get count => _items.length;

  static List<MaterialColor> get all => _items;

  static MaterialColor at(int index) => _items[index];

  static int get randomIndex => Random().nextInt(_items.length);
}
