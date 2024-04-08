import 'package:dew_valley/src/DewValley.dart';
import 'package:dew_valley/src/widgets/SkyOverlay.dart';
import 'package:dew_valley/src/widgets/TooltipOverlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});
  @override
  _GameAppState createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final DewValley game;
  @override
  void initState() {
    super.initState();
    game = DewValley();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color(0xff184e77),
          displayColor: const Color(0xff184e77),
        ),
      ),
      home: Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            "tooltip": (BuildContext context, DewValley game) {
              return TooltipOverlay(
                game: game,
              );
            },
            "sky": (BuildContext context, DewValley game) {
              return SkyOverlay(
                game: game,
              );
            }
          },
        ),
      ),
    );
  }
}
