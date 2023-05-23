import 'package:minecraft_2d/resources/blocks.dart';

enum BiomesEnum {
  desert,
  birchForest,
}

class BiomeData {
  final BlocksEnum primarySoil;
  final BlocksEnum secondarySoil;

  BiomeData({
    required this.primarySoil,
    required this.secondarySoil,
  });

  factory BiomeData.getBiomeDataFor(BiomesEnum biome) {
    //
    switch (biome) {
      case BiomesEnum.desert:
        return BiomeData(
          primarySoil: BlocksEnum.sand,
          secondarySoil: BlocksEnum.sand,
        );
      case BiomesEnum.birchForest:
        return BiomeData(
          primarySoil: BlocksEnum.grass,
          secondarySoil: BlocksEnum.dirt,
        );
    }
  }
}
