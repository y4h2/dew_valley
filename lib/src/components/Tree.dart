import 'dart:async';
import 'dart:math';

import 'package:dew_valley/src/DewValley.dart';
import 'package:dew_valley/src/components/Obstacle.dart';
import 'package:dew_valley/src/components/Player.dart';
import 'package:dew_valley/src/components/managers/PlayerInventoryManager.dart';
import 'package:dew_valley/src/models/Item.dart';
import 'package:dew_valley/src/settings.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

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

double killDelay = 0.5;

class Tree extends SpriteComponent
    with CollisionCallbacks, HasGameRef<DewValley> {
  Tree({
    required Vector2 super.position,
    required Vector2 super.size,
    this.treeSize = TreeSize.small,
  });

  TreeSize treeSize;
  late ShapeHitbox hitbox;
  List<Apple> apples = [];
  bool isAlive = true;
  int health = 7;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    debugMode = debugModeMap['tree']!;

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
    health -= 1;
    if (apples.isNotEmpty) {
      var appleIndex = Random().nextInt(apples.length);
      apples.elementAt(appleIndex).kill();
      apples.removeAt(appleIndex);
      game.playerInventoryManager.addItem(Item.apple, 1);
    }
  }

  void reset() {
    health = 7;
    isAlive = true;
    for (final apple in apples) {
      apple.kill();
    }
    apples.clear();
    for (int i = 0; i < applePositions[treeSize.name]!.length; i++) {
      final applePosition = applePositions[treeSize.name]![i];
      final apple = Apple(
          position: Vector2(
              applePosition.$1.toDouble(), applePosition.$2.toDouble()));
      add(apple);
      apples.add(apple);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isAlive) {
      checkDeath();
    }
  }

  void checkDeath() async {
    if (health > 0) {
      return;
    }
    isAlive = false;

    add(ColorEffect(Colors.white, EffectController(duration: killDelay),
        opacityTo: 1, onComplete: () {
      parent!.add(Strump(
        position: Vector2(position.x + width / 2, position.y + height),
        treeSize: treeSize,
        anchor: Anchor.bottomCenter,
      ));
      removeFromParent();
      game.playerInventoryManager.addItem(Item.wood, 1);
    }));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Axe && isAlive) {
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
    add(ColorEffect(Colors.white, EffectController(duration: killDelay),
        opacityTo: 1, onComplete: () {
      removeFromParent();
    }));
  }
}

class Strump extends SpriteComponent {
  Strump({required super.position, required this.treeSize, super.anchor})
      : super();

  TreeSize treeSize;
  @override
  FutureOr<void> onLoad() async {
    debugMode = debugModeMap['strump']!;
    super.onLoad();
    if (treeSize == TreeSize.small) {
      sprite = await Sprite.load('game/objects/stumps/small.png');
    } else if (treeSize == TreeSize.medium) {
      sprite = await Sprite.load('game/objects/stumps/large.png');
    }

    add(Obstacle(position: Vector2.zero(), size: size));
  }
}
