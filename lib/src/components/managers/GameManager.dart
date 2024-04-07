import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

class GameManager extends Component with HasGameRef<DewValley> {
  GameManager();

  ValueNotifier<String> tool = ValueNotifier('axe');
  ValueNotifier<String> seed = ValueNotifier('tomato');

  void setTool(String value) {
    tool.value = value;
  }

  void setSeed(String value) {
    seed.value = value;
  }
}
