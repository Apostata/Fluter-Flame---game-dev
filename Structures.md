# Structures
Lets add some biome especific plants and trees.
Firstly we need to create a class for the Structures at `resources/structures.dart`

```dart
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
```

create some files for the structures at `structures/trees.dart` and `structures/plants.dart`
in `structures/trees.dart`:
```dart
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

```
in the `structures/plants.dart`:
```dart
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

```


Now, lets create a addStructure function at `utils/chunk_generation_methods.dart` that will add the structure to the chunk;

```dart
class ChunkGenerationMethods {
	...
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
}
```


$\leftarrow$ [Back](README.md)