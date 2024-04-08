import 'package:dew_valley/src/DewValley.dart';
import 'package:dew_valley/src/components/Player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class SoilLayer extends Component with HasGameRef<DewValley> {
  // manage cells
  SoilLayer() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  void waterAll() {
    // water all soil cells
  }
}

enum SoilTileState {
  farmable,
  watered,
}

class FarmableTile extends PositionComponent
    with HasGameRef<DewValley>, CollisionCallbacks {
  FarmableTile({required super.position, required super.size});
  List<SoilTileState> _states = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    ShapeHitbox hitbox = RectangleHitbox(isSolid: true);
    add(hitbox);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    super.onCollisionStart(intersectionPoints, other);
    if (other is Hoe) {
      parent!.add(SoilTile(position: position, size: size));
      removeFromParent();
    }
  }

  // @override
  // void onCollisionEnd(PositionComponent other) {
  //   super.onCollisionEnd(other);
  //   if (other is Hoe) {
  //     parent!.add(SoilTile(position: position, size: size));
  //     removeFromParent();
  //   }
  // }
}

class SoilTile extends SpriteComponent
    with HasGameRef<DewValley>, CollisionCallbacks {
  SoilTile({required super.position, required super.size});
  Map<SoilTileState, bool> _states = {};
  @override
  Future<void> onLoad() async {
    super.onLoad();
    ShapeHitbox hitbox = RectangleHitbox(isSolid: true);
    add(hitbox);
    sprite = await Sprite.load('game/environment/soil/o.png');
  }
}
