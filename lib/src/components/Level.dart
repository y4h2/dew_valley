import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends Component {
  Level() : super();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    final level = await TiledComponent.load("map.tmx", Vector2.all(32));

    await add(level);
  }
}
