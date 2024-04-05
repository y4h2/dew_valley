import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class RectangleCollidable extends PositionComponent with CollisionCallbacks {
  RectangleCollidable({
    required Vector2 super.position,
    required Vector2 super.size,
  });
  late ShapeHitbox hitbox;

  @override
  Future<void>? onLoad() {
    super.onLoad();
    hitbox = RectangleHitbox();
    add(hitbox);
  }
}
