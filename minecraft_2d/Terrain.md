# Terrain
## Make Procedural terrain generation
Lets create a randon terrain with Procedural terrain generation concept, using the `fast_noise` package
`flutter pub add fast_noise`  using the `Perlin noise` (detailed explaned by [Khan academy]('https://pt.khanacademy.org/computing/computer-programming/programming-natural-simulations/programming-noise/a/perlin-noise'))

lets create a constants file `utils/constants.dart` whith the chunk values:
```dart
const int chunkWidth = 16; //16 columns of blocks
const int chunkHeight = 25; //25 rows of blocks

```

now lets create a file `utils/chunk_generation_methods.dart`:
```dart	
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
  List<List<BlocksEnum?>> generateChunk() {
    List<List<BlocksEnum?>> chunk = generateNullChunk();

    List<List<double>> rawNoise = noise2(
      chunkWidth,
      1, //height 1, only one dimension of noise
      noiseType: NoiseType.Perlin,
      frequency: 0.05,
      seed: 98765493, //aparentemente o seed é um id unico de noises
    );

    final List<int> yValues = getYValuesFromRawNoise(rawNoise);
    chunk = generatePrimarySoil(chunk, yValues, BlocksEnum.grass);
    chunk = generateSecondarySoil(chunk, yValues, BlocksEnum.dirt);
    chunk = generateStoneSoil(chunk);
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
```

changing the main game to render the chunk:
```dart
class MainGame extends FlameGame {
  final WorldData worldData;
  final GameReference globalGameReference = Get.put(GameReference());
  Player playerComponent = Player();

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    camera.followComponent(playerComponent);
    add(playerComponent);
    renderChunk(ChunkGenerationMethods.instance.generateChunk());
  }

  void renderChunk(List<List<BlocksEnum?>> chunk) {
    chunk.asMap().forEach((int yIdx, rowOfBlocks) {
      rowOfBlocks.asMap().forEach((int xIdx, block) {
        if (block != null) {
          add(
            BlockComponent(
              block: block,
              blockIndex: Vector2(xIdx.toDouble(), yIdx.toDouble()),
            ),
          );
        }
      });
    });
  }
}
```

## Biomes
Lets generate the terrain accordly to the biome. For this, we will create a `/resources/biomes.dart`:
```dart
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
    // fatcory singleton
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

```

changing the `/utils/chunk_generation_methods.dart`:
```dart
... 
class ChunkGenerationMethods {
  ...
    List<List<BlocksEnum?>> generateChunk() {
    List<List<BlocksEnum?>> chunk = generateNullChunk();

    BiomesEnum biomeType =
        Random().nextBool() ? BiomesEnum.desert : BiomesEnum.birchForest; //temporary
    BiomeData biome = BiomeData.getBiomeDataFor(biomeType);

    List<List<double>> rawNoise = noise2(
      chunkWidth,
      1, //height 1, only one dimension of noise
      noiseType: NoiseType.Perlin,
      frequency: 0.05,
      seed: 98765493, //aparentemente o seed é um id unico de noises
    );

    final List<int> yValues = getYValuesFromRawNoise(rawNoise);
    // chunk = generatePrimarySoil(chunk, yValues, BlocksEnum.grass);
    chunk = generatePrimarySoil(chunk, yValues, biome.primarySoil);
    chunk = generateSecondarySoil(chunk, yValues, biome.secondarySoil);
    chunk = generateStoneSoil(chunk);
    return chunk;
  }
  ...
}
...
```

## Continuative em Consequetive Chunk generatrion

lets generate continuative chunks in both sides of the initial chunk (left and right), following the same noise pattern. 

firts, lets add this variables to the world data at `lib/globals/world_data.dart`:
```dart
class WorldData {
  final int seed;
  WorldData({required this.seed});
  PlayerData playerData = PlayerData();

  List<List<BlocksEnum?>> rightWorldChunks = List.generate(
    chunkHeight,
    (index) => [],
  );
  List<List<BlocksEnum?>> leftWorldChunks = List.generate(
    chunkHeight,
    (index) => [],
  );
}
```

now lets update our `utils/chunkGenerationMethods.dart` class:
```dart	
...
class ChunkGenerationMethods {
  ...
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
    return chunk;
  }
}
```

now, lets update the `utils/game_methods.dart` class:
```dart
...
class GameMethods {
  ...
  void addWorldChunk(List<List<BlocksEnum?>> chunk, bool isLeftWorldChunk) {
    if (isLeftWorldChunk) {
      final leftWorldChunks =
          GameReference.instance.gameReference.worldData.leftWorldChunks;

      chunk.asMap().forEach((yIdx, row) {
        leftWorldChunks[yIdx].addAll(row);
      });
    } else {
      final rightWorldChunks =
          GameReference.instance.gameReference.worldData.rightWorldChunks;

      chunk.asMap().forEach((yIdx, row) {
        rightWorldChunks[yIdx].addAll(row);
      });
    }
  }

  List<List<BlocksEnum?>> getIndividualChunk(int chunkIdx) {
    final isLeftWorldChunk = chunkIdx < 0;

    final List<List<BlocksEnum?>> chunk = [];
    final worldChunks = !isLeftWorldChunk
        ? GameReference.instance.gameReference.worldData.rightWorldChunks
        : GameReference.instance.gameReference.worldData.leftWorldChunks;
    worldChunks.asMap().forEach((yIdx, rowOfCombinedBlocks) {
      List<BlocksEnum?> currChunk = rowOfCombinedBlocks.sublist(
        chunkWidth * (isLeftWorldChunk ? (chunkIdx.abs() - 1) : chunkIdx),
        chunkWidth * (isLeftWorldChunk ? (chunkIdx.abs()) : (chunkIdx + 1)),
      );
      if (isLeftWorldChunk) currChunk = currChunk.reversed.toList();
      // to the noise be generated in the right way when the chunk index is negative

      chunk.add(currChunk);
    });
    return chunk;
  }
}

```

