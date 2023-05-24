import 'package:minecraft_2d/resources/blocks.dart';
import 'package:minecraft_2d/resources/structures.dart';
import 'package:minecraft_2d/structures/plants.dart';
import 'package:minecraft_2d/structures/trrees.dart';

enum BiomesEnum {
  desert,
  birchForest,
}

class BiomeData {
  final BlocksEnum primarySoil;
  final BlocksEnum secondarySoil;
  final List<Structure> structures;

  BiomeData({
    required this.primarySoil,
    required this.secondarySoil,
    required this.structures,
  });

  factory BiomeData.getBiomeDataFor(BiomesEnum biome) {
    //
    switch (biome) {
      case BiomesEnum.desert:
        return BiomeData(
          primarySoil: BlocksEnum.sand,
          secondarySoil: BlocksEnum.sand,
          structures: [cactus, deadBush],
        );
      case BiomesEnum.birchForest:
        return BiomeData(
          primarySoil: BlocksEnum.grass,
          secondarySoil: BlocksEnum.dirt,
          structures: [
            birchTree,
            deadBush,
            redFlower,
            purpleFlower,
            drippingWhiteFlower,
            yellowFlower,
            whiteFlower
          ],
        );
    }
  }
}
