import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum TreeSize {
  small,
  medium,
  unknown,
  ;

  static final _map = <String, TreeSize>{
    'small': TreeSize.small,
    'large': TreeSize.medium,
  };

  static TreeSize toEnum(String value) {
    return _map[value.toLowerCase()] ?? TreeSize.unknown;
  }
}

class Tree extends SpriteComponent with CollisionCallbacks {
  Tree({
    required Vector2 super.position,
    required Vector2 super.size,
    super.scale,
    super.angle,
    super.anchor,
    this.treeSize = TreeSize.small,
  });

  TreeSize treeSize;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    if (treeSize == TreeSize.small) {
      sprite = await Sprite.load(
          'game/objects/tree_small.png'); //Sprite.load('game/objects/tree_small.png');
    } else if (treeSize == TreeSize.medium) {
      sprite = await Sprite.load(
          'game/objects/tree_medium.png'); //Sprite.load('game/objects/tree_medium.png');
    } else {
      throw 'Unknown tree size: $treeSize';
    }
  }
}
