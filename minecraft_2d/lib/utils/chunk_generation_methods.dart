import 'dart:math';

import 'package:fast_noise/fast_noise.dart';
import 'package:minecraft_2d/global/game_reference.dart';
import 'package:minecraft_2d/resources/biomes.dart';
import 'package:minecraft_2d/resources/blocks.dart';
import 'package:minecraft_2d/resources/structures.dart';
import 'package:minecraft_2d/utils/constants.dart';
import 'package:minecraft_2d/utils/game_methods.dart';

import '../structures/trrees.dart';

class ChunkGenerationMethods {
  static ChunkGenerationMethods get instance {
    return ChunkGenerationMethods();
  }

  ///
  /// Generates a null chunk (piece of soil) with the given width and height, filled with null
  ///
  List<List<BlocksEnum?>> generateNullChunk() {
    return List.generate(
      chunkHeight,
      (index) => List.generate(
        chunkWidth,
        (idx) => null,
      ),
    );
  }

  ///
  /// Generates the sreen chunk with Perlin noise, first layer with grass, second layer with dirt and the rest with stone
  ///
  List<List<BlocksEnum?>> generateChunk(int chunkIdx) {
    List<List<BlocksEnum?>> chunk = generateNullChunk();
    int seed = GameReference.instance.gameReference.worldData.seed;
    BiomesEnum biomeType =
        Random().nextBool() ? BiomesEnum.desert : BiomesEnum.birchForest;
    BiomeData biome = BiomeData.getBiomeDataFor(biomeType);

    final isLeftWorldChunk = chunkIdx < 0;
    seed = isLeftWorldChunk ? seed : (seed + 1);
    List<List<double>> rawNoise = noise2(
      chunkWidth * (isLeftWorldChunk ? chunkIdx.abs() : (chunkIdx + 1)),
      1, //height 1, only one dimension of noise
      noiseType: NoiseType.Perlin,
      frequency: 0.05,
      seed: seed, //aparentemente o seed é um id unico de noises
    );

    final List<int> yValues = getYValuesFromRawNoise(rawNoise);
    yValues.removeRange(
        0, chunkWidth * (isLeftWorldChunk ? (chunkIdx.abs() - 1) : chunkIdx));
    // get the yValues from the rawNoise and remove the chunkWidth * chunkIdx values (aways getting the last chunkWidth values)
    // in others words, aways getting the yValues only for the current chunk

    chunk = generatePrimarySoil(chunk, yValues, biome.primarySoil);
    chunk = generateSecondarySoil(chunk, yValues, biome.secondarySoil);
    chunk = generateStoneSoil(chunk);
    chunk = addStructureToChunk(chunk, yValues, biome.structures);
    chunk = addOreTochunk(chunk, BlocksEnum.ironOre);

    return chunk;
  }

  ///
  /// Generates the primary soil (grass) with the given yValues and blockEnum
  ///
  List<List<BlocksEnum?>> generatePrimarySoil(
      List<List<BlocksEnum?>> chunk, List<int> yValues, BlocksEnum block) {
    yValues.asMap().forEach((int idx, value) {
      chunk[value][idx] = block;
    });

    return chunk;
  }

  ///
  /// Generates the secondary soil (dirt) with the given yValues and blockEnum
  ///
  List<List<BlocksEnum?>> generateSecondarySoil(
      List<List<BlocksEnum?>> chunk, List<int> yValues, BlocksEnum block) {
    final int freeAreaMax = GameMethods.instance.maxSecondarySoilHeight;
    yValues.asMap().forEach((int idx, value) {
      for (int i = value + 1; i <= freeAreaMax; i++) {
        chunk[i][idx] = block;
      }
    });

    return chunk;
  }

  ///
  /// Generates the stone soil with the given chunk
  ///
  List<List<BlocksEnum?>> generateStoneSoil(List<List<BlocksEnum?>> chunk) {
    final int freeArea = GameMethods.instance.maxSecondarySoilHeight;
    final int freeAreaMaxPlusOne = freeArea + 1;
    for (int width = 0; width < chunkWidth; width++) {
      for (int position = freeAreaMaxPlusOne;
          position < chunk.length;
          position++) {
        chunk[position][width] = BlocksEnum.stone;
      }
    }

    final int x1 = Random().nextInt(chunkWidth ~/ 2);
    final int x2 = x1 + Random().nextInt(chunkWidth ~/ 2);
    chunk[freeArea].fillRange(x1, x2, BlocksEnum.stone);

    return chunk;
  }

  ///
  /// Adds the structures to the chunk
  ///
  List<List<BlocksEnum?>> addStructureToChunk(
    List<List<BlocksEnum?>> chunk,
    List<int> yValues,
    List<Structure> structures,
  ) {
    structures.asMap().forEach((idx, structure) {
      for (int ocurrence = 1;
          ocurrence <= structure.strucuresPerChunk;
          ocurrence++) {
        final int structureXPosition =
            Random().nextInt(chunkWidth - structure.maxWidth);
        final int structureYposition =
            (yValues[structureXPosition + structure.maxWidth ~/ 2] - 1);

        for (int indexOfRow = 0;
            indexOfRow < structure.structure.length;
            indexOfRow++) {
          List<BlocksEnum?> rowOfBlocks = structure.structure[indexOfRow];

          rowOfBlocks.asMap().forEach((idx, block) {
            if (chunk[structureYposition - indexOfRow]
                    [structureXPosition + idx] ==
                null) {
              chunk[structureYposition - indexOfRow][structureXPosition + idx] =
                  block;
            }
          });
        }
      }
    });

    return chunk;
  }

  List<List<BlocksEnum?>> addOreTochunk(
      List<List<BlocksEnum?>> chunk, BlocksEnum block) {
    List<List<double>> rawNoise = noise2(
      chunkHeight,
      chunkWidth,
      noiseType: NoiseType.Perlin,
      frequency: 0.055,
      seed: Random().nextInt(11000000),
    );

    List<List<int>> processedNoise =
        GameMethods.instance.processNoise(rawNoise);

    processedNoise.asMap().forEach((rowidx, rowOfProcessedNoise) {
      rowOfProcessedNoise.asMap().forEach((idx, value) {
        if (value < 90 && chunk[rowidx][idx] == BlocksEnum.stone) {
          chunk[rowidx][idx] = block;
        }
      });
    });

    return chunk;
  }

  ///
  /// Generates the X nad Y values from the [rawNoise] list
  ///
  getYValuesFromRawNoise(List<List<double>> rawNoise) {
    List<int> yValues = [];
    final int freeArea = GameMethods.instance.notGroundArea;

    yValues = rawNoise.map((List<double> value) {
      return (value[0] * 10).toInt().abs() + freeArea;
    }).toList();
    return yValues;
  }
}
