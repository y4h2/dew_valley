import 'dart:async';

import 'package:dew_valley/src/components/Obstacle.dart';
import 'package:dew_valley/src/components/Player.dart';
import 'package:dew_valley/src/components/SoilLayer.dart';
import 'package:dew_valley/src/models/Item.dart';
import 'package:dew_valley/src/settings.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../DewValley.dart';

class Plant extends SpriteComponent
    with HasGameRef<DewValley>, CollisionCallbacks {
  Plant({
    // required super.position,
    required super.size,
    required this.plantType,
  })  : baseFolder = 'game/fruit/${plantType.name}',
        super(priority: layerPriority['ground plant']!);

  Item plantType;
  String baseFolder;
  int maxAge = 4;
  bool harvestable = false;
  int growSpeed = 1;
  bool isWatered = false;
  int age = 0;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('$baseFolder/0.png');
    ShapeHitbox hitbox = RectangleHitbox(isSolid: true);
    add(hitbox);
  }

  void grow() async {
    if (!isWatered) {
      return;
    }
    age += growSpeed;
    if (age > 0) {
      // add obstacle
      add(Obstacle(
        position: Vector2(position.x, position.y - size.y),
        size: Vector2(size.x, size.y),
      ));
    }
    if (age >= maxAge) {
      harvestable = true;
      age = maxAge;
    } else {
      sprite = await Sprite.load('$baseFolder/$age.png');
      priority = layerPriority['main']!;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (!isWatered && other is WaterSoil) {
      isWatered = true;
    }
    if (harvestable && other is Player) {
      removeFromParent();
      game.playerInventoryManager.addItem(plantType, 1);
    }
  }
}
