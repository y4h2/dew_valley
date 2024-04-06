import 'package:flame/components.dart';

Future<SpriteAnimation> loadAnimationInFolder(
    List<int> indices, String folder, double stepTime) async {
  return SpriteAnimation.spriteList(
      await Future.wait(indices.map((i) => Sprite.load('$folder/$i.png'))),
      stepTime: stepTime);
}
