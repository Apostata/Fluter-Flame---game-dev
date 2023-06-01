import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft_2d/components/block_breaking_component.dart';
import 'package:minecraft_2d/global/game_reference.dart';
import 'package:minecraft_2d/resources/blocks.dart';
import 'package:minecraft_2d/utils/game_methods.dart';

class BlockComponent extends SpriteComponent with Tappable {
  final BlocksEnum block;
  final Vector2 blockIndex;
  final int chunkIdx;

  BlockComponent({
    required this.block,
    required this.blockIndex,
    required this.chunkIdx,
  });

  late BlockBreakingComponent blockBreakingComponent;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = GameMethods.instance.blockSizes;
    sprite = GameMethods.instance.getSpriteFromBlock(block);
    add(RectangleHitbox());
    initializeBlockBreakingComponent();
  }

  void initializeBlockBreakingComponent() {
    blockBreakingComponent = BlockBreakingComponent();
    blockBreakingComponent.spriteSheet = SpriteSheet(
      image: Flame.images
          .fromCache('sprite_sheets/blocks/block_breaking_sprite_sheet.png'),
      srcSize: Vector2.all(60),
    );
    blockBreakingComponent.size = GameMethods.instance.blockSizes;

    blockBreakingComponent.animation =
        blockBreakingComponent.spriteSheet.createAnimation(
      row: 0,
      stepTime: BlockData.getBlockDataForBlock(block).baseMiningSpeed / 6,
      loop: false,
    );
    blockBreakingComponent.animation?.onComplete = () {
      remove(blockBreakingComponent);
      removeFromParent();
      GameMethods.instance.replaceBlockAtWorldChunk(null, blockIndex);
    };
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

  @override
  bool onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    if (BlockData.getBlockDataForBlock(block).breakable) {
      if (!blockBreakingComponent.pause) {
        add(blockBreakingComponent);
      }
      blockBreakingComponent.pause = false;
    }
    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    blockBreakingComponent.pause = true;

    // remove(blockBreakingComponent);

    //stop breaking animation
    return true;
  }

  @override
  bool onTapCancel() {
    // remove(blockBreakingComponent);
    blockBreakingComponent.pause = true;

    //stop breaking animation
    return true;
  }
}
