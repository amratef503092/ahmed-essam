import 'dart:math';

import 'package:flutter/material.dart';

class RandomClass {
  RandomClass._instac();
  static final List<Color> backgroundColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.yellow,
  ];

  static final List<Color> textColors = [
    Colors.white,
    Colors.black,
    Colors.white,
    Colors.black,
    Colors.white,
    Colors.black,
    Colors.white,
  ];

  static final Random random = Random();

  static Color get randomColor =>
      backgroundColors[random.nextInt(backgroundColors.length)];

  static Color randomTextColor(Color backgroundColor) {
    // Generate a random index different from the index of the background color
    int index;
    do {
      index = random.nextInt(textColors.length);
    } while (index == backgroundColors.indexOf(backgroundColor));
    return textColors[index];
  }

  static Color get randomSubtitleColor =>
      textColors[random.nextInt(textColors.length)];

  static Color get randomIconBackgroundColor =>
      backgroundColors[random.nextInt(backgroundColors.length)];

  static Color randomIconColor(Color backgroundColor) =>
      randomTextColor(backgroundColor);
}
