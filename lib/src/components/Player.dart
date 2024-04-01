import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/components.dart';
import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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
    with HasGameRef<DewValley>, KeyboardHandler {
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

  Vector2 _velocity = Vector2.zero();

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
      isMoving = true;
      return true;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      current = PlayerState.right;
      isMoving = true;
      return true;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      current = PlayerState.up;
      isMoving = true;
      return true;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      current = PlayerState.down;
      isMoving = true;
      return true;
    }

    isMoving = false;
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
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
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
}
