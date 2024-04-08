import 'dart:ui';

import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GameManager extends Component with HasGameRef<DewValley> {
  GameManager();

  ValueNotifier<String> tool = ValueNotifier('axe');
  ValueNotifier<String> seed = ValueNotifier('tomato');
  ValueNotifier<Color> skyColor = ValueNotifier(Colors.white.withOpacity(0));

  void setTool(String value) {
    tool.value = value;
  }

  void setSeed(String value) {
    seed.value = value;
  }

  void setSkyColor(Color value) {
    skyColor.value = value;
  }
}
