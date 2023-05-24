import 'package:minecraft_2d/resources/blocks.dart';
import 'package:minecraft_2d/resources/structures.dart';

Structure cactus = Structure(
  structure: [
    [BlocksEnum.cactus],
    [
      BlocksEnum.cactus,
    ],
  ].reversed.toList(),
  strucuresPerChunk: 3,
  maxWidth: 1,
);

Structure deadBush = Structure(
  structure: [
    [BlocksEnum.deadBush]
  ],
  strucuresPerChunk: 3,
  maxWidth: 1,
);

Structure redFlower =
    Structure.getPlantsStructureForBlock(BlocksEnum.redFlower);
Structure purpleFlower =
    Structure.getPlantsStructureForBlock(BlocksEnum.purpleFlower);
Structure drippingWhiteFlower =
    Structure.getPlantsStructureForBlock(BlocksEnum.drippingWhiteFlower);
Structure yellowFlower =
    Structure.getPlantsStructureForBlock(BlocksEnum.yellowFlower);
Structure whiteFlower =
    Structure.getPlantsStructureForBlock(BlocksEnum.whiteFlower);
