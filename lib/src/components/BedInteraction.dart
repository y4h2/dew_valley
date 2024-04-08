import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class BedInteraction extends PositionComponent
    with HasGameRef<DewValley>, CollisionCallbacks {
  BedInteraction({required super.position, required super.size}) {
    add(RectangleHitbox(isSolid: true));
  }
}
