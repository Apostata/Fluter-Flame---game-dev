import 'dart:async';

import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:minecraft_2d/components/block_component.dart';
import 'package:minecraft_2d/components/player_component.dart';
import 'package:minecraft_2d/global/game_reference.dart';
import 'package:minecraft_2d/utils/chunk_generation_methods.dart';
import 'package:minecraft_2d/utils/constants.dart';
import 'package:minecraft_2d/utils/game_methods.dart';
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
  }

  @override
  void update(double dt) {
    super.update(dt);
    worldData.chunksToRender.asMap().forEach((idx, chunkIdx) {
      final rightChunkLength = worldData.rightWorldChunks[0].length;
      final leftChunkLength = worldData.leftWorldChunks[0].length;

      if (!worldData.allreadyRenderedChunks.contains(chunkIdx)) {
        if (chunkIdx >= 0) {
          if ((rightChunkLength ~/ chunkWidth) < chunkIdx + 1) {
            GameMethods.instance.addWorldChunk(
              ChunkGenerationMethods.instance.generateChunk(chunkIdx),
              false,
            );
          }
          renderChunk(chunkIdx);
          worldData.allreadyRenderedChunks.add(chunkIdx);
        } else {
          //let
          if ((leftChunkLength ~/ chunkWidth) < chunkIdx.abs() + 1) {
            GameMethods.instance.addWorldChunk(
              ChunkGenerationMethods.instance.generateChunk(chunkIdx),
              true,
            );
          }
          renderChunk(chunkIdx);
          worldData.allreadyRenderedChunks.add(chunkIdx);
        }
      }
    });
  }

  void renderChunk(int chunkIdx) {
    final currChunk = GameMethods.instance.getIndividualChunk(chunkIdx);
    currChunk.asMap().forEach((int yIdx, rowOfBlocks) {
      rowOfBlocks.asMap().forEach((int xIdx, block) {
        if (block != null) {
          add(
            BlockComponent(
              block: block,
              blockIndex: Vector2(
                  (chunkWidth * chunkIdx) + xIdx.toDouble(), yIdx.toDouble()),
            ),
          );
        }
      });
    });
  }
}
