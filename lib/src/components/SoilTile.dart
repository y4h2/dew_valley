import 'package:dew_valley/src/DewValley.dart';
import 'package:flame/components.dart';

enum SoilTileType { center, left, right }

class SoilTile extends SpriteComponent with HasGameRef<DewValley> {
  SoilTile({required super.position, required super.size, required this.type});
  SoilTileType type;
}
