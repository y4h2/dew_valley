import 'dart:async';

import 'package:dew_valley/src/settings.dart';
import 'package:flame/components.dart';

class SunFlower extends SpriteComponent {
  SunFlower({required super.position, required super.size}) : super();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('game/objects/sunflower.png');
  }
}
