import 'dart:async';
import 'dart:math';

import 'package:dew_valley/src/components/BedInteraction.dart';
import 'package:dew_valley/src/components/Obstacle.dart';
import 'package:dew_valley/src/components/Rain.dart';
import 'package:dew_valley/src/components/SoilLayer.dart';
import 'package:dew_valley/src/components/TraderInteraction.dart';
import 'package:dew_valley/src/components/Tree.dart';
import 'package:dew_valley/src/components/Water.dart';
import 'package:dew_valley/src/components/Player.dart';
import 'package:dew_valley/src/settings.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:dew_valley/src/DewValley.dart';
import 'package:flutter/material.dart';

class Level extends Component with HasGameRef<DewValley> {
  Level() : super(priority: layerPriority['ground']);

  double elementWidth = 64;
  double elementHeight = 64;

  late BedInteraction bedInteraction;
  late TraderInteraction traderInteraction;
  late Player player;
  late SoilLayer soilLayer;
  bool isRaining = false;

  late double mapWidth;
  late double mapHeight;
  late Rain? rain;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    final level = await TiledComponent.load(
        "map.tmx", Vector2(elementWidth, elementHeight));

    final tileMap = level.tileMap;

    final waterLayer = tileMap.getLayer<TileLayer>('Water');
    final tileData = waterLayer!.tileData;
    for (int i = 0; i < tileData!.length; i++) {
      for (int j = 0; j < tileData[i].length; j++) {
        if (tileData[i][j].tile != 0) {
          add(Water(
            position: Vector2(j * elementWidth, i * elementHeight),
            size: Vector2(elementWidth, elementHeight),
          ));
        }
      }
    }
    mapWidth = elementWidth * tileData.length;
    mapHeight = elementHeight * tileData[0].length;

    await add(level);

    final treeLayer = tileMap.getLayer<ObjectGroup>('Trees');
    for (final object in treeLayer!.objects) {
      add(Tree(
        position: Vector2(object.x, object.y - object.height),
        size: Vector2(object.width, object.height),
        treeSize: TreeSize.toEnum(object.name),
      ));
    }

    final playerLayer = tileMap.getLayer<ObjectGroup>('Player');
    final playerObject = playerLayer!.objects
        .where(
          (element) => element.name == 'Start',
        )
        .toList()
        .first;
    player = Player(
      position: Vector2(playerObject.x, playerObject.y),
      size: Vector2(100, 100),
    );
    await add(player);
    game.camera.follow(player);

    // Bed
    final bedObject = playerLayer.objects
        .where(
          (element) => element.name == 'Bed',
        )
        .toList()
        .first;

    bedInteraction = BedInteraction(
      position: Vector2(bedObject.x, bedObject.y),
      size: Vector2(bedObject.width, bedObject.height),
    );
    await add(bedInteraction);

    // Trader

    final traderObject = playerLayer.objects
        .where(
          (element) => element.name == 'Trader',
        )
        .toList()
        .first;
    traderInteraction = TraderInteraction(
      position: Vector2(traderObject.x, traderObject.y),
      size: Vector2(traderObject.width, traderObject.height),
    );
    await add(traderInteraction);

    final obstacleLayer = tileMap.getLayer<TileLayer>('Collision');
    final obstacleTileData = obstacleLayer!.tileData;
    for (int i = 0; i < obstacleTileData!.length; i++) {
      for (int j = 0; j < obstacleTileData[i].length; j++) {
        if (obstacleTileData[i][j].tile != 0) {
          await add(Obstacle(
            position: Vector2(j * elementWidth, i * elementHeight),
            size: Vector2(elementWidth, elementHeight),
          ));
        }
      }
    }

    final soilLayerMap = tileMap.getLayer<TileLayer>('Farmable');
    final soilTileData = soilLayerMap!.tileData;

    soilLayer = SoilLayer(
        soilTileData: soilTileData!,
        cellWidth: elementWidth,
        cellHeight: elementHeight);
    await add(soilLayer);

    whetherRaining();

    game.overlays.add("tooltip");
    game.overlays.add("sky");
  }

  void whetherRaining() {
    isRaining = Random().nextInt(10) < 7;
    if (!isRaining) {
      return;
    }

    soilLayer.addAllWater();
    rain = Rain();
    add(rain!);
  }

  void reset() {
    for (final tree in children.whereType<Tree>()) {
      tree.reset();
    }
    soilLayer.removeAllWater();
    if (isRaining) {
      remove(rain!);
    }

    whetherRaining();
  }

  void nextDay() async {
    reset();

    game.gameManager.setSkyColor(Colors.black.withOpacity(0.5));

    Future.delayed(Duration(milliseconds: 1000)).then(
        (value) => game.gameManager.setSkyColor(Colors.white.withOpacity(0)));

    // await player.add(ColorEffect(Colors.black, EffectController(duration: 0.5),
    //     opacityTo: 1));
  }
}
