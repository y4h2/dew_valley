import 'dart:ui';

import 'package:dew_valley/src/components/Player.dart';
import 'package:dew_valley/src/components/Rain.dart';
import 'package:dew_valley/src/components/managers/GameManager.dart';
import 'package:dew_valley/src/components/managers/PlayerInventoryManager.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:dew_valley/src/components/Level.dart';

class DewValley extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DewValley() : super(camera: CameraComponent());
  static int getPlatformVersion() {
    return 0;
  }

  late Level level;
  late GameManager gameManager;
  late PlayerInventoryManager playerInventoryManager;

  @override
  Color backgroundColor() {
    return const Color(0xFF211F30);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // debugMode = true;

    level = Level();
    gameManager = GameManager();
    playerInventoryManager = PlayerInventoryManager();

    world = World(children: [
      level,
      gameManager,
      playerInventoryManager,
    ]);

    await add(world);

    camera = CameraComponent.withFixedResolution(
        width: 1280, height: 1280, world: world);
    await add(camera);
  }
}
