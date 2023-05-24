import '../resources/blocks.dart';
import '../resources/structures.dart';

Structure birchTree = Structure(
  structure: [
    [
      null,
      BlocksEnum.birchLeaf,
      BlocksEnum.birchLeaf,
      BlocksEnum.birchLeaf,
      null
    ],
    [
      BlocksEnum.birchLeaf,
      BlocksEnum.birchLeaf,
      BlocksEnum.birchLeaf,
      BlocksEnum.birchLeaf,
      BlocksEnum.birchLeaf
    ],
    [
      BlocksEnum.birchLeaf,
      BlocksEnum.birchLeaf,
      BlocksEnum.birchLeaf,
      BlocksEnum.birchLeaf,
      BlocksEnum.birchLeaf
    ],
    [null, null, BlocksEnum.birchLog, null, null],
    [null, null, BlocksEnum.birchLog, null, null],
  ].reversed.toList(),
  strucuresPerChunk: 1,
  maxWidth: 5,
);
