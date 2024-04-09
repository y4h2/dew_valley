import 'dart:math';

import 'package:dew_valley/src/DewValley.dart';
import 'package:dew_valley/src/components/Player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class SoilLayer extends Component with HasGameRef<DewValley> {
  // manage cells
  SoilLayer(
      {required this.soilTileData,
      required this.cellWidth,
      required this.cellHeight})
      : super();

  List<List<Gid>> soilTileData;
  Map<Vector2, SoilTile> _soil = {};
  double cellWidth;
  double cellHeight;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    for (int i = 0; i < soilTileData!.length; i++) {
      for (int j = 0; j < soilTileData[i].length; j++) {
        if (soilTileData[i][j].tile != 0) {
          await add(FarmableTile(
            position: Vector2(j * cellWidth, i * cellHeight),
            size: Vector2(cellWidth, cellHeight),
            index: Vector2(
              j.toDouble(),
              i.toDouble(),
            ),
            soilLayer: this,
          ));
        }
      }
    }
  }

  registerSoil(Vector2 index, SoilTile soilTile) {
    _soil[index] = soilTile;
  }

  updateAllSoil() {
    _soil.forEach((key, value) {
      value.updateShape(getSoilShape(key));
    });
  }

  String getSoilShape(Vector2 index) {
    bool left = _soil.containsKey(Vector2(index.x - 1, index.y));
    bool right = _soil.containsKey(Vector2(index.x + 1, index.y));
    bool top = _soil.containsKey(Vector2(index.x, index.y - 1));
    bool bottom = _soil.containsKey(Vector2(index.x, index.y + 1));

    String shape = 'o';
    // all side
    if ([left, right, top, bottom].every((e) => e)) {
      shape = 'x';
    }

    // horizontal tiles only
    if (left && ![right, top, bottom].any((e) => e)) {
      shape = 'r';
    }
    if (right && ![left, top, bottom].any((e) => e)) {
      shape = 'l';
    }
    if (right && left && ![top, bottom].any((e) => e)) {
      shape = 'lr';
    }

    // vertical tiles only
    if (top && ![left, right, bottom].any((e) => e)) {
      shape = 'b';
    }
    if (bottom && ![left, right, top].any((e) => e)) {
      shape = 't';
    }
    if (bottom && top && ![left, right].any((e) => e)) {
      shape = 'tb';
    }

    // corners
    if (left && bottom && ![right, top].any((e) => e)) {
      shape = 'tr';
    }
    if (right && bottom && ![left, top].any((e) => e)) {
      shape = 'tl';
    }
    if (left && top && ![right, bottom].any((e) => e)) {
      shape = 'br';
    }
    if (right && top && ![left, bottom].any((e) => e)) {
      shape = 'bl';
    }

    // T shapes
    if ([right, top, bottom].every((e) => e) && !left) {
      shape = 'tbr';
    }
    if ([left, top, bottom].every((e) => e) && !right) {
      shape = 'tbl';
    }
    if ([left, right, bottom].every((e) => e) && !top) {
      shape = 'lrt';
    }
    if ([left, right, top].every((e) => e) && !bottom) {
      shape = 'lrb';
    }

    return shape;
  }

  void addAllWater() {
    _soil.forEach((key, value) {
      value.addWater();
    });
  }

  void removeAllWater() {
    _soil.forEach((key, value) {
      value.removeWater();
    });
  }
}

enum SoilTileState {
  farmable,
  watered,
}

enum SoilType {
  farmable,
  soil,
  watered,
}

class FarmableTile extends PositionComponent
    with HasGameRef<DewValley>, CollisionCallbacks {
  FarmableTile(
      {required super.position,
      required super.size,
      required this.index,
      required this.soilLayer});
  List<SoilTileState> _states = [];
  Vector2 index;
  SoilLayer soilLayer;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    ShapeHitbox hitbox = RectangleHitbox(isSolid: true);
    add(hitbox);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Hoe) {
      var newSoil =
          SoilTile(position: position, size: size, soilLayer: soilLayer);
      soilLayer.registerSoil(index, newSoil);
      soilLayer.add(newSoil);
      removeFromParent();
      soilLayer.updateAllSoil();
    }
  }
}

class SoilTile extends SpriteComponent
    with HasGameRef<DewValley>, CollisionCallbacks {
  SoilTile(
      {required super.position, required super.size, required this.soilLayer});
  SoilLayer soilLayer;
  Map<SoilTileState, bool> _states = {};
  bool hasWater = false;
  WaterSoil? waterSoil = null;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    ShapeHitbox hitbox = RectangleHitbox(isSolid: true);
    add(hitbox);
    sprite = await Sprite.load('game/environment/soil/o.png');

    if (!hasWater && game.level.isRaining) {
      addWater();
    }
  }

  updateShape(String shape) async {
    sprite = await Sprite.load('game/environment/soil/$shape.png');
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is WaterCan && !hasWater) {
      addWater();
    }
  }

  addWater() {
    hasWater = true;
    waterSoil = WaterSoil(size: size);
    add(waterSoil!);
  }

  void removeWater() {
    if (hasWater) {
      hasWater = false;
      remove(waterSoil!);
      waterSoil = null;
    }
  }
}

class WaterSoil extends SpriteComponent
    with HasGameRef<DewValley>, CollisionCallbacks {
  WaterSoil({required super.size});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    ShapeHitbox hitbox = RectangleHitbox(isSolid: true);
    add(hitbox);
    int index = Random().nextInt(3);
    sprite = await Sprite.load('game/environment/soil_water/$index.png');
  }
}
