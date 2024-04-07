import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

class TooltipOverlay extends StatelessWidget {
  TooltipOverlay({required this.game, super.key});
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ValueListenableBuilder(
          valueListenable: (game as DewValley).gameManager.tool,
          builder: (BuildContext context, Object? value, Widget? child) {
            return Container(
              child: Image.asset(
                "assets/images/game/overlay/$value.png",
                height: 200,
                width: 200,
              ),
            );
          }),
      ValueListenableBuilder(
          valueListenable: (game as DewValley).gameManager.seed,
          builder: (BuildContext context, Object? value, Widget? child) {
            return Container(
              child: Image.asset(
                "assets/images/game/overlay/$value.png",
                height: 200,
                width: 200,
              ),
            );
          }),
    ]);
  }
}
