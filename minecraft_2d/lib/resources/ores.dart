import 'package:minecraft_2d/resources/blocks.dart';

class Ore {
  final BlocksEnum block;
  final int rarity;
  Ore({required this.block, required this.rarity});

  static Ore ironOre = Ore(block: BlocksEnum.ironOre, rarity: 65);
  static Ore coalOre = Ore(block: BlocksEnum.coalOre, rarity: 65);
  static Ore goldOre = Ore(block: BlocksEnum.goldOre, rarity: 40);
  static Ore diamondOre = Ore(block: BlocksEnum.diamondOre, rarity: 35);
}
