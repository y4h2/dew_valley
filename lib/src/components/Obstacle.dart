import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Obstacle extends PositionComponent {
  Obstacle({required super.position, required super.size}) : super();
  late ShapeHitbox hitbox;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    hitbox = RectangleHitbox(size: size);
    add(hitbox);
  }
}
