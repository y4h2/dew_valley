import 'package:dew_valley/src/components/Level.dart';
import 'package:dew_valley/src/components/Player.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

void main() {
  // runApp(const GameApp().game);
  runApp(GameWidget(game: MyGame()));
}

// class MyGame extends FlameGame with KeyboardEvents {
class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late Level level;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;

    level = Level();

    add(level);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
