import 'package:dew_valley/src/DewValley.dart';
import 'package:dew_valley/src/components/BedInteraction.dart';
import 'package:dew_valley/src/components/Obstacle.dart';
import 'package:dew_valley/src/settings.dart';
import 'package:flame/components.dart';
import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:dew_valley/src/utils/utils.dart' as utils;
import 'package:dew_valley/src/models/Item.dart';

enum PlayerState {
  left,
  leftIdle,
  right,
  rightIdle,
  up,
  upIdle,
  down,
  downIdle
}

extension ParseToString on PlayerState {
  String toSnakeCase() {
    String text = toString().split('.').last;
    final exp = RegExp('(?<=[a-z])[A-Z]');
    return text.replaceAllMapped(exp, (m) => '_${m.group(0)}').toLowerCase();
  }
}

class Player extends SpriteAnimationComponent
    with HasGameRef<DewValley>, KeyboardHandler, CollisionCallbacks {
  Player({required Vector2 position, required Vector2 size})
      : super(
          size: size,
          position: position,
          priority: layerPriority['main'],
        );

  PlayerState current = PlayerState.downIdle;
  late Map<String, SpriteAnimation> animationMap = {};
  bool isMoving = false;
  Vector2 direction = Vector2.zero();
  double velocity = 200.0;
  late ShapeHitbox hitbox;
  bool collide = false;
  Vector2 collideDirection = Vector2.zero();
  List<String> toolList = [
    "axe",
    "hoe",
    "water",
  ];

  List<Item> seedList = [
    Item.tomato,
    Item.corn,
  ];
  int selectedToolIndex = 0;
  int selectedSeedIndex = 0;

  int toolUsageTime = 1000; // milliseconds

  bool isUsingTool = false;

  useTool() {
    // set up timer
    // var currentAnimation = animation;
    isUsingTool = true;
    // animation = toolAnimationMap[getDirectionString() + "_" + getTool()];

    String selectedTool = getTool();
    switch (selectedTool) {
      case "axe":
        // create axe hitbox
        late Axe axe;
        switch (getDirectionString()) {
          case "right":
            axe = Axe(
                position: Vector2(width - 10, height - 10),
                anchor: Anchor.center);
            break;
          case "left":
            axe =
                Axe(position: Vector2(10, height - 10), anchor: Anchor.center);
            break;
          case "up":
            axe = Axe(position: Vector2(width / 2, 0), anchor: Anchor.center);
            break;
          case "down":
            axe = Axe(
                position: Vector2(width / 2, height - 10),
                anchor: Anchor.center);
            break;
        }
        add(axe);

        Future.delayed(Duration(milliseconds: toolUsageTime))
            .then((value) => remove(axe));

        break;
      case "hoe":
        // create hoe hitbox
        late Hoe hoe;
        switch (getDirectionString()) {
          case "right":
            hoe = Hoe(
                position: Vector2(width - 10, height - 20),
                anchor: Anchor.center);
            break;
          case "left":
            hoe =
                Hoe(position: Vector2(10, height - 20), anchor: Anchor.center);
            break;
          case "up":
            hoe = Hoe(position: Vector2(width / 2, 0), anchor: Anchor.center);
            break;
          case "down":
            hoe = Hoe(
                position: Vector2(width / 2, height - 10),
                anchor: Anchor.center);
            break;
        }
        add(hoe);
        Future.delayed(Duration(milliseconds: toolUsageTime))
            .then((value) => remove(hoe));
        break;
      case "water":
        late WaterCan waterCan;

        switch (getDirectionString()) {
          case "right":
            waterCan = WaterCan(
                position: Vector2(width - 10, height - 10),
                anchor: Anchor.center);
            break;
          case "left":
            waterCan = WaterCan(
                position: Vector2(10, height - 10), anchor: Anchor.center);
            break;
          case "up":
            waterCan = WaterCan(
                position: Vector2(width / 2, 0), anchor: Anchor.center);
            break;
          case "down":
            waterCan = WaterCan(
                position: Vector2(width / 2, height - 10),
                anchor: Anchor.center);
            break;
        }
        add(waterCan);

        Future.delayed(Duration(milliseconds: toolUsageTime))
            .then((value) => remove(waterCan));

        break;
    }

    Future.delayed(Duration(milliseconds: toolUsageTime)).then((value) {
      isUsingTool = false;
    });
  }

  Vector2 getTargetPosition() {
    return center + playerToolOffset[getDirectionString()]!;
  }

  switchTool() {
    selectedToolIndex++;
    selectedToolIndex %= toolList.length;
    game.gameManager.setTool(toolList[selectedToolIndex]);
  }

  String getTool() {
    return toolList[selectedToolIndex];
  }

  switchSeed() {
    selectedSeedIndex++;
    selectedSeedIndex %= seedList.length;
    game.gameManager.setSeed(seedList[selectedSeedIndex]);
  }

  Item getSeed() {
    return seedList[selectedSeedIndex];
  }

  String getDirectionString() {
    if (current == PlayerState.rightIdle || current == PlayerState.right) {
      return "right";
    }
    if (current == PlayerState.leftIdle || current == PlayerState.left) {
      return "left";
    }
    if (current == PlayerState.upIdle || current == PlayerState.up) {
      return "up";
    }
    if (current == PlayerState.downIdle || current == PlayerState.down) {
      return "down";
    }
    return "down";
  }

  @override
  Future<void> onLoad() async {
    debugMode = debugModeMap['player']!;
    await super.onLoad();
    const stepTime = 0.1;
    const toolStepTime = 0.1;
    const idleStepTime = 0.3;

    for (String directionS in ["left", "right", "up", "down"]) {
      animationMap[directionS] = await utils.loadAnimationInFolder(
          [0, 1, 2, 3], 'game/character/player/$directionS', stepTime);
      String idleKey = '${directionS}_idle';
      animationMap[idleKey] = await utils.loadAnimationInFolder(
          [0, 1], 'game/character/player/$idleKey', idleStepTime);
    }

    for (String tool in toolList) {
      for (String directionS in ["left", "right", "up", "down"]) {
        String key = '${directionS}_$tool';
        animationMap[key] = await utils.loadAnimationInFolder(
          [0, 1],
          'game/character/player/$key',
          toolStepTime,
        );
      }
    }

    animation = animationMap['down_idle'];
    hitbox = RectangleHitbox(size: size / 2, position: size / 4);
    add(hitbox);
  }

  @override
  bool onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      current = PlayerState.left;
      direction.x = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      current = PlayerState.right;
      direction.x = 1;
    } else {
      direction.x = 0;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      current = PlayerState.up;
      direction.y = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      current = PlayerState.down;
      direction.y = 1;
    } else {
      direction.y = 0;
    }

    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      useTool();
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyQ)) {
      switchTool();
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyE)) {
      switchSeed();
    }

    if (keysPressed.contains(LogicalKeyboardKey.enter)) {
      if (collidingWith(game.level.bedInteraction)) {
        current = PlayerState.leftIdle;
        game.level.nextDay();
      }
      if (collidingWith(game.level.traderInteraction)) {}
    }

    if (keysPressed.contains(LogicalKeyboardKey.controlLeft)) {
      // use seed
      useSeed();
    }
    _updateStatus();
    return false;
  }

  void _updateStatus() {
    if (!_isMoving()) {
      switch (current) {
        case PlayerState.left:
          current = PlayerState.leftIdle;
          break;
        case PlayerState.right:
          current = PlayerState.rightIdle;
          break;
        case PlayerState.up:
          current = PlayerState.upIdle;
          break;
        case PlayerState.down:
          current = PlayerState.downIdle;
          break;
        default:
          break;
      }
    }
  }

  @override
  void update(double dt) {
    _move(dt);
    super.update(dt);
    _updateAnimation();
  }

  bool _isMoving() {
    return (direction.x.abs() + direction.y.abs() > 0);
  }

  bool _isCollide() {
    return collide &&
        ((collideDirection.x == direction.x && direction.x != 0) ||
            (collideDirection.y == direction.y && direction.y != 0));
  }

  void _move(double dt) {
    if (_isMoving() && !_isCollide()) {
      position += direction.normalized() * velocity * dt;
      // position += direction.normalized() * velocity;
    }
    // print(collide);
    // print(collideDirection);
    // print(direction);
  }

  void _updateAnimation() {
    if (isUsingTool) {
      animation = animationMap["${getDirectionString()}_${getTool()}"];
      return;
    }

    animation = animationMap[current.toSnakeCase()];
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Obstacle) {
      super.onCollision(intersectionPoints, other);
      if (!collide) {
        collide = true;
        collideDirection.x = direction.x;
        collideDirection.y = direction.y;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    collideDirection = Vector2.zero();
    collide = false;
  }

  void useSeed() {
    // check inventory
    var currentSeed = getSeed();
    if (!game.playerInventoryManager.useItem(currentSeed)) {
      return;
    }
    var seed;
    switch (getDirectionString()) {
      case "right":
        seed = Seed(
            position: Vector2(width - 10, height - 10),
            anchor: Anchor.center,
            seed: currentSeed);
        break;
      case "left":
        seed = Seed(
            position: Vector2(10, height - 10),
            anchor: Anchor.center,
            seed: currentSeed);
        break;
      case "up":
        seed = Seed(
            position: Vector2(width / 2, 0),
            anchor: Anchor.center,
            seed: currentSeed);
        break;
      case "down":
        seed = Seed(
            position: Vector2(width / 2, height - 10),
            anchor: Anchor.center,
            seed: currentSeed);
        break;
    }
    add(seed);
    Future.delayed(Duration(milliseconds: toolUsageTime))
        .then((value) => remove(seed));
  }
}

class Axe extends ShapeComponent with CollisionCallbacks {
  Axe({required super.position, required super.anchor})
      : super(priority: layerPriority['main']);

  double radius = 5;
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox(
      radius: radius,
      isSolid: true,
    ));
  }
}

class Hoe extends ShapeComponent with CollisionCallbacks {
  Hoe({required super.position, required super.anchor})
      : super(priority: layerPriority['main']);

  double radius = 5;
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox(
      radius: radius,
      isSolid: true,
    ));
  }
}

class WaterCan extends ShapeComponent with CollisionCallbacks {
  WaterCan({required super.position, required super.anchor})
      : super(priority: layerPriority['main']);

  double radius = 5;
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox(
      radius: radius,
      isSolid: true,
    ));
  }
}

class Seed extends ShapeComponent with CollisionCallbacks {
  Seed({required super.position, required super.anchor, required this.seed})
      : super(priority: layerPriority['main']);

  Item seed;
  double radius = 5;
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox(
      radius: radius,
      isSolid: true,
    ));
  }
}
