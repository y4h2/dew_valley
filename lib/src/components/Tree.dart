import 'dart:async';
import 'dart:math';

import 'package:dew_valley/src/components/Obstacle.dart';
import 'package:dew_valley/src/components/Player.dart';
import 'package:dew_valley/src/settings.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum TreeSize {
  small,
  medium,
  ;

  static final _map = <String, TreeSize>{
    'small': TreeSize.small,
    'large': TreeSize.medium,
  };

  static TreeSize toEnum(String value) {
    return _map[value.toLowerCase()]!;
  }
}

class Tree extends SpriteComponent with CollisionCallbacks {
  Tree({
    required Vector2 super.position,
    required Vector2 super.size,
    super.scale,
    super.angle,
    super.anchor,
    this.treeSize = TreeSize.small,
  });

  TreeSize treeSize;
  late ShapeHitbox hitbox;
  List<Apple> apples = [];

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    if (treeSize == TreeSize.small) {
      sprite = await Sprite.load(
          'game/objects/tree_small.png'); //Sprite.load('game/objects/tree_small.png');
    } else if (treeSize == TreeSize.medium) {
      sprite = await Sprite.load(
          'game/objects/tree_medium.png'); //Sprite.load('game/objects/tree_medium.png');
    } else {
      throw 'Unknown tree size: $treeSize';
    }

    hitbox = RectangleHitbox();
    add(hitbox);
    add(Obstacle(position: Vector2.zero(), size: size));

    for (int i = 0; i < applePositions[treeSize.name]!.length; i++) {
      final applePosition = applePositions[treeSize.name]![i];
      final apple = Apple(
          position: Vector2(
              applePosition.$1.toDouble(), applePosition.$2.toDouble()));
      add(apple);
      apples.add(apple);
    }
  }

  bool _isAlive() {
    return apples.isNotEmpty;
  }

  void damage() {
    var appleIndex = Random().nextInt(apples.length);
    apples.elementAt(appleIndex).kill();
    apples.removeAt(appleIndex);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_isAlive()) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // if (other is Axe) {
    //   print("hit");
    // }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Axe) {
      // print("hit");

      damage();
    }
  }
}

class Apple extends SpriteComponent {
  Apple({super.position}) : super();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('game/fruit/apple.png');
  }

  void kill() {
    removeFromParent();
  }
}
