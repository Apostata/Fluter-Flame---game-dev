# Ores
using `Perlin noise` (detailed explaned by [Khan academy]('https://pt.khanacademy.org/computing/computer-programming/programming-natural-simulations/programming-noise/a/perlin-noise')), we will generate a 2d pattern for the ores, and then we will use this pattern to generate the ores in the world. so the frequency of `Perlin noise` to increase amplitude, so more frequency, more contrasted patches of grayscale noise to spread more the patches.

## Ores generation
lets create a file `ores.dart` at `resources/ores.dart` and add the following code:
```dart
class Ore {
  final BlocksEnum block;
  final int rarity;
  Ore({required this.block, required this.rarity});

  static Ore ironOre = Ore(block: BlocksEnum.ironOre, rarity: 65);
  static Ore coalOre = Ore(block: BlocksEnum.coalOre, rarity: 65);
  static Ore goldOre = Ore(block: BlocksEnum.goldOre, rarity: 40);
  static Ore diamondOre = Ore(block: BlocksEnum.diamondOre, rarity: 35);
}
```

at gameMethods.dart we will add a method to process the noise:
```dart

class GameMethods{
	List<List<int>> processNoise(List<List<double>> noise) {
    List<List<int>> processedNoise = List.generate(
      noise.length,
      (index) => List.generate(
        noise[0].length,
        (idx) => 255,
      ),
    );

    for (int i = 0; i < noise.length; i++) {
      for (int k = 0; k < noise[0].length; k++) {
        int value = (0x80 + 0x80 * noise[i][k]).floor(); //grayscale
        processedNoise[i][k] = value;
      }
    }
    return processedNoise;
  } // tow dimension noise
}
```

Lets create a processNoise method at `utils/game_methods.dart` that will process the noise generated by the `noise2` method from the `noise` package, and will generate something like this:
![image](minecraft_2d/perlin_greyscale.png)  

```dart

```
this calc above will generate a 2d noise, that varies from 0 to 255, and then we will process this noise to generate the ores, so we define a value based on the rarity of the ore (difined at Ore class).

Now lets add then to the chunk stone blocks, updating the `chunk_generation_methods.dart` file:
```dart
class ChunkGenerationMethods{
	...
	List<List<BlocksEnum?>> addOreTochunk(
      List<List<BlocksEnum?>> chunk, Ore ore) {
    List<List<double>> rawNoise = noise2(
      chunkHeight,
      chunkWidth,
      noiseType: NoiseType.Perlin,
      frequency: 0.1,
      seed: Random().nextInt(11000000),
    );

    List<List<int>> processedNoise =
        GameMethods.instance.processNoise(rawNoise);

    processedNoise.asMap().forEach((rowidx, rowOfProcessedNoise) {
      rowOfProcessedNoise.asMap().forEach((idx, value) {
        if (value < ore.rarity && chunk[rowidx][idx] == BlocksEnum.stone) {
          chunk[rowidx][idx] = ore.block;
        }
      });
    });

    return chunk;
  }
}
```



$\leftarrow$ [Back](README.md)