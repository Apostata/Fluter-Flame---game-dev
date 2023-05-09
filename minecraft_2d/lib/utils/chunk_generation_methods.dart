import 'dart:developer';

import 'package:fast_noise/fast_noise.dart';
import 'package:minecraft_2d/resources/blocks.dart';
import 'package:minecraft_2d/utils/constants.dart';
import 'package:minecraft_2d/utils/game_methods.dart';

class ChunkGenerationMethods {
  static ChunkGenerationMethods get instance {
    return ChunkGenerationMethods();
  }

  List<List<BlocksEnum?>> generateNullChumk() {
    return List.generate(
      chunkHeight,
      (index) => List.generate(
        chunkWidth,
        (idx) => null,
      ),
    );
  }

  List<List<BlocksEnum?>> generateChunk() {
    List<List<BlocksEnum?>> chunk = generateNullChumk();

    List<List<double>> rawNoise = noise2(
      chunkWidth,
      1, //height 1, only one dimension of noise
      noiseType: NoiseType.Perlin,
      frequency: 0.05,
      seed: 98078769, //aparentemente o seed é um id unico de noises
    );

    final List<int> yValues = getYValuesFromRawNoise(rawNoise);

    yValues.asMap().forEach((idx, value) {
      // floor
      // as the ground of our game is in the index 5 we will add it to the value
      final notGroundArea = GameMethods.instance.notGroundArea;
      chunk[value + notGroundArea][idx] = BlocksEnum.grass;
    });

    // chunk.asMap().forEach((int indexOfRow, rowOfBlocks) {
    //   if (indexOfRow == 5) {
    //     rowOfBlocks.asMap().forEach((index, block) {
    //       chunk[5][index] = BlocksEnum.grass;
    //     });
    //   }
    //   if (indexOfRow >= 6) {
    //     rowOfBlocks.asMap().forEach((index, block) {
    //       chunk[indexOfRow][index] = BlocksEnum.dirt;
    //     });
    //   }
    // });
    return chunk;
  }

  getYValuesFromRawNoise(List<List<double>> rawNoise) {
    List<int> yValues = [];
    yValues = rawNoise.map((List<double> value) {
      return (value[0] * 10).toInt().abs();
    }).toList();
    return yValues;
  }
}
