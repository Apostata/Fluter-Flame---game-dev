import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:minecraft_2d/global/game_reference.dart';
import 'package:minecraft_2d/resources/blocks.dart';
import 'package:minecraft_2d/utils/constants.dart';

import '../global/world_data.dart';

class GameMethods {
  static late Size _gameScreenSize;

  static GameMethods get instance {
    return GameMethods();
  }

  set gameScreenSize(BuildContext context) {
    _gameScreenSize = MediaQuery.of(context).size;
  }

  Vector2 get blockSizes {
    // return Vector2.all(getScreenSize().width / chunkWidth);
    return Vector2.all(30);
  }

  Size getScreenSize() {
    // ignore: deprecated_member_use
    // print(WidgetsBinding.instance.window.physicalSize.width);
    // return MediaQueryData.fromWindow(WidgetsBinding.instance.window)
    //     .size; // deprecated
    return _gameScreenSize;
  }

  int get notGroundArea {
    return (chunkHeight * 0.4).toInt();
  }

  int get maxSecondarySoilHeight {
    return notGroundArea + 6;
  }

  double get playerXposition {
    final playerPosition =
        GameReference.instance.gameReference.playerComponent.position;
    return playerPosition.x / blockSizes.x;
  }

  double get playerYposition {
    final playerPosition =
        GameReference.instance.gameReference.playerComponent.position;
    return playerPosition.y / blockSizes.y;
  }

  int get currentChunk {
    final isLeftWorldChunk = playerXposition < 0;
    final posfix = isLeftWorldChunk ? -1 : 0;
    return (playerXposition ~/ chunkWidth) + posfix;
  }

  double get gravity {
    return (0.8 * blockSizes.y);
  }

  double get speed {
    return (5 * blockSizes.x);
  }

  Vector2 getIndexPositionFromPixels(Vector2 clickposition) {
    final double x = (clickposition.x / blockSizes.x).floorToDouble();
    final double y = (clickposition.y / blockSizes.y).floorToDouble();
    return Vector2(x, y);
  }

  int getChunkIndexFromPositionIndex(Vector2 positionIndex) {
    return (positionIndex.x ~/ chunkWidth) + (positionIndex.x < 0 ? -1 : 0);
  }

  Future<SpriteSheet> getBlockSpriteSheet() async {
    return SpriteSheet(
      image: await Flame.images.load(
        'sprite_sheets/blocks/block_sprite_sheet.png',
      ),
      srcSize: Vector2.all(
        60,
      ),
    );
  }

  Future<Sprite> getSpriteFromBlock(BlocksEnum block) async {
    SpriteSheet spriteSheet = await getBlockSpriteSheet();
    return spriteSheet.getSprite(0, block.index);
  }

  Future<SpriteSheet> getBreakingSpriteSheet() async {
    return SpriteSheet(
      image: await Flame.images
          .load('sprite_sheets/blocks/block_breaking_sprite_sheet.png'),
      srcSize: Vector2.all(60),
    );
  }

  void addWorldChunk(List<List<BlocksEnum?>> chunk, bool isLeftWorldChunk) {
    if (isLeftWorldChunk) {
      final leftWorldChunks =
          GameReference.instance.gameReference.worldData.leftWorldChunks;

      chunk.asMap().forEach((yIdx, row) {
        leftWorldChunks[yIdx].addAll(row);
      });
    } else {
      final rightWorldChunks =
          GameReference.instance.gameReference.worldData.rightWorldChunks;

      chunk.asMap().forEach((yIdx, row) {
        rightWorldChunks[yIdx].addAll(row);
      });
    }
  }

