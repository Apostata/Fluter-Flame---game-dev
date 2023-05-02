import 'dart:async';

import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:minecraft_2d/components/player_component.dart';
import 'package:minecraft_2d/global/game_reference.dart';
import 'global/world_data.dart';

class MainGame extends FlameGame {
  final WorldData worldData;
  GameReference globalGameReference = Get.put(GameReference());
  Player playerComponent = Player();

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    add(playerComponent);
    Get.put(MainGame(worldData: worldData));
  }
}
