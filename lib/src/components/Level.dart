import 'dart:async';

import 'package:dew_valley/src/components/Obstacle.dart';
import 'package:dew_valley/src/components/Rain.dart';
import 'package:dew_valley/src/components/Tree.dart';
import 'package:dew_valley/src/components/Water.dart';
import 'package:dew_valley/src/components/Player.dart';
import 'package:dew_valley/src/components/SunFlower.dart';
import 'package:dew_valley/src/settings.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:dew_valley/src/DewValley.dart';

class Level extends Component with HasGameRef<DewValley> {
  Level() : super(priority: layerPriority['ground']);

  double elementWidth = 64;
  double elementHeight = 64;

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

    await add(level);

    final treeLayer = tileMap.getLayer<ObjectGroup>('Trees');
    for (final object in treeLayer!.objects) {
      add(Tree(
        position: Vector2(object.x, object.y - object.height),
        size: Vector2(object.width, object.height),
        treeSize: TreeSize.toEnum(object.name),
      ));
    }

    await add(Rain());

    Player player = Player(
      size: Vector2.all(128),
      position: Vector2(200, 200),
    );
    await add(player);
    game.camera.follow(player);

    // final decorationLayer = tileMap.getLayer<ObjectGroup>('Decoration');
    // for (final object in decorationLayer!.objects) {
    //   add(SunFlower(
    //     position: Vector2(object.x, object.y - object.height),
    //     size: Vector2(object.width, object.height),
    //   ));
    // }

    tileMap.renderableLayers;

    final obstacleLayer = tileMap.getLayer<TileLayer>('Collision');
    final obstacleTileData = obstacleLayer!.tileData;
    for (int i = 0; i < obstacleTileData!.length; i++) {
      for (int j = 0; j < obstacleTileData[i].length; j++) {
        if (obstacleTileData[i][j].tile != 0) {
          add(Obstacle(
            position: Vector2(j * elementWidth, i * elementHeight),
            size: Vector2(elementWidth, elementHeight),
          ));
        }
      }
    }

    game.overlays.add("tooltip");
  }
}
