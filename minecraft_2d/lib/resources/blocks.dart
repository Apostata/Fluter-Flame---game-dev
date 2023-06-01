enum BlocksEnum {
  grass,
  dirt,
  stone,
  birchLog,
  birchLeaf,
  cactus,
  deadBush,
  sand,
  coalOre,
  ironOre,
  diamondOre,
  goldOre,
  grassPlant,
  redFlower,
  purpleFlower,
  drippingWhiteFlower,
  yellowFlower,
  whiteFlower,
  birchPlank,
  craftingTable,
  cobblestone,
  bedrock,
}

class BlockData {
  final bool isCollidable;
  final double baseMiningSpeed;
  final bool breakable;

  BlockData({
    required this.isCollidable,
    required this.baseMiningSpeed,
    this.breakable = true,
  });

  factory BlockData.getBlockDataForBlock(BlocksEnum block) {
    switch (block) {
      case BlocksEnum.cactus:
      case BlocksEnum.deadBush:
      case BlocksEnum.grassPlant:
      case BlocksEnum.redFlower:
      case BlocksEnum.purpleFlower:
      case BlocksEnum.drippingWhiteFlower:
      case BlocksEnum.yellowFlower:
      case BlocksEnum.whiteFlower:
        return blockDataMap['plant']!;
      case BlocksEnum.stone:
      case BlocksEnum.cobblestone:
      case BlocksEnum.coalOre:
      case BlocksEnum.ironOre:
      case BlocksEnum.diamondOre:
      case BlocksEnum.goldOre:
        return blockDataMap['stone']!;
      case BlocksEnum.grass:
      case BlocksEnum.dirt:
      case BlocksEnum.sand:
        return blockDataMap['soil']!;
      case BlocksEnum.birchPlank:
      case BlocksEnum.craftingTable:
        return blockDataMap['woodPlank']!;
      case BlocksEnum.birchLog:
        return blockDataMap['wood']!;
      case BlocksEnum.birchLeaf:
        return blockDataMap['leaf']!;
      default:
        return blockDataMap['unbreakable']!;
    }
  }
}

final blockDataMap = {
  'soil': BlockData(
    isCollidable: true,
    baseMiningSpeed: 0.5,
  ),
  'wood': BlockData(
    isCollidable: false,
    baseMiningSpeed: 3,
  ),
  'plant': BlockData(
    isCollidable: false,
    baseMiningSpeed: 0.01,
  ),
  'leaf': BlockData(
    isCollidable: false,
    baseMiningSpeed: 0.3,
  ),
  'stone': BlockData(
    isCollidable: true,
    baseMiningSpeed: 4,
  ),
  'woodPlank': BlockData(
    isCollidable: true,
    baseMiningSpeed: 2.5,
  ),
  'unbreakable': BlockData(
    isCollidable: true,
    baseMiningSpeed: 1,
    breakable: false,
  ),
};
