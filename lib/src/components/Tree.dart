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
    this.treeSize = TreeSize.small,
  });

  TreeSize treeSize;
  late ShapeHitbox hitbox;
  List<Apple> apples = [];
  bool isAlive = true;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    debugMode = true;

    if (treeSize == TreeSize.small) {
      sprite = await Sprite.load(
          'game/objects/tree_small.png'); //Sprite.load('game/objects/tree_small.png');
    } else if (treeSize == TreeSize.medium) {
      sprite = await Sprite.load(
          'game/objects/tree_medium.png'); //Sprite.load('game/objects/tree_medium.png');
    } else {
      throw 'Unknown tree size: $treeSize';
    }

    add(Obstacle(position: Vector2.zero(), size: size));
    hitbox = RectangleHitbox(isSolid: true);
    add(hitbox);

    for (int i = 0; i < applePositions[treeSize.name]!.length; i++) {
      final applePosition = applePositions[treeSize.name]![i];
      final apple = Apple(
          position: Vector2(
              applePosition.$1.toDouble(), applePosition.$2.toDouble()));
      add(apple);
      apples.add(apple);
    }
  }

  void damage() {
    var appleIndex = Random().nextInt(apples.length);
    apples.elementAt(appleIndex).kill();
    apples.removeAt(appleIndex);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isAlive) {
      checkDeath();
    }
  }

  void checkDeath() async {
    if (apples.isNotEmpty) {
      return;
    }
    isAlive = false;

    parent!.add(Strump(
      position: Vector2(position.x + width / 2, position.y + height),
      treeSize: treeSize,
      anchor: Anchor.bottomCenter,
    ));
    removeFromParent();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Axe && isAlive) {
      print("hit");
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

class Strump extends SpriteComponent {
  Strump({required super.position, required this.treeSize, super.anchor})
      : super();

  TreeSize treeSize;
  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    super.onLoad();
    if (treeSize == TreeSize.small) {
      sprite = await Sprite.load('game/objects/stumps/small.png');
    } else if (treeSize == TreeSize.medium) {
      sprite = await Sprite.load('game/objects/stumps/large.png');
    }

    add(Obstacle(position: Vector2.zero(), size: size));
  }
}