  List<List<BlocksEnum?>> getIndividualChunk(int chunkIdx) {
    final isLeftWorldChunk = chunkIdx < 0;

    final List<List<BlocksEnum?>> chunk = [];
    final worldChunks = !isLeftWorldChunk
        ? GameReference.instance.gameReference.worldData.rightWorldChunks
        : GameReference.instance.gameReference.worldData.leftWorldChunks;
    worldChunks.asMap().forEach((yIdx, rowOfCombinedBlocks) {
      List<BlocksEnum?> currChunk = rowOfCombinedBlocks.sublist(
        chunkWidth * (isLeftWorldChunk ? (chunkIdx.abs() - 1) : chunkIdx),
        chunkWidth * (isLeftWorldChunk ? (chunkIdx.abs()) : (chunkIdx + 1)),
      );
      if (isLeftWorldChunk) currChunk = currChunk.reversed.toList();
      // to the noise be generated in the right way when the chunk index is negative

      chunk.add(currChunk);
    });
    return chunk;
  }

  List<List<int>> processNoise(List<List<double>> noise) {
    List<List<int>> processedNoise = List.generate(
      noise.length,
      (index) => List.generate(
        noise[0].length,
        (idx) => 255,
      ),
    );

    for (int i = 0; i < noise.length; i++) {
      for (int k = 0; k < noise[0].length; k++) {
        int value = (0x80 + 0x80 * noise[i][k]).floor(); //grayscale
        processedNoise[i][k] = value;
      }
    }
    return processedNoise;
  } // tow dimension noise

  void replaceBlockAtWorldChunk(BlocksEnum? block, Vector2 blockIndex) {
    //verify if the block is in the left or right world chunk
    WorldData worldData = GameReference.instance.gameReference.worldData;

    if (blockIndex.x >= 0) {
      worldData.rightWorldChunks[blockIndex.y.toInt()][blockIndex.x.toInt()] =
          block;
    } else {
      worldData.leftWorldChunks[blockIndex.y.toInt()]
          [blockIndex.x.toInt().abs() - 1] = block;
    }
  }

  List<int> getXAndYTappedpositionRelativeToPlayer(Vector2 tappedPosition) {
    double pointy0 = playerYposition.floor() - tappedPosition.y;
    double pointx0 = playerXposition.floor() - tappedPosition.x;
    int x = pointx0.toInt().abs();
    int y = (pointy0 - 1).toInt().abs();
    return [x, y];
  }

  bool isPlacingPositionInPLayerRange(Vector2 positionIndex) {
    final relativePositionToPlayer =
        getXAndYTappedpositionRelativeToPlayer(positionIndex);

    bool xInReach = relativePositionToPlayer[0] <= maxBlockPlacingReach;
    bool yInReach = relativePositionToPlayer[1] <= maxBlockPlacingReach;
    if (xInReach && yInReach) {
      return true;
    }
    return false;
  }

  BlocksEnum? getBlockAtPosition(Vector2 postionIndex) {
    WorldData worldData = GameReference.instance.gameReference.worldData;
    if (postionIndex.x <= chunkWidth &&
        (postionIndex.y <= chunkHeight && postionIndex.y >= 0)) {
      //postionIndex.y < 0 = fora da tela
      if (postionIndex.x >= 0) {
        return worldData.rightWorldChunks[postionIndex.y.toInt()]
            [postionIndex.x.toInt()];
      } else {
        return worldData.leftWorldChunks[postionIndex.y.toInt()]
            [postionIndex.x.toInt().abs() - 1];
      }
    }
    return BlocksEnum.dirt;
  }

  bool areThereAdjacentBlocks(Vector2 positionIndex) {
    List<bool> thereAreAcjacentBlocks = [false, false, false, false];
    final isThereBlockAbove =
        getBlockAtPosition(Vector2(positionIndex.x, positionIndex.y - 1));
    final isThereBlockBelow =
        getBlockAtPosition(Vector2(positionIndex.x, positionIndex.y + 1));
    final isThereBlockLeft =
        getBlockAtPosition(Vector2(positionIndex.x - 1, positionIndex.y));
    final isThereBlockRight =
        getBlockAtPosition(Vector2(positionIndex.x + 1, positionIndex.y));
    thereAreAcjacentBlocks[0] = isThereBlockAbove != null;
    thereAreAcjacentBlocks[1] = isThereBlockBelow != null;
    thereAreAcjacentBlocks[2] = isThereBlockRight != null;
    thereAreAcjacentBlocks[3] = isThereBlockLeft != null;

    return thereAreAcjacentBlocks.contains(true);
  }
}
