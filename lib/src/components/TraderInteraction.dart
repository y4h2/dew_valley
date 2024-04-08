import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class TraderInteraction extends PositionComponent
    with HasGameRef<DewValley>, CollisionCallbacks {
  TraderInteraction({required super.position, required super.size}) {
    add(RectangleHitbox(isSolid: true));
  }
}
