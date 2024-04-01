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
class MyGame extends FlameGame with HasKeyboardHandlerComponents {
  late Player player;
  late Level level;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    player = Player(
      size: Vector2.all(64),
      position: Vector2(200, 200),
    );

    level = Level();

    add(level);
    add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
