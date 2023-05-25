import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:minecraft_2d/global/game_reference.dart';
import 'package:minecraft_2d/resources/blocks.dart';
import 'package:minecraft_2d/utils/game_methods.dart';

class BlockComponent extends SpriteComponent {
  final BlocksEnum block;
  final Vector2 blockIndex;
  final int chunkIdx;

  BlockComponent({
    required this.block,
    required this.blockIndex,
    required this.chunkIdx,
  });

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = GameMethods.instance.blockSizes;
    sprite = await GameMethods.instance.getSpriteFromBlock(block);
    add(RectangleHitbox());
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    size = GameMethods.instance.blockSizes;
    position = Vector2(
      GameMethods.instance.blockSizes.x * blockIndex.x,
      GameMethods.instance.blockSizes.x * blockIndex.y,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    final worldData = GameReference.instance.gameReference.worldData;
    final chunksToRender = worldData.chunksToRender;
    final allreadyRenderedChunks = worldData.allreadyRenderedChunks;

    if (!chunksToRender.contains(chunkIdx)) {
      removeFromParent();
      allreadyRenderedChunks.remove(chunkIdx);
    }
  }
}
