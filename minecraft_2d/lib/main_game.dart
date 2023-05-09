import 'dart:async';

import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:minecraft_2d/components/block_component.dart';
import 'package:minecraft_2d/components/player_component.dart';
import 'package:minecraft_2d/global/game_reference.dart';
import 'package:minecraft_2d/resources/blocks.dart';
import 'package:minecraft_2d/utils/chunk_generation_methods.dart';
import 'global/world_data.dart';

class MainGame extends FlameGame {
  final WorldData worldData;
  final GameReference globalGameReference = Get.put(GameReference());
  Player playerComponent = Player();

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    camera.followComponent(playerComponent);
    add(playerComponent);
    renderChunk(ChunkGenerationMethods.instance.generateChunk());
  }

  void renderChunk(List<List<BlocksEnum?>> chunk) {
    chunk.asMap().forEach((int yIdx, rowOfBlocks) {
      rowOfBlocks.asMap().forEach((int xIdx, block) {
        if (block != null) {
          add(
            BlockComponent(
              block: block,
              blockIndex: Vector2(xIdx.toDouble(), yIdx.toDouble()),
            ),
          );
        }
      });
    });
  }
}