and then the MainGame `lib/main-game.dart`:
```dart
class MainGame extends FlameGame {
  final WorldData worldData;
  final GameReference globalGameReference = Get.put(GameReference());
  Player playerComponent = Player();

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    camera.followComponent(playerComponent);
    add(playerComponent);
    GameMethods.instance
        .addWorldChunk(ChunkGenerationMethods.instance.generateChunk(-1), true);
    GameMethods.instance
        .addWorldChunk(ChunkGenerationMethods.instance.generateChunk(0), false);
    GameMethods.instance
        .addWorldChunk(ChunkGenerationMethods.instance.generateChunk(1), false);
    renderChunk(-1);
    renderChunk(0);
    renderChunk(1);
  }

  void renderChunk(int chunkIdx) {
    final currChunk = GameMethods.instance.getIndividualChunk(chunkIdx);
    currChunk.asMap().forEach((int yIdx, rowOfBlocks) {
      rowOfBlocks.asMap().forEach((int xIdx, block) {
        if (block != null) {
          add(
            BlockComponent(
              block: block,
              blockIndex: Vector2(
                  (chunkWidth * chunkIdx) + xIdx.toDouble(), yIdx.toDouble()),
            ),
          );
        }
      });
    });
  }
}
```
## Update and render dynamic chunks
So now, we will render the chunks based on the player's position. 
in  the `utils/game_methods.dart` we will create a get `playerXposition` and another get `currentChunk`:
the `playerXposition` will tell us where the player is tho get the `currentChunk`, to allow us to render the chunks dynamically based on the player position, and around him.

```dart
...
class GameMethods {
  ...
  double get playerXposition {
    final playerPosition =
        GameReference.instance.gameReference.playerComponent.position;
    return playerPosition.x / blockSizes.x;
  }

  int get currentChunk {
    final isLeftWorldChunk = playerXposition < 0;
    final posfix = isLeftWorldChunk ? -1 : 0;
    return (playerXposition ~/ chunkWidth) + posfix;
  }
}
```

For this, we will create a `update` method in the `MainGame` class:
```dart
class MainGame extends FlameGame {
  final WorldData worldData;
  final GameReference globalGameReference = Get.put(GameReference());
  Player playerComponent = Player();

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    camera.followComponent(playerComponent);
    add(playerComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    worldData.chunksToRender.asMap().forEach((idx, chunkIdx) {
      final rightChunkLength = worldData.rightWorldChunks[0].length;
      final leftChunkLength = worldData.leftWorldChunks[0].length;

      if (!worldData.allreadyRenderedChunks.contains(chunkIdx)) {
        if (chunkIdx >= 0) {
          if ((rightChunkLength ~/ chunkWidth) < chunkIdx + 1) {
            GameMethods.instance.addWorldChunk(
              ChunkGenerationMethods.instance.generateChunk(chunkIdx),
              false,
            );
          }
          renderChunk(chunkIdx);
          worldData.allreadyRenderedChunks.add(chunkIdx);
        } else {
          //let
          if ((leftChunkLength ~/ chunkWidth) < chunkIdx.abs() + 1) {
            GameMethods.instance.addWorldChunk(
              ChunkGenerationMethods.instance.generateChunk(chunkIdx),
              true,
            );
          }
          renderChunk(chunkIdx);
          worldData.allreadyRenderedChunks.add(chunkIdx);
        }
      }
    });
  }

  void renderChunk(int chunkIdx) {
    final currChunk = GameMethods.instance.getIndividualChunk(chunkIdx);
    currChunk.asMap().forEach((int yIdx, rowOfBlocks) {
      rowOfBlocks.asMap().forEach((int xIdx, block) {
        if (block != null) {
          add(
            BlockComponent(
              block: block,
              blockIndex: Vector2(
                  (chunkWidth * chunkIdx) + xIdx.toDouble(), yIdx.toDouble()),
            ),
          );
        }
      });
    });
  }
}

```
## unrender chunks
Now, we will unrender the chunks that are not in the player's range. For this we will update the block component to verify if the block is in the player's range, and if not, we will remove it from the game. 

```dart
class BlockComponent extends SpriteComponent {
	...
	 @override
  void update(double dt) {
    super.update(dt);
    final worldData = GameReference.instance.gameReference.worldData;
    final chunksToRender = worldData.chunksToRender;
    final allreadyRenderedChunks = worldData.allreadyRenderedChunks;

    if (!chunksToRender.contains(chunkIdx)) {
      removeFromParent();
      allreadyRenderedChunks.remove(chunkIdx);
    }
  }
}
```

$ \gets $ [Back](README.md)