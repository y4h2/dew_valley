import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/components.dart';
import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

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

class Player extends SpriteAnimationComponent
    with HasGameRef<DewValley>, KeyboardHandler, CollisionCallbacks {
  Player({required Vector2 position, required Vector2 size})
      : super(
          size: size,
          position: position,
          // anchor: Anchor.center,
          priority: 1,
        );

  PlayerState current = PlayerState.downIdle;
  late SpriteAnimation playerLeftAnimation;
  late SpriteAnimation playerLeftIdleAnimation;
  late SpriteAnimation playerRightAnimation;
  late SpriteAnimation playerRightIdleAnimation;
  late SpriteAnimation playerUpAnimation;
  late SpriteAnimation playerUpIdleAnimation;
  late SpriteAnimation playerDownAnimation;
  late SpriteAnimation playerDownIdleAnimation;
  bool isMoving = false;
  Vector2 direction = Vector2.zero();
  double velocity = 200.0;
  late ShapeHitbox hitbox;
  bool collide = false;
  Vector2 collideDirection = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    const stepTime = 0.1;
    const idleStepTime = 0.3;
    playerLeftAnimation =
        await loadPlayerAnimation([0, 1, 2, 3], 'left', stepTime);
    playerLeftIdleAnimation =
        await loadPlayerAnimation([0, 1], 'left_idle', idleStepTime);
    playerRightAnimation =
        await loadPlayerAnimation([0, 1, 2, 3], 'right', stepTime);
    playerRightIdleAnimation =
        await loadPlayerAnimation([0, 1], 'right_idle', idleStepTime);
    playerUpAnimation = await loadPlayerAnimation([0, 1, 2, 3], 'up', stepTime);
    playerUpIdleAnimation =
        await loadPlayerAnimation([0, 1], 'up_idle', idleStepTime);
    playerDownAnimation =
        await loadPlayerAnimation([0, 1, 2, 3], 'down', stepTime);
    playerDownIdleAnimation =
        await loadPlayerAnimation([0, 1], 'down_idle', idleStepTime);

    animation = playerDownAnimation;
    hitbox = RectangleHitbox();
    add(hitbox);
  }

  Future<SpriteAnimation> loadPlayerAnimation(
      List<int> indices, String folder, double stepTime) async {
    return SpriteAnimation.spriteList(
        await Future.wait(indices
            .map((i) => Sprite.load('game/character/player/$folder/$i.png'))),
        stepTime: stepTime);
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
    switch (current) {
      case PlayerState.left:
        animation = playerLeftAnimation;
        break;
      case PlayerState.leftIdle:
        animation = playerLeftIdleAnimation;
        break;
      case PlayerState.right:
        animation = playerRightAnimation;
        break;
      case PlayerState.rightIdle:
        animation = playerRightIdleAnimation;
        break;
      case PlayerState.up:
        animation = playerUpAnimation;
        break;
      case PlayerState.upIdle:
        animation = playerUpIdleAnimation;
        break;
      case PlayerState.down:
        animation = playerDownAnimation;
        break;
      case PlayerState.downIdle:
        animation = playerDownIdleAnimation;
        break;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (!collide) {
      collide = true;
      collideDirection.x = direction.x;
      collideDirection.y = direction.y;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    collideDirection = Vector2.zero();
    collide = false;
  }
}
