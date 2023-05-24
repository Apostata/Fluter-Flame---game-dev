import 'blocks.dart';

class Structure {
  final List<List<BlocksEnum?>> structure;
  final int strucuresPerChunk;
  final int maxWidth;
  Structure({
    required this.structure,
    required this.strucuresPerChunk,
    required this.maxWidth,
  });

  factory Structure.getPlantsStructureForBlock(BlocksEnum block) {
    return Structure(
      structure: [
        [block]
      ],
      strucuresPerChunk: 1,
      maxWidth: 1,
    );
  }
}
