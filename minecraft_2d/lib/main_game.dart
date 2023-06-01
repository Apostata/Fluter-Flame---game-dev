import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:minecraft_2d/components/block_component.dart';
import 'package:minecraft_2d/components/player_component.dart';
import 'package:minecraft_2d/global/game_reference.dart';
import 'package:minecraft_2d/resources/blocks.dart';
import 'package:minecraft_2d/utils/chunk_generation_methods.dart';
import 'package:minecraft_2d/utils/constants.dart';
import 'package:minecraft_2d/utils/game_methods.dart';
import 'global/player_data.dart';
import 'global/world_data.dart';

class MainGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, HasTappables {
  final WorldData worldData;
  final GameReference globalGameReference = Get.put(GameReference());
  Player playerComponent = Player();

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  @override
  FutureOr<void> onLoad() async {
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
                chunkIdx: chunkIdx),
          );
        }
      });
    });
  }

  void blockPlacingLogic(Vector2 placingPosition) {
    final gameMethods = GameMethods.instance;

    final bool isIsPlayerRange =
        gameMethods.isPlacingPositionInPLayerRange(placingPosition);

    final bool isNullBlock =
        gameMethods.getBlockAtPosition(placingPosition) == null;

    final bool areThereAdjacentBlocks =
        gameMethods.areThereAdjacentBlocks(placingPosition);

    final List<int> xAndYRelativeToPlayer =
        gameMethods.getXAndYTappedpositionRelativeToPlayer(placingPosition);
    final bool sameBlockAsPlayer =
        xAndYRelativeToPlayer[0] == 0 && xAndYRelativeToPlayer[1] == 0;

    if (placingPosition.y > 0 &&
        placingPosition.y < chunkHeight &&
        isIsPlayerRange &&
        isNullBlock &&
        areThereAdjacentBlocks &&
        !sameBlockAsPlayer) {
      gameMethods.replaceBlockAtWorldChunk(BlocksEnum.dirt, placingPosition);
      add(BlockComponent(
        block: BlocksEnum.dirt,
        blockIndex: placingPosition,
        chunkIdx: gameMethods.getChunkIndexFromPositionIndex(placingPosition),
      ));
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    final gameMethods = GameMethods.instance;
    Vector2 placingPosition =
        gameMethods.getIndexPositionFromPixels(info.eventPosition.game);
    blockPlacingLogic(placingPosition);
    super.onTapDown(pointerId, info);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);

    // move player to right
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      GameReference.instance.gameReference.worldData.playerData
          .componentMotionState = ComponentMotionState.walkingRight;
    }

    // move player to left
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      GameReference.instance.gameReference.worldData.playerData
          .componentMotionState = ComponentMotionState.walkingLeft;
    }

    // jump
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.space)) {
      worldData.playerData.componentMotionState = ComponentMotionState.jumping;
    }

    if (keysPressed.isEmpty) {
      worldData.playerData.componentMotionState = ComponentMotionState.idle;
    }

    return KeyEventResult.ignored;
  }
}
