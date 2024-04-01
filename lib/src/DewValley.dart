import 'package:flame/components.dart';
import 'package:flame/game.dart';

class DewValley extends FlameGame {
  DewValley() : super(camera: CameraComponent());
  static int getPlatformVersion() {
    return 0;
  }

  Future<SpriteAnimation> loadPlayerAnimation(
      List<int> indices, String folder, double stepTime) async {
    return SpriteAnimation.spriteList(
        await Future.wait(indices
            .map((i) => Sprite.load('game/character/player/$folder/$i.png'))),
        stepTime: stepTime);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;

    const stepTime = 0.01;
    final playerLeftAnimation =
        await loadPlayerAnimation([0, 1, 2, 3], 'left', stepTime);
    final playerLeftIdleAnimation =
        await loadPlayerAnimation([0, 1], 'left_idle', stepTime);
    final playerRightAnimation =
        await loadPlayerAnimation([0, 1, 2, 3], 'right', stepTime);
    final playerRightIdleAnimation =
        await loadPlayerAnimation([0, 1], 'right_idle', stepTime);
    final playerUpAnimation =
        await loadPlayerAnimation([0, 1, 2, 3], 'up', stepTime);
    final playerUpIdleAnimation =
        await loadPlayerAnimation([0, 1], 'up_idle', stepTime);
    final playerDownAnimation =
        await loadPlayerAnimation([0, 1, 2, 3], 'down', stepTime);
    final playerDownIdleAnimation =
        await loadPlayerAnimation([0, 1], 'down_idle', stepTime);

    final player = SpriteAnimationComponent(
      animation: playerLeftAnimation,
      position: Vector2.all(200),
      size: Vector2.all(300),
    );

    add(player);

    print("test");
  }
}
