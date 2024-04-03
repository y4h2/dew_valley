import 'dart:async';

import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/components.dart';

class Water extends SpriteAnimationComponent with HasGameRef<DewValley> {
  Water({
    required Vector2 super.position,
    required Vector2 super.size,
    super.scale,
    super.angle,
    super.anchor,
  });

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    animation = await SpriteAnimation.spriteList(
        await Future.wait([0, 1, 2, 3]
            .map((i) => Sprite.load('game/environment/water/$i.png'))),
        stepTime: 0.4);
  }
}
