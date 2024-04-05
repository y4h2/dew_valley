import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(const GameApp().game);
  runApp(GameWidget(game: DewValley()));
}

// // class MyGame extends FlameGame with KeyboardEvents {
// class MyGame extends FlameGame
//     with HasKeyboardHandlerComponents, HasCollisionDetection {
//   late Level level;

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();

//     camera = CameraComponent.withFixedResolution(
//         width: 1280 / 2, height: 370, world: world);
//     // camera.viewfinder.anchor = Anchor.topLeft;

//     // camera.follow(player);

//     level = Level();

//     add(level);
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//   }
// }
