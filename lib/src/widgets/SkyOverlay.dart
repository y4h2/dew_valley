import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SkyOverlay extends StatelessWidget {
  const SkyOverlay({required this.game, Key? key}) : super(key: key);
  final Game game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: (game as DewValley).gameManager.skyColor,
        builder: (BuildContext context, Object? value, Widget? child) {
          return Container(
            color: value as Color,
          );
        });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return AnimatedContainer(
  //     duration: const Duration(microseconds: 1000),
  //     decoration: BoxDecoration(
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black,
  //           blurRadius: 5,
  //           spreadRadius: 5,
  //           offset: Offset(0, 2),
  //         ),
  //       ],
  //       color: Colors.blue.withOpacity(0.1),
  //     ),
  //   );
  // }
}
