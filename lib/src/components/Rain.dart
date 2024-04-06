import 'dart:async';
import 'dart:math';

import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:dew_valley/src/utils/utils.dart' as utils;
import 'package:dew_valley/src/settings.dart' as settings;

class Drop extends SpriteComponent {
  Drop() : super(priority: settings.layerPriority['rain drops']);

  int lifetime = 400 + Random().nextInt(100); // milliseconds
  Vector2 direction = Vector2(-2, 4);
  double speed = Random().nextInt(50) + 200;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    int spriteIndex = Random().nextInt(3);
    sprite = await Sprite.load('game/environment/rain/drops/$spriteIndex.png');

    Future.delayed(Duration(milliseconds: lifetime))
        .then((value) => removeFromParent());
  }

  @override
  FutureOr<void> update(double dt) {
    super.update(dt);

    position += direction * speed * dt;
  }
}

class DropOnFloor extends SpriteComponent {
  DropOnFloor() : super(priority: settings.layerPriority['rain floor']);

  int lifetime = 400 + Random().nextInt(100); // milliseconds

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    int spriteIndex = Random().nextInt(3);
    sprite = await Sprite.load('game/environment/rain/floor/$spriteIndex.png');

    Future.delayed(Duration(milliseconds: lifetime))
        .then((value) => removeFromParent());
  }
}

class Rain extends Component with HasGameRef<DewValley> {
  Rain() : super();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    spawn();
  }

  spawn() {
    add(SpawnComponent(
      factory: (int i) {
        return Drop();
      },
      period: 0.1,
      area: Rectangle.fromLTWH(0, 0, game.size.x, game.size.y),
    ));
    add(SpawnComponent(
      factory: (int i) {
        return DropOnFloor();
      },
      period: 0.1,
      area: Rectangle.fromLTWH(0, 0, game.size.x, game.size.y),
    ));
  }
}
